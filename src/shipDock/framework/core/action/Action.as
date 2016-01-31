package shipDock.framework.core.action
{
	
	import flash.utils.getQualifiedClassName;
	import shipDock.framework.core.events.ProxyedEvent;
	import starling.events.EventDispatcher;
	
	import shipDock.framework.core.command.CommandController;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.IDataProxy;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.IObserver;
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.notice.InvokeProxyedNotice;
	import shipDock.framework.core.notice.Notice;
	import shipDock.framework.core.notice.NoticeController;
	import shipDock.framework.core.notice.SDNoticeName;
	import shipDock.framework.core.observer.DataProxy;
	
	/**
	 * 逻辑代理脚本类
	 *
	 * 统一管理逻辑
	 *
	 * @author shaoxin.ji
	 *
	 */
	public class Action implements IAction, IDispose
	{
		
		private static var defaultActionTarget:Action; //此默认代理对象只会被设置一次
		
		/**
		 * 获取到此逻辑代理对象时表示逻辑本体已过期
		 *
		 * @return
		 */
		static public function get defaultAction():Action
		{
			(defaultActionTarget == null) && (defaultActionTarget = new Action()); //一个没有挂载任何命令的逻辑代理对象
			return defaultActionTarget;
		}
		
		static public function set defaultAction(value:Action):void {
			(defaultActionTarget == null) && (defaultActionTarget = value);
		}
		
		/**被代理对象*/
		protected var _proxyed:*;
		/**主题对象映射*/
		protected var _subjects:Object;
		/**消息控制器*/
		protected var _noticeController:NoticeController;
		/**命令控制器*/
		protected var _commandController:CommandController;
		/**逻辑代理控制器*/
		protected var _actionController:ActionController;
		/**是否被初始化*/
		protected var _isInit:Boolean;
		
		/**逻辑代理名*/
		private var _actionName:String;
		/**消息侦听集合*/
		private var _commandListeners:Object;
		/**触发被代理对象逻辑调用的消息缓存*/
		private var _invokeProxyedNotice:InvokeProxyedNotice;
		
		public function Action(name:String = null)
		{
			this._actionName = name;
			this._subjects = {};
			this._commandListeners = {};
			this._actionController = ActionController.getInstance();
			this._commandController = CommandController.getInstance();
			this._noticeController = NoticeController.getInstance();
			
			this._actionController.addAction(this.actionName, this);
		}
		
		/**
		 * 销毁脚本
		 *
		 */
		public function dispose():void
		{
			this.cleanNotices();
			this.resetPreregisteredCommand();
			this.cleanProxyedEvents();
			
			ObjectPoolManager.getInstance().toPool(this._invokeProxyedNotice);
			this._commandController.removeAction(this);
			this._commandListeners = null;
			this._commandController = null;
			this._invokeProxyedNotice = null;
			this._proxyed = null;
		}
		
		protected function initNotices():void {
			this.addNotice(SDNoticeName.SD_INVOKE_PROXYED, this.invokeProxyed);
		}
		
		protected function cleanNotices():void {
			this.removeNotice(SDNoticeName.SD_INVOKE_PROXYED, this.invokeProxyed);
		}
		
		/**
		 * 初始化逻辑代理感兴趣的消息和命令
		 *
		 */
		protected function setPreregisteredCommand():void
		{
			var list:Array = this.preregisteredCommand;
			var i:int = 0;
			var max:int = list.length;
			var name:String;
			var cls:Class;
			while (i < max)
			{
				name = list[i];
				if (!!name)
				{
					cls = this._actionController.getPreregisteredCommand(name);
					if (!!cls) //感兴趣的命令，用于处理一族消息集合
						this.registered(name, cls);
					else //感兴趣的消息，用于处理广播消息
						this.addNotice(name, this.actionNotify);
				}
				i++;
			}
		}
		
		/**
		 * 重置逻辑代理感兴趣的消息和命令
		 *
		 */
		protected function resetPreregisteredCommand():void
		{
			var list:Array = this.preregisteredCommand;
			var i:int = 0;
			var max:int = list.length;
			var name:String;
			var cls:Class;
			while (i < max)
			{
				name = list[i];
				if (!!name)
				{
					cls = this._actionController.getPreregisteredCommand(name);
					if (!!cls) //移除命令
						this._commandController.removeCommand(this, name);
					else //移除消息
						this.removeNotice(name, this.actionNotify);
				}
				i++;
			}
		}
		
		
		/**
		 * 统一处理外部传入的消息
		 * 
		 * @param	notice
		 * @return
		 */
		protected function actionNotify(notice:INotice):* {
			return null;
		}
		
		/**
		 * 设置数据代理的绑定
		 * 
		 * @param	dataProxyName 数据代理名
		 * @param	isUnbind 是否为取消绑定操作
		 */
		protected function bindDataProxy(dataProxyName:String):void {
			var dataProxy:IDataProxy = this.getDataProxy(dataProxyName);
			(dataProxy) && dataProxy.registered(this);
		}
		
		/**
		 * 取消数据代理的绑定
		 * 
		 * @param	dataProxyName 数据代理名
		 * @param	isUnbind 是否为取消绑定操作
		 */
		protected function unbindDataProxy(dataProxyName:String):void {
			var dataProxy:IDataProxy = this.getDataProxy(dataProxyName);
			(dataProxy) && dataProxy.unsubscribe(this);
		}
		
		/**
		 * 调用被代理对象的开放接口（逻辑代理调用逻辑代理、被代理对象）
		 *
		 * @param	name
		 * @param	data
		 * @param	isNewNotice
		 * @return
		 */
		public function callProxyed(invokeName:String, data:* = null, isNewNotice:Boolean = false):*
		{
			var result:*;
			var manager:ObjectPoolManager = ObjectPoolManager.getInstance();
			(this._invokeProxyedNotice == null) && (this._invokeProxyedNotice = manager.fromPool(InvokeProxyedNotice, invokeName, data));//创建消息缓存
			var notice:InvokeProxyedNotice = (isNewNotice) ? manager.fromPool(InvokeProxyedNotice, invokeName, data) : this._invokeProxyedNotice;
			notice.changeName(invokeName);
			notice.changeData(data);
			notice.isAutoDispose = false;
			result = this.sendNotice(notice);
			(isNewNotice) && manager.toPool(notice);
			return result;
		}
		
		/**
		 * 处理其他逻辑代理发送的调用被代理对象开放接口的消息处理器（逻辑代理调用逻辑代理或被代理对象）
		 * 
		 * @param	notice
		 * @return
		 */
		protected function invokeProxyed(notice:InvokeProxyedNotice):* {
			if(!this._proxyed)
				return null;
			var result:* = (this._proxyed.hasOwnProperty(notice.invokeName)) ? 
				this._proxyed[notice.invokeName](notice.data) : null;
			return result;
		}
		
		/**
		 * 更新观察者
		 * 
		 * @param	notice
		 * @return
		 */
		public function notify(notice:INotice):*
		{
			return null;
		}
		
		/**
		 * 发送消息
		 *
		 * @param	notice
		 * @return
		 */
		public function sendNotice(target:*, body:* = null, subCommand:String = null, observer:IObserver = null, autoDispose:Boolean = true):*
		{
			var result:*;
			var notice:INotice;
			if(target is INotice)
				notice = target;
			else if (target is String)
				notice = new Notice(target, body, observer, autoDispose);
			(notice && subCommand) && (notice.subCommand = subCommand);
			result = this._noticeController.sendNotice(notice);
			return result;
		}
		
		public function addNotice(noticeName:String, handler:Function):void
		{
			this._noticeController.addNotice(noticeName, this, handler);
		}
		
		public function removeNotice(noticeName:String, handler:Function):void
		{
			this._noticeController.removeNotice(noticeName, this, handler);
		}
		
		/**
		 * 设置主题
		 *
		 * @param	subject
		 */
		public function setSubject(subject:ISubject):void
		{
			if (this._subjects == null)
				return;
			this._subjects[subject.subjectName] = subject;
		}
		
		/**
		 * 移除主题
		 *
		 * @param	subject
		 */
		public function removeSubject(subject:ISubject):void
		{
			if (this._subjects == null)
				return;
			delete this._subjects[subject.subjectName];
		}
		
		/**
		 * 设置命令
		 *
		 * 子类覆盖此方法，添加命令注册代码
		 *
		 */
		protected function setCommand():void
		{
			this.setPreregisteredCommand();
		}
		
		/**
		 * 设置逻辑主体，可以是界面或其他被代理的对象
		 *
		 * @param	target
		 */
		public function setProxyed(target:*):void
		{
			if (this._isInit)
				this.dispose(); //重复调用此方法是执行这里
			else
				this._isInit = true;
			this._proxyed = target;
			
			this.initNotices();
			this.initProxyedEvents();
			this.setCommand();
		}
		
		/**
		 * 初始化被代理对象的事件（被代理对象调用逻辑代理）
		 * 
		 */
		protected function initProxyedEvents():void {
			var target:EventDispatcher = this._proxyed as EventDispatcher;
			if (!target)
				return;
			target.addEventListener(ProxyedEvent.PROXYED_SEND_NOTICE_EVENT, this.proxyedSendNoticeHandler);
		}
		
		/**
		 * 清除被代理对象的事件（被代理对象调用逻辑代理）
		 * 
		 */
		protected function cleanProxyedEvents():void {
			var target:EventDispatcher = this._proxyed as EventDispatcher;
			if (!target)
				return;
			target.removeEventListener(ProxyedEvent.PROXYED_SEND_NOTICE_EVENT, this.proxyedSendNoticeHandler);
		}
		
		/**
		 * 被代理事件发送消息的事件处理函数（被代理对象调用逻辑代理）
		 * 
		 * @param	event
		 */
		protected function proxyedSendNoticeHandler(event:ProxyedEvent):void {
			this.sendNotice(event.notice, event.body, event.subCommand, event.observer, event.autoDispose);
		}
		
		/**
		 * 获取逻辑主体的一个方法
		 *
		 * @param	methodName
		 * @return
		 */
		public function getProxyedMethod(methodName:String):Function
		{
			if (this.proxyed == null)
				return null;
			return this.proxyed[methodName];
		}
		
		/**
		 * 获取一个数据代理
		 * 
		 * @param	proxyName
		 * @return
		 */
		protected function getDataProxy(proxyName:String):IDataProxy {
			return DataProxy.getDataProxy(proxyName);
		}
		
		/**
		 * 注册命令
		 *
		 * @param command
		 *
		 */
		public function registered(noticeName:String, commandClass:Class):void
		{
			if (commandClass is Class)
			{
				this._commandListeners[noticeName] = commandClass;
				this._commandController.addCommand(this, noticeName, commandClass);
			}
		}
		
		/**
		 * 注销单个命令
		 *
		 * @param commandName
		 *
		 */
		public function unsubscribe(commandName:String):void
		{
			this._commandController.removeCommand(this, commandName);
			delete this._commandListeners[commandName];
		}
		
		/**
		 * 获取一个逻辑代理对象
		 *
		 * @param	actionName
		 * @return
		 */
		public function getAction(actionName:String):IAction
		{
			var result:IAction;
			(!!this._actionController) && (result = this._actionController.getAction(actionName));
			(result == null) && (result = Action.defaultAction);
			return result;
		}
		
		/**
		 * getter 逻辑代理名
		 *
		 * @return
		 *
		 */
		public function get actionName():String
		{
			var result:String = this._actionName;
			if (result == null)
			{
				result = getQualifiedClassName(this);//逻辑代理名被设置空值时默认使用类名作逻辑代理名
				result = result.split("::")[1];
				this._actionName = result;
			}
			return result;
		}
		
		/**
		 * getter 逻辑主体
		 *
		 * @return
		 *
		 */
		public function get proxyed():*
		{
			return this._proxyed;
		}
		
		/**
		 * 此逻辑代理类感兴趣的消息、命令列表
		 *
		 */
		protected function get preregisteredCommand():Array
		{
			return [];
		}
		
	}
}