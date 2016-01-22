package  
{
	import shipDock.framework.application.Application;
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
		
		override protected function start():void 
		{
			super.start();
			
			trace("游戏开始！");
		}
		
	}

}