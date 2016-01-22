package shipDock.framework.application.component
{
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import shipDock.framework.application.events.UIEvent;
	import shipDock.framework.application.interfaces.IComponent;
	import shipDock.framework.application.manager.PopupManager;
	import shipDock.framework.core.action.Action;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.methodExecuter.MethodCenter;
	import shipDock.framework.core.notice.InvokeProxyedNotice;
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.utils.gc.reclaim;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	/**
	 * 控件基类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDComponent extends SDSprite implements IComponent
	{
		
		/**
		 * 缩放显示
		 *
		 * @param	target
		 * @param	newW
		 * @param	newH
		 * @param	isLockScale 是否等比缩放
		 */
		public static function scaleShow(target:DisplayObject, newW:Number, newH:Number, isLockScale:Boolean = true):void
		{
			var scaleW:Number = newW / target.width;
			var scaleH:Number = newH / target.height;
			if (isLockScale)
			{
				var scale:Number = Math.min(scaleW, scaleH);
				target.scaleX = scale;
				target.scaleY = scale;
			}
			else
			{
				target.scaleX = scaleW;
				target.scaleY = scaleH;
			}
		}
		
		/**
		 * 触屏检测
		 *
		 * @param	event
		 * @param	phase
		 * @return
		 */
		public static function touchCheck(event:TouchEvent, phase:* = "ended", touchTarget:DisplayObject = null):Boolean
		{
			var target:DisplayObject = (!!touchTarget) ? touchTarget : event.currentTarget as DisplayObject;
			if (target == null)
				return false;	
			var touch:Touch = event.getTouch(target.stage);
			if (!!touch)
			{
				if (phase is String)
				{
					if (touch.phase == phase)
						return true;
				}
				else if (phase is Array)
				{
					if ((phase as Array).indexOf(touch.phase) != -1)
						return true;
				}
			}
			return false;
		}
		/**控件数据*/
		private var _data:Object;
		/**控件标签*/
		private var _label:String;
		/**子控件集合*/
		private var _childrenRaw:HashMap;
		/**控件内部参数集合*/
		private var _propertiesChanged:Object;
		/**控件作为观察者时感兴趣的主题*/
		private var _subjects:Object;
		/**提示工具文字，一般情况下是字符串*/
		private var _toolTip:Object;
		/**控件是否可用*/
		private var _enabled:Boolean;
		/**是否已弹出*/
		private var _isPopup:Boolean;
		/**控件是否已被渲染*/
		private var _isRender:Boolean;
		/**控件是否已被销毁*/
		private var _isDisposed:Boolean;
		/**控件是否已初始化*/
		private var _isComponentInit:Boolean;
		/**是否在移除出显示列表后自动销毁*/
		private var _isAutoDispose:Boolean;
		/**是否应用下一帧重绘的更新机制*/
		private var _isApplyCallLater:Boolean;
		/**控件有改动时是否重绘全部子控件*/
		private var _isRedawChildren:Boolean;
		/**是否执行底层的销毁操作*/
		private var _isDisposeStarlingBase:Boolean;
		/**控件的逻辑代理对象*/
		private var _action:IAction;
		/**回调函数集合*/
		private var _callbacks:MethodCenter;
		
		public function SDComponent()
		{
			super();
		}
		
		/**
		 * 初始化
		 *
		 */
		override protected function init():void
		{
			super.init();
			this.initComponent();
			this.displayUI();
			this.addEvents();
		}
		
		protected function initComponent():void
		{
			this._isAutoDispose = false;
			this._isComponentInit = true;
			this._isApplyCallLater = true; //默认开启控件的下一帧重绘机制
			
			this._childrenRaw = new HashMap();
			this._propertiesChanged = {};
			
			this.changeProperty("reclaims", []);
			this.changePropertySet("init", true);
			
			this._callbacks = new MethodCenter();
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}
		
		protected function addReclaim(...args:Array):void {
			var list:Array = this.getPropertyChanged("reclaims");
			if(list && (args.length > 0)) {
				var n:String;
				for each(n in args) {
					(list.indexOf(name) == -1) && list.push(name);
				}
			}
		}
		
		/**
		 * 控件添加到舞台事件处理函数
		 *
		 * @param event
		 *
		 */
		override protected function addedToStageHandler(event:Event = null):void
		{
			super.addedToStageHandler(event);
			this._isRender = true;
		}
		
		/**
		 * 控件被从舞台移除事件处理函数
		 *
		 * @param event
		 *
		 */
		override protected function removedFromStageHandler(event:Event = null):void
		{
			super.removedFromStageHandler(event);
			this._isRender = false;
			(this._isAutoDispose) && this.dispose();
		}
		
		/**
		 * 添加事件
		 *
		 */
		protected function addEvents():void
		{
		}
		
		/**
		 * 移除事件
		 *
		 */
		protected function removeEvents():void
		{
		}
		
		/**
		 * 显示控件，包括显示控件的子控件
		 *
		 * @param event
		 *
		 */
		protected function displayUI():void
		{
			this.initChildrenRaw();
			this.displayChildren();
			this.createUI(); //子类在这里改写创建界面的行为
			this.invalidate();
		}
		
		protected function initChildrenRaw():void
		{
		
		}
		
		/**
		 * 初始化控件显示，用于在初始化的时候方便加入控件所需的子显示对象
		 *
		 */
		protected function displayChildren():void
		{
			if (this._childrenRaw == null)
				return;
			var i:int = 0;
			var list:Array = this._childrenRaw.keys;
			var max:int = list.length;
			while (i < max)
			{
				var child:DisplayObject = this._childrenRaw.getValue(list[i]) as DisplayObject;
				(!!child) && this.addChild(child);
				i++;
			}
		}
		
		/**
		 * 通知控件根据观察的主题做出更新
		 *
		 */
		public function notify(notice:INotice):*
		{
			var result:*;
			if(notice is InvokeProxyedNotice) {
				result = this.proxyCalled(notice as InvokeProxyedNotice);
			}
			return result;
		}
		
		protected function proxyCalled(notice:InvokeProxyedNotice):* {
			var method:Function = (notice) ? this[notice.name] : null;
			var result:* = (method) ? method(notice.data) : null;
			return result;
		}
		
		/**
		 * 设置控件感兴趣的主题
		 *
		 */
		public function setSubject(subject:ISubject):void
		{
			(this._subjects == null) && (this._subjects = {});
			this._subjects[subject.subjectName] = subject;
		}
		
		public function removeSubject(subject:ISubject):void
		{
			if (this._subjects.hasOwnProperty(subject.subjectName))
				delete this._subjects[subject.subjectName];
		}
		
//		/*
//		 * 覆盖此方法，执行子类作为观察者被通知主题状态有更改时的操作
//		 *
//		 */
//		public function sendNotice(target:*, body:* = null, subCommand:String = null, observer:IObserver = null, autoDispose:Boolean = true):*
//		{
//			var result:*;
//			var notice:INotice;
//			if(target is INotice) {
//				notice = target;
//			}else if (target is String) {
//				notice = new Notice(target, body, observer, autoDispose);
//			}
//			result = NoticeManager.sendNotice(target);
//			return result;
//		}
//		
//		public function addNotice(noticeName:String, handler:Function):void
//		{
//			NoticeManager.addNotice(noticeName, this, handler);
//		}
//		
//		public function removeNotice(noticeName:String, handler:Function):void
//		{
//			NoticeManager.removeNotice(noticeName, this, handler);
//		}
		
		/*
		 * 设置视图的逻辑代理对象
		 *
		 */
		public function setAction(value:IAction):void
		{
			this._action = value;
			this._action.setProxyed(this);
		}
		
		/**
		 * 创建控件界面
		 *
		 * 子类在这里改写初始化的行为
		 *
		 */
		protected function createUI():void
		{
		
		}
		
		/**
		 * 修改临时属性，用于保存属性
		 *
		 */
		protected function changeProperty(name:String, value:*):void
		{
			(this._propertiesChanged == null) && (this._propertiesChanged = {});
			this._propertiesChanged[name] = value;
		}
		
		/**
		 * 获取临时属性中的值
		 *
		 */
		protected function getPropertyChanged(name:String):*
		{
			return (!!this._propertiesChanged) ? this._propertiesChanged[name] : null;
		}
		
		/**
		 * 修改临时属性的改动标记，用于标出属性是否被修改，与属性成对存在
		 *
		 */
		protected function changePropertySet(name:String, isSet:Boolean):void
		{
			this.changeProperty(name + "Set", isSet);
		}
		
		/**
		 * 判断控件的内部参数是否被修改过
		 *
		 */
		protected function isPropertySet(propName:String, isResetProperty:Boolean = false):Boolean
		{
			var result:Boolean;
			if (!!this._propertiesChanged)
			{
				result = this._propertiesChanged[propName + "Set"];
				if (this._propertiesChanged.hasOwnProperty(propName + "Set") && isResetProperty)
					delete this._propertiesChanged[propName + "Set"];
			}
			return result;
		}
		
		/**
		 * 销毁控件
		 *
		 */
		override public function dispose():void
		{
			if (this._isDisposed)
				return;
			this.removeEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			this.removeEvents();
			if (this._isDisposeStarlingBase)
				super.dispose(); //底层的销毁操作
				
			this._isDisposed = true;
			
			this.disposeSubject();
			this.disposeAction();
			
			if (!!this._childrenRaw)
			{
				this.disposeChildraw();
				this._childrenRaw.clear();
			}
			
			this.removeChildren();
			
			this.disposeData();
			reclaim(this._callbacks);
			
			this._childrenRaw = null;
			this._callbacks = null;
			
			this.dispatchEventWith(UIEvent.UI_DISPOSED_EVENT);
			
		}
		
		protected function disposeAction():void
		{
			if (!!this._action)
			{
				this._action.dispose();
				this._action = null;
			}
		}
		
		protected function disposeSubject():void
		{
			for (var k:*in this._subjects)
			{
				var subject:ISubject = this._subjects[k];
				(!!subject) && subject.unsubscribe(this);
			}
			this._subjects = null;
		}
		
		protected function disposeChildraw():void
		{
			this.walkChildraw(this.disposeChild);
		}
		
		protected function disposeChild(target:*):void
		{
			if (!!target)
			{
				if (target is DisplayObject)
				{
					(target as DisplayObject).removeFromParent();
					(!this._isDisposeStarlingBase) && (target as DisplayObject).dispose();
				}
				else
					(target is IDispose) && target.dispose();
			}
		}
		
		protected function disposeData():void
		{
			var list:Array = this.getPropertyChanged("reclaims");
			(!!this._propertiesChanged) && (this._propertiesChanged = null);
			var n:String;
			for each(n in list) {
				this[n] = null;
			}
			this._data = null;
		}
		
		/**
		 * 更新控件界面
		 *
		 */
		public function invalidate():void
		{
			if (this._isApplyCallLater)
				this.addEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, this.invalidateHandler);
				this.redraw();
			}
		}
		
		/**
		 * 将重绘控件操作推迟到下一帧执行
		 *
		 */
		public function invalidateHandler(event:Event = null):void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			this.redraw();
			this.dispatchEventWith(UIEvent.REDRAW_UI_EVENT);
		}
		
		/**
		 * 移动控件位置
		 *
		 */
		public function move(point:Point):void
		{
			this.x = point.x;
			this.y = point.y;
		}
		
		/**
		 * 重绘控件
		 *
		 */
		public function redraw():void
		{
			(this.isPropertySet("resize", true)) && this.resize();
			if (this.getPropertyChanged("dataSame"))
				this.applySameData();
			else
			{
				if (this.isPropertySet("data", true))
				{
					this._data = this.getPropertyChanged("data");
					if (!!this._data)
						this.applyData();
					else
						this.applyNullData();
				}
			}
			if (this.isPropertySet("toolTip"))
			{
				//TODO 更新提示
			}
			(this._isRedawChildren) && this.walkChildraw(this.redrawChild); //更新子控件列表中的控件
			(this.isPropertySet("enabled", true)) && this.checkEnabled();
			if (this.isPropertySet("init", true) && !this.isCreation)
			{ //首次初始化
				this.changeProperty("isCreation", true);
				this._callbacks.useCallback("creationComplete");
				this.dispatchEvent(new UIEvent(UIEvent.CREATION_EVENT));
			}
		}
		
		protected function applyData():void
		{
		
		}
		
		protected function applySameData():void
		{
		
		}
		
		protected function applyNullData():void
		{
		
		}
		
		protected function applyAllData():void {
			var d:Object = this.data;
			if (d == null)
				return;
			for (var k:* in d) {
				if(this.hasOwnProperty(k))
					this[k] = d[k];
			}
		}
		
		/**
		 * 更新子控件
		 *
		 */
		private function redrawChild(target:DisplayObject):void
		{
			(target is IComponent) && (target as IComponent).redraw(); //更新子控件
		}
		
		/**
		 * 检测控件是否可用时的操作
		 *
		 */
		protected function checkEnabled():void
		{
			this._enabled = this.getPropertyChanged("enabled");
			this.touchable = this.enabled;
		}
		
		/**
		 * 遍历子控件集合中的子控件，遍历过程中执行特定操作
		 *
		 * @param option 遍历过程中对子控件执行操作时使用的回调函数，需要一个DisplayObject类型和一个Object类型的参数
		 * @param args 执行对子控件操作的回调函数时所需的参数
		 *
		 */
		protected function walkChildraw(option:Function):void
		{
			for each (var item:DisplayObject in this._childrenRaw)
			{
				(!!option) && option.call(this, item);
			}
		}
		
		public function setSize(w:Number, h:Number, isLockScale:Boolean = true):void
		{
			this.changeProperty("resizeW", w);
			this.changeProperty("resizeH", h);
			this.changeProperty("isLockScale", isLockScale);
			this.changePropertySet("resize", true);
			this.invalidate();
		}
		
		/**
		 * 控件尺寸更改时的操作
		 *
		 */
		public function resize():void
		{
			var w:Number = this.getPropertyChanged("resizeW");
			var h:Number = this.getPropertyChanged("resizeH");
			if (isNaN(w) || isNaN(h))
				return;
			var isLockScale:Boolean = this.getPropertyChanged("isLockScale");
			SDComponent.scaleShow(this, w, h, isLockScale);
		}
		
		/**
		 * 获取子控件
		 *
		 */
		public function getChildraw(name:String):DisplayObject
		{
			return (!!this._childrenRaw) ? (this._childrenRaw.getValue(name) as DisplayObject) : null;
		}
		
		/**
		 * 添加子控件
		 *
		 * @param	name
		 * @param	value
		 */
		protected function putChildraw(value:DisplayObject, name:String = null):void
		{
			if (this._childrenRaw == null)
				return;
			(name == null) && (name = value.name);
			this._childrenRaw.put(name, value);
		}
		
		public function popup(data:Object = null, modal:Boolean = true):void
		{
			PopupManager.getInstance().addPopup(this, data, modal);
		}
		
		public function close():Boolean
		{
			var result:Boolean; //是否成功关闭弹窗
			if (PopupManager.getInstance().hasPopup(this))
			{
				PopupManager.getInstance().removePopup(this);
				result = true;
			}
			else
			{
				this.removeFromParent();
				this.dispose();
			}
			return result;
		}
		
		public function setPopup(value:Boolean):void
		{
			this._isPopup = value;
		}
		
		/**
		 * getter 是否已弹出
		 *
		 */
		public function get isPopup():Boolean
		{
			return this._isPopup;
		}
		
		/**
		 * getter 控件是否已被渲染
		 *
		 */
		public function get isRender():Boolean
		{
			return _isRender;
		}
		
		/**
		 * getter 控件是否已初始化
		 *
		 */
		public function get isComponentInit():Boolean
		{
			return _isComponentInit;
		}
		
		/**
		 * setter 控件是否可用
		 *
		 */
		public function set enabled(value:Boolean):void
		{
			this.changeProperty("enabled", value);
			this.changePropertySet("enabled", true);
			this.invalidate();
		}
		
		/**
		 * getter 控件是否可用
		 *
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * setter 控件数据
		 *
		 */
		public function set data(value:Object):void
		{
			if (value == this.data)
			{
				this.changeProperty("dataSame", true); //数据相同
				return;
			}
			this.changeProperty("data", value);
			this.changePropertySet("data", true); //标记数据属性已被修改
			this.invalidate();
		}
		
		/**
		 * getter 控件数据
		 *
		 */
		public function get data():Object
		{
			return (_data == null) ? this.getPropertyChanged("data") : this._data;
		}
		
		/**
		 * setter 控件标签
		 *
		 */
		public function set label(value:String):void
		{
			_label = value;
		}
		
		/**
		 * getter 控件标签
		 *
		 */
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * setter 提示
		 *
		 */
		public function set toolTip(value:Object):void
		{
			_toolTip = value;
		}
		
		/**
		 * getter 提示
		 *
		 */
		public function get toolTip():Object
		{
			return _toolTip;
		}
		
		/**
		 * getter 控件是否已被销毁
		 *
		 */
		public function get isDisposed():Boolean
		{
			return _isDisposed;
		}
		
		public function get isResize():Boolean
		{
			return this.getPropertyChanged("resize");
		}
		
		/**
		 * getter 是否在移除出显示列表后自动销毁
		 *
		 */
		public function get isAutoDispose():Boolean
		{
			return _isAutoDispose;
		}
		
		/**
		 * setter 是否在移除出显示列表后自动销毁
		 *
		 */
		public function set isAutoDispose(value:Boolean):void
		{
			_isAutoDispose = value;
		}
		
		public function get isCreation():Boolean
		{
			return this.getPropertyChanged("isCreation");
		}
		
		/**
		 * getter 是否执行底层的销毁操作
		 *
		 */
		public function get isDisposeStarlingBase():Boolean
		{
			return _isDisposeStarlingBase;
		}
		
		/**
		 * setter 是否执行底层的销毁操作
		 *
		 */
		public function set isDisposeStarlingBase(value:Boolean):void
		{
			_isDisposeStarlingBase = value;
		}
		
		/**
		 * getter 控件创建完毕的回调函数
		 *
		 */
		public function get creationComplete():Function
		{
			return this._callbacks.getCallback("creationComplete");
		}
		
		/**
		 * setter 控件创建完毕的回调函数
		 *
		 */
		public function set creationComplete(value:Function):void
		{
			this._callbacks.addCallback("creationComplete", value);
		}
		
		/**
		 * setter 控件创建完毕的回调函数参数
		 * 
		 */
		public function set creationCompleteParams(value:Array):void {
			this._callbacks.setMehodArgs("creationComplete", value);
		}
		
		/**
		 * getter 控件有改动时是否重绘全部子控件
		 *
		 */
		public function get isRedawChildren():Boolean
		{
			return _isRedawChildren;
		}
		
		/**
		 * setter 控件有改动时是否重绘全部子控件
		 *
		 */
		public function set isRedawChildren(value:Boolean):void
		{
			_isRedawChildren = value;
		}
		
		/**
		 * getter 控件的逻辑代理对象
		 *
		 */
		public function get action():IAction
		{
			return (!!_action) ? this._action : Action.defaultAction;
		}
		
		/**
		 * getter 子控件集合
		 *
		 */
		protected function get childrenRaw():HashMap
		{
			return this._childrenRaw;
		}
		
		/**
		 * getter 获取控件类名
		 *
		 */
		public function get className():String
		{
			var result:String = getQualifiedClassName(this);
			result = result.split("::")[1];
			return result;
		}
		
		/**
		 * getter 是否应用下一帧重绘的更新机制
		 *
		 */
		public function get isApplyCallLater():Boolean
		{
			return _isApplyCallLater;
		}
		
		/**
		 * setter 是否应用下一帧重绘的更新机制
		 *
		 */
		public function set isApplyCallLater(value:Boolean):void
		{
			_isApplyCallLater = value;
		}
	}

}