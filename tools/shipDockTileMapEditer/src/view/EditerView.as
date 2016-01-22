package view 
{
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.tileMap.SDTileTestSetting;
	import shipDock.framework.application.tileMap.SDTileWorld;
	import shipDock.ui.View;
	
	/**
	 * ...
	 * @author ch.ji
	 */
	public class EditerView extends View 
	{
		
		public function EditerView() 
		{
			super(null, [["tileTest"]]);
			this._hasUIConfig = false;
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			SDTileTestSetting.testTextureName = "tile";
			var tileWorld:SDTileWorld = new SDTileWorld(79, 2, 1, SDCore.getInstance().juggler);
			this.addChild(tileWorld);
			//tileWorld.x += tileWorld.width / 2;
		}
	}

}