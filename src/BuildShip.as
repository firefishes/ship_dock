package 
{
	import flash.display.Sprite;
	
	import shipDock.framework.application.Application;
	import shipDock.framework.application.SDCore;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class BuildShip extends Sprite 
	{
		
		public function BuildShip():void 
		{
			SDCore.getInstance().setMain(this, Application, 960, 640, 60);
		}
		
	}
	
}