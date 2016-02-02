package shipDock.framework.application.component 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import shipDock.framework.application.interfaces.IUIAgent;
	import shipDock.framework.application.interfaces.ICallLater;
	import shipDock.framework.application.interfaces.IComponent;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.IObserver;
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.manager.SubjectManager;
	import shipDock.framework.core.methodExecuter.MethodCenter;
	import shipDock.framework.core.observer.UIAgentSubject;
	import shipDock.framework.core.utils.gc.reclaim;
	import shipDock.framework.core.utils.gc.reclaimArray;
	
	/**
	 * 控件代理类
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class UIAgent implements IDispose, ICallLater, IUIAgent, IObserver
	{
		
		
		/**控件数据*/
		private var _data:Object;
		/**控件事件代理，使用原生事件派发器，增加适用性*/
		private var _eventAgent:EventDispatcher;
		/**控件内部参数集合*/
		private var _propertiesChanged:Object;
		/**控件作为观察者时感兴趣的主题*/
		private var _subjects:Object;
		/**控件是否可用*/
		private var _enabled:Boolean;;
		/**控件是否已被销毁*/
		private var _isDisposed:Boolean;
		/**是否在移除出显示列表后自动销毁*/
		private var _isAutoDispose:Boolean;
		/**是否应用下一帧重绘的更新机制*/
		private var _isApplyCallLater:Boolean;
		/**控件的逻辑代理对象*/
		private var _action:IAction;
		/**回调函数集合*/
		private var _callbacks:MethodCenter;
		/**属性修改队列*/
		private var _propertyChangeList:Array;
		/**被代理的对象*/
		private var _agented:*;
		
		public function UIAgent(target:*) 
		{
			this._enabled = true;
			this._isApplyCallLater = true;
			
			this._subjects = { };
			this._agented = target;
			this._propertyChangeList = [];
			this._propertiesChanged = { };
			
			this._callbacks = new MethodCenter();
			this._eventAgent = new EventDispatcher();
			
			var subject:ISubject = SubjectManager.getSubject(UIAgentSubject.DEFAULT_NAME);
			subject.registered(this);
		}
		
		public function dispose():void {
			if (this._isDisposed)
				return;
			this._isDisposed = true;
			var k:*, subject:ISubject;
			for (k in this._subjects) {
				subject = this._subjects[k];
				(subject) && subject.unsubscribe(this);
			}			
			
			reclaim(this._action);
			
			this.disposeData();
			this.disposeAgent();
			this._eventAgent.removeEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			this._eventAgent = null;
			this._subjects = null;
			this._action = null;
		}
		
		public function notify(notice:INotice):* {
			if (notice.name == Event.ADDED_TO_STAGE) {
				(notice.data == this._agented) && this.addedToStage();
			}
		}
		
		protected function addedToStage():void {
			
		}
		
		public function setAction(value:IAction):void {
			reclaim(this._action);
			this._action = value;
			this._action.setProxyed(this._eventAgent);
		}
		
		public function setSubject(subject:ISubject):void {
			(this._subjects && !this._subjects[subject.subjectName]) && (this._subjects[subject.subjectName] = subject);
		}
		
		public function removeSubject(subject:ISubject):void {
			(this._subjects) && (delete this._subjects[subject.subjectName]);
		}
		
		protected function disposeAgent():void {
			this._callbacks.useCallback("disposed", [this._agented]);
			this._agented = null;
		}
		
		protected function disposeData():void {
			reclaimArray(this._propertyChangeList);
			this._propertiesChanged = null;
		}
		
		public function get isApplyCallLater():Boolean 
		{
			return _isApplyCallLater;
		}
		
		public function set isApplyCallLater(value:Boolean):void 
		{
			_isApplyCallLater = value;
		}
		
		public function redraw():void 
		{
			if (this.isPropertySet("data")) {
				var value:* = this.getProperty("data");
				if(this._data != value) {
					this._data = value;
					if (this._data)
						this.applyData();
					else
						this.applyNullData();
				}else
					this.applySameData();
			}
			this.commitProperties();
		}
		
		protected function applyData():void {
			
		}
		
		protected function applyNullData():void {
			
		}
		
		protected function applySameData():void {
			
		}
		
		protected function commitProperties():void {
			if (this._agented && 
				this._propertiesChanged && 
				(this._propertyChangeList.length > 0)) {
				var k:*, i:int;
				for each(k in this._propertyChangeList) {
					(this.isPropertySet(k) && this._agented.hasOwnProperty(k)) && (this._agented[k] = this.getProperty(k));
					i = this._propertyChangeList.indexOf(k);
					this._propertyChangeList.splice(i, 1);
				}
			}
		}
		
		protected function isPropertySet(k:String, isReset:Boolean = true):Boolean {
			var result:Boolean = (this._propertiesChanged) && this._propertiesChanged[k + "Set"];
			if(isReset)
				delete this._propertiesChanged[k + "Set"];
			return result;
		}
		
		public function setProperty(propertyName:String, value:*, autoCommit:Boolean = true):void {
			if (!this._propertiesChanged)
				return;
			this._propertiesChanged[propertyName] = value;
			this._propertiesChanged[propertyName + "Set"] = 1;
			(autoCommit) && this._propertyChangeList.push(propertyName);
			this.invalidate();
		}
		
		protected function getProperty(propertyName:String, isReset:Boolean = true):* {
			if (!this._propertiesChanged)
				return null;
			var result:* = this._propertiesChanged && this._propertiesChanged[propertyName];
			(isReset) && (delete this._propertiesChanged[propertyName]);
			return result;
		}
		
		public function invalidate():void 
		{
			if (!this._eventAgent)
				return;
			if(this._isApplyCallLater)
				this._eventAgent.addEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			else
				this.redraw();
		}
		
		public function invalidateHandler(event:* = null):void 
		{
			this._eventAgent.removeEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			this.redraw();
		}
		
		public function set disposed(value:Function):void {
			(this._callbacks) && this._callbacks.addCallback("disposed", value);
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			this.setProperty("data", value, false);
		}
		
		public function get action():IAction 
		{
			return _action;
		}
		
		protected function get agented():* 
		{
			return _agented;
		}
		
	}

}