package shipDock.framework.application.effect
{
	import shipDock.ui.IView;

	public class LayoutTransformEffect extends ViewTransformEffect
	{
		public function LayoutTransformEffect(current:IView = null, prev:IView = null)
		{
			super(current, prev);
		}
		
		override public function effectStart():void {
			super.effectStart();
			
			
		}
	}
}