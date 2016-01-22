package shipDock.framework.application.effect
{
	import shipDock.framework.application.interfaces.IViewTransformEffect;
	import shipDock.ui.IView;

	/**
	 * 
	 * 界面切换特效基类
	 *  
	 * @author ch.ji
	 * 
	 */	
	public class ViewTransformEffect extends SDEffect implements IViewTransformEffect
	{
		
		private var _currentView:IView;
		private var _prevView:IView;
		
		public function ViewTransformEffect(current:IView = null, prev:IView = null)
		{
			super();
			
			this._prevView = prev;
			this._currentView = current;
		}
		
		override public function effectStart():void {
			super.effectStart();
			
		}
		
		override protected function finishCallback():void {
			super.finishCallback();
		}

		public function get currentView():IView
		{
			return _currentView;
		}

		public function set currentView(value:IView):void
		{
			_currentView = value;
		}

		public function get prevView():IView
		{
			return _prevView;
		}

		public function set prevView(value:IView):void
		{
			_prevView = value;
		}


	}
}