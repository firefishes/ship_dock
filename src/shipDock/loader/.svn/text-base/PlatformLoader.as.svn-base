package shipDock.loader 
{
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.FileLoaderConfig;

	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class PlatformLoader extends Preloader 
	{
		
		private var _dataLoader:DataLoader;
		
		public function PlatformLoader(url:String, complete:Function = null, progress:Function = null) 
		{
			super(url, complete, progress);
			this._dataLoader = new DataLoader(url, this.loadCompleted, this.loadProgress);
		}
		
		override protected function loadCompleted(event:* = null):void 
		{
			super.loadCompleted(event);
			this.setLoadedData(this._dataLoader.loadedData);
		}
		
		/**
		 * 设置平台配置参数
		 * 
		 * @param	host
		 * @param	assetRoot
		 * @param	fileAsset
		 * @param	configAsset
		 * @param	localeAsset
		 * @param	locale
		 * @param	defaultHTTPTokenClass
		 * @param	SOName
		 */
		protected function setPlatformConfig(host:String, assetRoot:String, fileAsset:String, configAsset:String, localeAsset:String, locale:String, defaultHTTPTokenClass:Class = null, SOName:String = null):void {
			
			FileLoaderConfig.locale = (locale != null) ? locale : "zh_CN";
			
			SDConfig.SOName = (SOName != null) ? SOName : "shipDockSO";
			SDConfig.setServerSetting(host, assetRoot, defaultHTTPTokenClass);
			SDConfig.setFileSetting(assetRoot, fileAsset, configAsset, localeAsset);
			
		}
		
		/**
		 * 设置界面配置所在的路径
		 * 
		 * @param	path
		 */
		protected function setViewConfigPath(path:String):void {
			(path != null) && (SDConfig.viewConfigPath = path);
		}
		
		override public function commit():void 
		{
			this._dataLoader.commit();
		}
	}

}