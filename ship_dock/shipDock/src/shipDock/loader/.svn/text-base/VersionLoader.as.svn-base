package shipDock.loader 
{
	import shipDock.framework.application.manager.VersionManager;
	import shipDock.framework.core.model.SyncModel;
	import shipDock.framework.core.utils.SDUtils;
	import shipDock.framework.application.loader.DataLoader;
	
	/**
	 * 版本加载器
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class VersionLoader extends Preloader 
	{
		
		public function VersionLoader(url:String, complete:Function=null, progress:Function=null) 
		{
			super(url, complete, progress);
			
		}
		
		override public function commit():void 
		{
			super.commit();
			this.loadVersion();
		}
		
		protected function loadVersion():void {
			if (this.url == null) {
				return;
			}
			var dataLoader:DataLoader = new DataLoader(this.url, this.getVersionCallback);
			dataLoader.isAutoDispose = true;
			dataLoader.commit();
		}
		
		protected function getVersionCallback(result:Object):void {
			var data:Object = this.getVersionData(result);
			SDUtils.forIn(data, this.setAssetVersion);
			this.queueNext();
		}
		
		protected function setAssetVersion(key:String, data:Object):void 
		{
			var item:Object = data[key];
			var fileVersionKey:String = item["name"];
			
			var syncModel:SyncModel = new SyncModel(fileVersionKey, item["folder"], item["version"], 1);
			
			this.addAssetVersion(fileVersionKey, syncModel);
		}
		
		protected function addAssetVersion(key:*, value:Object):void {
			VersionManager.addAssetVersion(key, value);
		}
		
		protected function getVersionData(result:Object):Object {
			return result["resouce"];
		}
		
	}

}