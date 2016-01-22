package shipDock.framework.application.loader
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	
	/**
	 * 数据加载器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class DataLoader extends SDLoader
	{
		
		private var _dataLoader:URLLoader;
		
		public function DataLoader(url:String, complete:Function = null, progress:Function = null)
		{
			super(url, complete, progress);
			this.loadType = LoadType.LOAD_TYPE_JSON;
			this._dataLoader = new URLLoader();
			this.addEvents(this._dataLoader);
		}
		
		override public function dispose():void
		{
			
			super.dispose();
			this.unload();
			if (this.isReleaseInPool)
				return;
			this.removeEvents(this._dataLoader);
			this._dataLoader = null;
		}
		
		override public function unload():void
		{
			super.unload();
		}
		
		override protected function loadCompleted(event:* = null):void
		{
			this.setLoadedData(this._dataLoader.data);
			super.loadCompleted(event);
		}
		
		override protected function setLoadedData(result:*):void
		{
			(this.loadType == LoadType.LOAD_TYPE_JSON) && (result = JSON.parse(result));
			super.setLoadedData(result);
		}
		
		override public function commit():void
		{
			super.commit();
			if (this.loadType == LoadType.LOAD_TYPE_JSON)
				this._dataLoader.dataFormat = URLLoaderDataFormat.TEXT;
			else if (this.loadType == LoadType.LOAD_TYPE_BINARY)
			{
				this._request.method = URLRequestMethod.GET;
				this._dataLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			this._dataLoader.load(this._request);
		}
		
		override public function get rawData():*
		{
			return (!!this._dataLoader) ? this._dataLoader.data : null;
		}
		
		override public function get loadedData():*
		{
			return _loadedData;
		}
	
	}

}