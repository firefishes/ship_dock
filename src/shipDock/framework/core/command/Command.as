package shipDock.framework.core.command
{
	
	import flash.utils.getQualifiedClassName;
	
	import shipDock.framework.core.action.Action;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.ICommand;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.IObserver;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.notice.Notice;
	import shipDock.framework.core.notice.NoticeController;
	
	/**
	 * 命令基类
	 *
	 * 具备消息广播功能
	 * 具备执行其他逻辑代理里的其他命令功能
	 * 可以开启命令的自动函数机制，开启自动函数机制则自动进入子命令模式
	 * 支持子命令
	 *
	 * @author shaoxin.ji
	 *
	 */
	public class Command implements ICommand, IDispose, IPoolObject
	{
		/*命令参数*/
		private var _params:Object;
		/*主题对象的集合*/
		private var _subjects:Object;
		/*命令所在的逻辑代理对象*/
		private var _action:IAction;
		/*自动函数的后缀名，例如后缀 "Command"*/
		private var _autoExecuterTaile:String;
		/*是否根据命令名查找函数并自动执行（自动函数机制）*/
		private var _isAutoExecuteByName:Boolean;
		/*消息控制器*/
		private var _noticeController:NoticeController;
		
		public function Command(isAutoExecute:Boolean = true)
		{
			this._subjects = {};
			this.isAutoExecuteByName = isAutoExecute;
			this._noticeController = NoticeController.getInstance();
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
		 * 广播消息
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
		
		public function addNotice(noticeName:String, handler:Function, owner:* = null):void
		{
			this._noticeController.addNotice(noticeName, this, handler);
		}
		
		public function removeNotice(noticeName:String, handler:Function):void
		{
			this._noticeController.removeNotice(noticeName, this, handler);
		}
		
		/**
		 * 设置需要观察的主题
		 *
		 * @param	subject
		 */
		public function setSubject(subject:ISubject):void
		{
			(this._subjects == null) && (this._subjects = {});
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
		 * 设置命令所在的逻辑代理对象
		 *
		 * @param value
		 *
		 */
		public function setAction(value:IAction):void
		{
			this._action = value;
		}
		
		/**
		 * 销毁命令
		 *
		 */
		public function dispose():void
		{
			this._subjects = {};
			if(this.isReleaseInPool) //回收对象
				return;
			this._action = null; //清理引用
			this._params = null;
			this._noticeController = null;
		}
		
		/**
		 * 执行命令里的逻辑
		 *
		 * @param name
		 * @param params
		 *
		 */
		public function execute(notice:INotice):*
		{
			var result:*;
			if (this.action == null)
				return result; //脚本对象为空，有可能此命令已在上一个大循环被销毁
			this._params = notice.data;
			(this._isAutoExecuteByName) && (result = this.autoExecuteCommand(notice));
			return result;
		}
		
		/**
		 * 通过命令名执行对应的自动函数
		 *
		 * @param name
		 * @param params
		 * @return
		 *
		 */
		protected function autoExecuteCommand(notice:INotice):*
		{
			var methodName:String = this.createExecuteMethodName(notice);
			var result:*;
			if (methodName != null)
			{
				var method:Function = this[methodName];
				(method != null) && (result = method(notice));
			}
			return result;
		}
		
		/**
		 * 按照预定规则获取自动函数名
		 *
		 * @param	name
		 * @return
		 */
		protected function createExecuteMethodName(notice:INotice):String
		{
			var result:String = notice.subCommand;
			if (result != null)
			{
				(this._autoExecuterTaile == null) && (this._autoExecuterTaile = "Command");
				if (result.indexOf(this._autoExecuterTaile) != -1)//检验是否为合法的子命令名
					notice.autoMethodName = result;
				else
				{ //否则作为普通消息重新发送
					notice.changeName(result);
					notice.subCommand = null;
					this.sendNotice(notice);
					result = null;
				}
			}
			return result;
		}
		
		public function resetPoolObject():void {
			
		}
		
		public function getAction(actionName:String):* {
			var result:*;
			(this._action) && (result = this._action.getAction(actionName));
			return result;
		}
		
		/**
		 * 获取逻辑代理对象
		 *
		 */
		public function get action():IAction
		{
			return (this._action == null) ? Action.defaultAction : IAction(this._action);
		}
		
		/**
		 * getter 命令id
		 *
		 * @return
		 *
		 */
		public function get id():String
		{
			var result:String = getQualifiedClassName(this);
			return result.split("::")[1];
		}
		
		/**
		 * getter 命令参数
		 *
		 */
		public function get params():Object
		{
			return _params;
		}
		
		/**
		 * getter 是否根据命令名查找函数并自动执行（自动函数机制）
		 *
		 */
		public function get isAutoExecuteByName():Boolean
		{
			return _isAutoExecuteByName;
		}
		
		/**
		 * setter 是否根据命令名查找函数并自动执行（自动函数机制）
		 *
		 */
		public function set isAutoExecuteByName(value:Boolean):void
		{
			_isAutoExecuteByName = value;
		}
		
		public function get isReleaseInPool():Boolean 
		{
			return ObjectPoolManager.getInstance().isOwnPools(this);
		}
		
		public function reinitPoolObject(args:Array):void {
			((args != null) && (args.length > 0)) && (this._isAutoExecuteByName = args[0]);
		}

		public function set autoExecuterTaile(value:String):void
		{
			_autoExecuterTaile = value;
		}

	
	}
}