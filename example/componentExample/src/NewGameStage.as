package  
{
	import shipDock.framework.application.Application;
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.FileAssetQueueLoader;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.core.manager.ShareObjectManager;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import starling.events.Event;
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
		
		private function loadFont():* {
			return SDCore.getInstance().assetManager.loadFont("assets/font/font.fnt");
		}
		
		override protected function start():void 
		{
			super.start();
			
			//ShareObjectManager.getInstance().SOName = "shipDockComponentExample";
			
			var queue:QueueExecuter = new QueueExecuter();//队列执行器
			var assetQueueLoader:FileAssetQueueLoader = new FileAssetQueueLoader(["icons", "ui", "troops"], AssetType.TYPE_PNG);
			assetQueueLoader.onlyAssets = ["font"];
			queue.add(assetQueueLoader);//加载纹理
			queue.add(new FileAssetQueueLoader(["army"], AssetType.TYPE_ATF));//加载atf格式纹理
			queue.add(this.loadFont());
			queue.add(this.initStartView);//最后执行初始化界面
			
			queue.start();//启动队列
			
		}
		
		private function initStartView():void {
			var startView:StartView = new StartView();
			this.addChild(startView);
		}
	}

}