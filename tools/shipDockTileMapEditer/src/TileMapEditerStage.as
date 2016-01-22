package  
{
	import action.MainAction;
	import shipDock.framework.application.Application;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.tileMap.SDTileWorld;
	import view.EditerView;
	
	/**
	 * ...
	 * @author ch.ji
	 */
	public class TileMapEditerStage extends Application 
	{
		
		public function TileMapEditerStage() 
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
			
			var editerView:EditerView = new EditerView();
			this.addChild(editerView);
			//var map:SDTileWorld = new SDTileWorld(30, 20, 20, SDCore.getInstance().juggler);
			//this.addChild(map);
		}
		
	}

}