package shipDock.framework.core.action
{
	import shipDock.framework.application.utils.DisplayUtils;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.ISDViewAction;
	import shipDock.ui.IView;
	
	import starling.display.DisplayObject;
	
	/**
	 * 界面的逻辑代理类
	 *
	 * @author ch.ji
	 *
	 */
	public class SDViewActoin extends Action implements ISDViewAction
	{
		
		/*与此逻辑代理相关的视图界面对象*/
		private var _view:IView;
		/*与此逻辑代理相关的视图界面对象的类*/
		private var _viewClass:Class;
		
		public function SDViewActoin(name:String, cls:Class)
		{
			super(name);
			this._viewClass = cls;
		}
		
		override public function dispose():void 
		{
			//don't need dispose.
		}
		
		override public function setProxyed(target:*):void
		{
			if (!(target is IView))
				throw new Error("【SD VIEW ACTION】Error setProxyed: target must is a IView instance!");
			this._isInit = true;
			this._proxyed = target;
		}
		
		/**
		 * 创建视图界面对象
		 *
		 */
		protected function createView():void
		{
			//override it for create view instance
			(this._viewClass) && (this._view = new _viewClass());
		}
		
		/**
		 * 初始化视图界面代理
		 *
		 */
		protected function initViewAction():void
		{
			this.initProxyedEvents();
		}
		
		/**
		 * 重置视图界面代理
		 *
		 */
		protected function resetViewAction():void
		{
			this.cleanProxyedEvents();
		}
		
		/**
		 * 激活视图界面
		 *
		 */
		public function openView():void
		{
			this.initNotices();
			this.setPreregisteredCommand();
			this.createView();
			(this._view) && this._view.setAction(this); //设置代理的目标视图界面
			this.initViewAction();
		}
		
		/**
		 * 关闭视图界面
		 *
		 * 并非完全销毁，仅回收视图界面对象
		 *
		 */
		public function closeView():void
		{
			this.resetPreregisteredCommand();
			this.cleanNotices();
			this.resetViewAction();
			this.resetView();
		}
		
		protected function resetView():void
		{
			DisplayUtils.removeFromDisplay(this._view as DisplayObject, true);
			this._view = null;
			this._proxyed = null;
		}
		
		/**
		 * getter 逻辑代理类代理的视图界面对象
		 *
		 */
		public function get view():IView
		{
			return _view;
		}
	}
}