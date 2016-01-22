package shipDock.framework.application.loader
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 网页可视资源加载器（包含本地使用URL方式加载的资源）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class DisplayAssetLoader extends SDLoader
	{
		
		private var _loader:Loader;
		private var _bytesSource:ByteArray;
		private var _loaderContext:LoaderContext;
		
		public function DisplayAssetLoader(url:String, complete:Function = null, progress:Function = null)
		{
			super(url, complete, progress);
			this.loadType = LoadType.LOAD_TYPE_WEB_ASSET;
			this._loader = new Loader();
			this.addEvents(this._loader.contentLoaderInfo);
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.unload();
			if (this.isReleaseInPool)
				return;
			this.removeEvents(this._loader.contentLoaderInfo);
			this._loader = null;
		}
		
		override public function unload():void
		{
			if (this.isLoading && !!this._loader)
			{
				this._loader.unload();
			}
			super.unload();
		}
		
		override public function commit():void
		{
			super.commit();
			if (this.loadType == LoadType.LOAD_TYPE_WEB_ASSET)
			{
				this._loader.load(this._request, this._loaderContext);
				
			}
			else if (this.loadType == LoadType.LOAD_TYPE_BINARY)
			{
				if (!!this._bytesSource)
				{
					this._loader.loadBytes(this._bytesSource, this._loaderContext);
				}
			}
		}
		
		override protected function loadCompleted(event:* = null):void
		{
			this.setLoadedData(this._loader.content);
			super.loadCompleted(event);
		}
		
		override public function get rawData():*
		{
			return this._loadedData;
		}
		
		public function get loader():Loader
		{
			return _loader;
		}
		
		public function set bytesSource(value:ByteArray):void
		{
			_bytesSource = value;
		}
		
		public function get loaderContext():LoaderContext
		{
			return _loaderContext;
		}
		
		public function set loaderContext(value:LoaderContext):void
		{
			_loaderContext = value;
		}
	}

}