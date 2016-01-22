package 
{
	import flash.display.Sprite;
	import shipDock.framework.application.SDCore;
	
	/**
	 * 
	 * 项目文档类
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			SDCore.getInstance().setMain(this, NewGameStage, 960, 640, 60);//启动框架核心
		}
	}
	
}