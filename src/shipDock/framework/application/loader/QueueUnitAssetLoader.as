package shipDock.framework.application.loader
{
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import shipDock.framework.application.interfaces.ISDLoader;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 队列加载器加载单元
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class QueueUnitAssetLoader extends EventDispatcher implements ISDLoader, IPoolObject
	{
		
		private var _name:String;
		private var _url:String;
		private var _loadType:int;
		private var _queue:QueueExecuter;
		private var _currentLoader:ISDLoader;
		private var _dataLoader:DataLoader;
		private var _complete:Function;
		private var _progress:Function;
		private var _completeParams:Array;
		private var _displayAssetLoader:DisplayAssetLoader;
		
		public function QueueUnitAssetLoader(url:String, queueOwner:QueueExecuter, onComplete:Function = null, onProgress:Function = null)
		{
			super();
			this._url = url;
			this._loadType = QueueLoaderType.checkQueueLoaderType(this._url); //根据资源名称识别加载类型
			this._queue = queueOwner;
			this._complete = onComplete;
			this._progress = onProgress;
		}
		
		public function dispose():void
		{
			this.resetLoader();
			if (this.isReleaseInPool)
				return;
			this._complete = null;
			this._progress = null;
			this._queue = null;
		}
		
		private function resetLoader():void
		{
			if (!!this._currentLoader)
			{
				(this._currentLoader as EventDispatcher).removeEventListener(Event.COMPLETE, this.currentLoaderCompleteHandler);
				(this._currentLoader as EventDispatcher).removeEventListener(ProgressEvent.PROGRESS, this.currentLoaderProgressHandler);
				this._currentLoader = null;
			}
			var poolManager:ObjectPoolManager = ObjectPoolManager.getInstance();
			poolManager.toPool(this._dataLoader);
			poolManager.toPool(this._displayAssetLoader);
			
			this._dataLoader = null;
			this._displayAssetLoader = null;
		}
		
		public function resetPoolObject():void
		{
			this._complete = null;
			this._progress = null;
		}
		
		public function reinitPoolObject(args:Array):void {
			while (args.length < 4)
				args.push(null);
			this.unload();
			this._url = args[0];
			this._queue = args[1];
			this._complete = args[2];
			this._progress = args[3];
			this._loadType = QueueLoaderType.checkQueueLoaderType(this._url); //根据资源名称识别加载类型
		}
		
		private function creatLoader():void
		{
			var poolManager:ObjectPoolManager = ObjectPoolManager.getInstance();
			if (this.loadType == QueueLoaderType.QUEUE_LOADER_TYPE_DATA) //数据资源类型
			{
				(this._dataLoader == null) && (this._dataLoader = poolManager.fromPool(DataLoader, this._url, this._complete, this._progress));
				this._currentLoader = this._dataLoader;
				
			}
			else if (this.loadType == QueueLoaderType.QUEUE_LOADER_TYPE_DISPLAY_ASSET) //可显示的资源类型
			{
				(this._displayAssetLoader == null) && (this._displayAssetLoader = poolManager.fromPool(DisplayAssetLoader, this._url, this._complete, this._progress));
				this._currentLoader = this._displayAssetLoader;
			}
			if (this._currentLoader == null)
				throw new Error("【X_X】QueueUnitAssetLoader createLoader-current loader is null.")
			else
			{
				(this._currentLoader as EventDispatcher).addEventListener(Event.COMPLETE, this.currentLoaderCompleteHandler);
				(this._currentLoader as EventDispatcher).addEventListener(ProgressEvent.PROGRESS, this.currentLoaderProgressHandler);
				(this._currentLoader as EventDispatcher).addEventListener(IOErrorEvent.IO_ERROR, this.currentLoaderIOErrorHandler);
			}
		}
		
		private function currentLoaderCompleteHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, this.currentLoaderCompleteHandler);
			this.dispatchEventWith(event.type);
			this.queueNext();
		}
		
		private function currentLoaderProgressHandler(event:ProgressEvent):void
		{
			var progressEvent:Event = new Event(event.type, false, {"bytesTotal": event.bytesTotal, "bytesLoaded": event.bytesLoaded});
			this.dispatchEvent(progressEvent);
		}
		
		private function currentLoaderIOErrorHandler(event:Event):void {
			dispatchEventWith(event.type);
			this.currentLoader.load();//TODO reload count
		}
		
		/* INTERFACE shipDock.interfaces.ISDLoader */
		
		public function load():void
		{
			this.creatLoader();
			this.currentLoader.load();
		}
		
		public function unload():void
		{
			this.currentLoader.unload();
		}
		
		public function commit():void
		{
			this.load();
		}
		
		public function queueNext():void
		{
			this.dispatchEventWith(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT);
		}
		
		public function get rawData():*
		{
			return this.currentLoader.rawData;
		}
		
		public function get loadedData():*
		{
			return this.currentLoader.loadedData;
		}
		
		public function set loadType(value:int):void
		{
			//do nothing.
		}
		
		public function get loadType():int
		{
			return _loadType;
		}
		
		public function get url():String
		{
			return this._url;
		}
		
		public function set url(value:String):void
		{
			if (this._url == value)
			{
				return;
			}
			_url = value;
			this._loadType = QueueLoaderType.checkQueueLoaderType(this._url); //根据资源名称识别加载类型
			this.resetLoader();
		}
		
		public function get complete():Function
		{
			return this.currentLoader.complete;
		}
		
		public function set complete(value:Function):void
		{
			this.currentLoader.complete = value;
		}
		
		public function get progress():Function
		{
			return this.currentLoader.progress;
		}
		
		public function set progress(value:Function):void
		{
			this.currentLoader.progress = value;
		}
		
		public function set isAutoDispose(value:Boolean):void
		{
			this.currentLoader.isAutoDispose = value;
		}
		
		public function get isAutoDispose():Boolean
		{
			return this.currentLoader.isAutoDispose;
		}
		
		public function get isAutoQueueNext():Boolean
		{
			return this.currentLoader.isAutoQueueNext;
		}
		
		public function set isAutoQueueNext(value:Boolean):void
		{
			this.currentLoader.isAutoQueueNext = value;
		}
		
		public function get loaderStatu():int
		{
			return this.currentLoader.loaderStatu;
		}
		
		public function set loaderStatu(value:int):void
		{
			this.currentLoader.loaderStatu = value;
		}
		
		public function get isLoading():Boolean
		{
			return this.currentLoader.isLoading;
		}
		
		public function get isLoaded():Boolean
		{
			return this.currentLoader.isLoaded;
		}
		
		public function get isFinish():Boolean
		{
			return this.currentLoader.isFinish;
		}
		
		public function get isReady():Boolean
		{
			return this.currentLoader.isReady;
		}
		
		public function get queueSize():uint
		{
			return 1;
		}
		
		protected function get currentLoader():ISDLoader
		{
			return (!!this._currentLoader) ? this._currentLoader : new SDLoader("loader invalid.");
		}
		
		protected function get dataloader():DataLoader
		{
			return _dataLoader;
		}
		
		protected function get displayAssetLoader():DisplayAssetLoader
		{
			return _displayAssetLoader;
		}
		
		public function get isReleaseInPool():Boolean
		{
			return ObjectPoolManager.getInstance().isReleaseInPool(this);
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}

		public function get completeParams():Array
		{
			return _completeParams;
		}

		public function set completeParams(value:Array):void
		{
			_completeParams = value;
		}
		
		public function get eventDispatcher():EventDispatcher {
			return this;
		}
	}

}