package  
{
	import action.MainAction;
	import shipDock.framework.application.Application;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.FileAssetQueueLoader;
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import view.MakerView;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class UIPlanMakerStage extends Application 
	{
		
		public function UIPlanMakerStage() 
		{
			super();
			
		}
		
		override protected function setMainActionClass():void 
		{
			this._mainActionClass = MainAction;
		}
		
		private function loadFont():* {
			return SDCore.getInstance().assetManager.loadFont("assets/font/font_0.fnt");
		}
		
		override protected function start():void 
		{
			super.start();
			
			var queue:QueueExecuter = new QueueExecuter();
			queue.add(new FileAssetQueueLoader(["font_0"], AssetType.TYPE_PNG));
			queue.add(this.loadFont());
			queue.add(this.initStage);
			queue.commit();
		}
		
		private function initStage():void {
			SDConfig.viewConfigPath = Setting.FILE_ASSET + SDConfig.viewConfigPath;
			var makerView:MakerView = new MakerView();
			this.UILayer.addChild(makerView);
			
		}
	}

}