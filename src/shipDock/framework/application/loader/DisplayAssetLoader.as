package shipDock.framework.application.loader
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import shipDock.framework.core.utils.gc.reclaimLoader;
	
	/**
	 * 网页可视资源加载器（包含本地使用URL方式加载的资源）
	 *
	 * ...
	 * @author ch.ji
	 */
	public class DisplayAssetLoader extends SDLoader
	{
		
		private var _loader:Loader;
		private var _bytesSource:ByteArray;
		private var _loaderContext:LoaderContext;
		
		public function DisplayAssetLoader(source:*, complete:Function = null, progress:Function = null)
		{
			var value:String = (source is String) ? source : null;
			super(value, complete, progress);
			
			this.loadType = LoadType.LOAD_TYPE_WEB_ASSET;
			this._loader = new Loader();
			(source is ByteArray) && (this.bytesSource = source);
			this.addEvents(this._loader.contentLoaderInfo);
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.unload();
			this._bytesSource = null;
			this._loaderContext = null;
			if (this.isReleaseInPool)
				return;
			this.removeEvents(this._loader.contentLoaderInfo);
			this._loader = null;
		}
		
		override public function unload():void
		{
			(this.isLoading) && reclaimLoader(this._loader);
			super.unload();
		}
		
		override public function commit():void
		{
			super.commit();
			if (this.loadType == LoadType.LOAD_TYPE_WEB_ASSET)
				this._loader.load(this._request, this._loaderContext);
			else if (this.loadType == LoadType.LOAD_TYPE_BINARY)
				(!!this._bytesSource) && this._loader.loadBytes(this._bytesSource, this._loaderContext);
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
			this.loadType = LoadType.LOAD_TYPE_BINARY;
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