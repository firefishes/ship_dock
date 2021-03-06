package shipDock.framework.application.manager
{
	import flash.utils.getDefinitionByName;
	import shipDock.framework.application.utils.DisplayUtils;
	import shipDock.framework.core.utils.gc.reclaim;
	
	import shipDock.framework.application.events.ViewTransformEffectEvent;
	import shipDock.framework.application.interfaces.IViewTransformEffect;
	import shipDock.framework.core.action.ActionController;
	import shipDock.framework.core.command.UICommand;
	import shipDock.framework.core.interfaces.ISDViewAction;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.notice.SDNoticeName;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import shipDock.framework.core.singleton.SingletonBase;
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.utils.SDUtils;
	import shipDock.framework.core.utils.StringUtils;
	import shipDock.ui.IView;
	
	import starling.display.DisplayObject;
	
	/**
	 * 界面转换管理器
	 * 
	 * 支持starling和原生的应用
	 *
	 * @author ch.ji
	 *
	 */
	public class ViewManager extends SingletonBase
	{
		
		public static const VIEW_MANAGER:String = "viewMgr";
		
		public static const ENTER_FRAME_EVENT:String = "enterFrame";//帧事件，为了不引入具体事件类而增加的和原生相同的事件名
		
		public static function getInstance():ViewManager
		{
			return SingletonManager.singletonManager().getSingleton(VIEW_MANAGER) as ViewManager;
		}
		
		/**是否正在转换*/
		private var _isTransfroming:Boolean;
		/**即将切换到的界面*/
		private var _waitingView:IView;
		/**上一个界面*/
		private var _prevView:IView;
		/**当前界面*/
		private var _currentView:IView;
		/**显示过的历史 界面堆栈*/
		private var _viewStack:Array;
		/**界面总容器*/
		private var _viewContainer:*;
		/**界面转换执行队列*/
		private var _transformQueue:QueueExecuter;
		/**即将切换的界面类使用的构造函数列表*/
		private var _waitingViewParams:Object;
		/**记录所有使用视图逻辑代理打开的界面*/
		private var _actionViews:HashMap;
		/**显示类的基类*/
		private var _displayBaseClass:Class;
		
		public function ViewManager()
		{
			super(this, VIEW_MANAGER);
			
			this._viewStack = [];
			this._actionViews = new HashMap();
			this._transformQueue = ObjectPoolManager.getInstance().fromPool(QueueExecuter);
		}
		
		/**
		 * 设置界面总容器
		 *
		 * @param container
		 *
		 */
		public function setViewContainer(container:*, displayCls:Class = null):void
		{
			if (!!this._viewContainer)
			{
				this._viewContainer.removeEventListener(ENTER_FRAME_EVENT, this.viewTransform);
				this.cleanViewContainer();
			}
			this._displayBaseClass = (displayCls) ? displayCls : DisplayObject;
			this._viewContainer = container;
		}
		
		/**
		 * 返回上一个界面
		 *
		 */
		public function backToPrevView():void
		{
			var data:Object = this._viewStack.pop();
			if (!!data["key"])
			{
				var key:* = data["key"];
				var args:Array = data["params"];
				this.changeView(key, args);
			}
		}
		
		/**
		 * 切换界面
		 *
		 * @param target 支持界面类或者界面实例
		 * @param clsArgs
		 *
		 */
		public function changeView(target:*, clsArgs:Array = null, isInStack:Boolean = false):void
		{
			if (this._viewContainer == null)
				return;
			
			var viewAction:ISDViewAction;
			
			(!!this._waitingView) && this._waitingView.dispose(); //销毁上一个即将切换的目标界面
			
			if (target is Class)
				this._waitingView = SDUtils.createInstance(target, clsArgs);
			else if (target is IView)
				this._waitingView = target;
			else if (target is String)
			{
				viewAction = ActionController.getInstance().getAction(target) as ISDViewAction;
				if(viewAction) {
					viewAction.sendNotice(SDNoticeName.SD_UI, viewAction.actionName, UICommand.OPEN_VIEW_COMMAND);
					(!this._actionViews.isContainsKey(this._waitingView)) && this._actionViews.put(this._waitingView, viewAction);
					this._waitingView = viewAction.view;
				}
			}
			if (this._waitingView == null)
				return; //即将切换的目标界面为空则截断操作
			var clsFullName:String = StringUtils.qualifiedClassName(this._waitingView, true);
			var cls:Class = getDefinitionByName(clsFullName) as Class;
			this._waitingViewParams = {"key": cls, "params": clsArgs, "isInStack": isInStack}; //本次切换界面堆栈所需的数据
			(viewAction) && (this._waitingViewParams["key"] = viewAction.actionName);
			this._viewContainer.addEventListener(ENTER_FRAME_EVENT, this.viewTransform); //下一帧开始界面转换
		}
		
		/**
		 * 界面转换
		 *
		 * @param event
		 *
		 */
		private function viewTransform(event:*):void
		{
			this._viewContainer.removeEventListener(ENTER_FRAME_EVENT, this.viewTransform);
			
			this._transformQueue.reset(); //重置执行流程
			
			this.readyForHideView(this._currentView);
			this.readyForShowView(this._waitingView);
			
			(!!this._waitingViewParams && this._waitingViewParams["isInStack"]) && this._viewStack.push(this._waitingViewParams); //加入界面堆栈
			this._waitingViewParams = null;
			
			this._prevView = this._currentView;
			this._currentView = this._waitingView;
			this._waitingView = null;
			
			this._transformQueue.commit();
		}
		
		/**
		 * 准备界面消失的操作流程
		 *
		 * @param view
		 *
		 */
		private function readyForHideView(view:IView):void
		{
			if (!!view)
			{
				if (!!view.hideTransformEffect)
				{ //如果上一个界面有消失特效
					var transformEffect:IViewTransformEffect = view.hideTransformEffect;
					transformEffect.eventDispatcher.addEventListener(ViewTransformEffectEvent.HIDE_TRANSFORM_COMPLETE_EVENT, this.hidePrevView);
					this._transformQueue.add(view.hideTransformEffect);
				}
				else
					this._transformQueue.add(this.hidePrevView);
			}
		}
		
		/**
		 * 准备界面出现的操作流程
		 *
		 * @param view
		 *
		 */
		private function readyForShowView(view:IView):void
		{
			this._transformQueue.add(this.beforeShowCurrentView);
			if (!!view.showTransformEffect)
			{ //如果当前界面有出现特效
				var transformEffect:IViewTransformEffect = view.showTransformEffect;
				transformEffect.eventDispatcher.addEventListener(ViewTransformEffectEvent.SHOW_TRANSFORM_COMPLETE_EVENT, this.showCurrentView);
				this._transformQueue.add(view.showTransformEffect);
			}
			else
				this._transformQueue.add(this.showCurrentView);
		}
		
		/**
		 * 显示当前界面
		 *
		 * @param event
		 *
		 */
		private function showCurrentView(event:ViewTransformEffectEvent = null):void
		{
			(event) && event.target.removeEventListener(ViewTransformEffectEvent.SHOW_TRANSFORM_COMPLETE_EVENT, this.showCurrentView);
		}
		
		/**
		 * 在完全展示当前界面前
		 * 
		 */		
		private function beforeShowCurrentView():void {
			(!!this._currentView) && this._viewContainer.addChild(this._currentView as this._displayBaseClass);
		}
		
		/**
		 * 隐藏上一个界面
		 *
		 * @param event
		 *
		 */
		private function hidePrevView(event:ViewTransformEffectEvent = null):void
		{
			(event) && event.target.removeEventListener(ViewTransformEffectEvent.HIDE_TRANSFORM_COMPLETE_EVENT, this.hidePrevView);
			if (!!this._prevView)
			{
				if(this._actionViews.isContainsKey(this._prevView)) {
					var prevViewAction:ISDViewAction = this._actionViews.getValue(this._prevView, true);
					prevViewAction.sendNotice(SDNoticeName.SD_UI, prevViewAction.actionName, UICommand.CLOSE_VIEW_COMMAND);
				}else {
					DisplayUtils.removeFromDisplay(this._prevView);
					_prevView.dispose();
				}
			}
		}
		
		/**
		 * 清除总容器里的内容
		 *
		 */
		private function cleanViewContainer():void
		{
			DisplayUtils.removeChildren(this._viewContainer);
			
			reclaim(this._prevView);
			reclaim(this._waitingView);
			reclaim(this._currentView);
			
			this._prevView = null;
			this._waitingView = null;
			this._currentView = null;
		}
		
		public function get isTransfroming():Boolean
		{
			return _isTransfroming;
		}
	
	}
}