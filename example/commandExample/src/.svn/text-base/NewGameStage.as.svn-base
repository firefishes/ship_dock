package  
{
	import action.MainAction;
	import shipDock.framework.application.Application;
	import view.StartView;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class NewGameStage extends Application 
	{
		
		public function NewGameStage() 
		{
			super();
			
		}
		
		override protected function setMainActionClass():void 
		{
			this._mainActionClass = MainAction;
		}
		
		override protected function start():void 
		{
			super.start();
			
			var startView:StartView = new StartView();
			this.addChild(startView);
			
		}
	}

}