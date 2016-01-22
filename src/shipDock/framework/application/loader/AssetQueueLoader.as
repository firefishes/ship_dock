package shipDock.framework.application.loader
{
	import shipDock.framework.application.events.AssetQueueEvent;
	import shipDock.framework.application.interfaces.IAssetQueueLoader;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	import shipDock.framework.core.utils.gc.reclaim;
	import shipDock.framework.core.utils.gc.reclaimArray;
	
	import starling.events.EventDispatcher;
	
	/**
	 * 素材队列加载器基类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class AssetQueueLoader extends EventDispatcher implements IAssetQueueLoader
	{
		
		protected var _assetList:Array;
		protected var _assetType:String;
		protected var _isScale:Boolean;
		protected var _update:Function;
		protected var _complete:Function;
		protected var _queue:QueueExecuter;
		protected var _dataLoaderList:Array;
		
		private var _loaderStatu:int;
		private var _name:String;
		private var _completeEvent:AssetQueueEvent;
		private var _progressEvent:AssetQueueEvent;
		private var _unitLoadedEvent:AssetQueueEvent;
		
		public function AssetQueueLoader(list:Array, assetType:String = null, isScale:Boolean = true, update:Function = null, complete:Function = null)
		{
			super();
			
			this._dataLoaderList = [];
			this.loaderStatu = LoaderStatus.LOADER_STATU_READY; //加载队列就绪
			this._queue = ObjectPoolManager.getInstance().fromPool(QueueExecuter); //从对象池中获取一个队列
			this.setAssetQueueInfo(list, assetType, isScale, update, complete);
		}
		
		public function dispose():void
		{
			this.disposeLoaders();
			this.loaderStatu = LoaderStatus.LOADER_STATU_READY; //加载队列就绪
			var manager:ObjectPoolManager = ObjectPoolManager.getInstance();
			if (!!this._queue)
			{
				this._queue.removeEventListener(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT, this.assetQueueUnitNext);
				manager.toPool(this._queue); //将对象放回对象池
			}
			reclaimArray(this._assetList);
			manager.toPool(this._unitLoadedEvent);
			manager.toPool(this._progressEvent);
			manager.toPool(this._completeEvent);
			this._unitLoadedEvent = null;
			this._progressEvent = null;
			this._completeEvent = null;
			this._complete = null;
			this._update = null;
			if (this.isReleaseInPool)
			{
				manager.toPool(this);
				return;
			}
			reclaim(this._queue);
			this._assetList = null;
			this._queue = null;
		}
		
		public function commit():void
		{
			if (this.loaderStatu == LoaderStatus.LOADER_STATU_LOADING)
				return;
			(!this._queue) && (this._queue = ObjectPoolManager.getInstance().fromPool(QueueExecuter)); //从对象池中获取一个队列
			(!this._queue.hasEventListener(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT)) && this._queue.addEventListener(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT, this.assetQueueUnitNext);
			this.loadAsset();
		}
		
		private function assetQueueUnitNext(event:QueueExecuterEvent):void
		{
			(!this._unitLoadedEvent) && (this._unitLoadedEvent = ObjectPoolManager.getInstance().fromPool(AssetQueueEvent, AssetQueueEvent.ASSET_QUEUE_UNIT_LOADED_EVENT))
			this.dispatchEvent(this._unitLoadedEvent);
		}
		
		protected function loaderUnitComplete(data:*):void
		{
		}
		
		protected function loaderUnitProgress():void
		{
		
		}
		
		protected function loadAsset():void
		{
			var i:int = 0;
			var max:int = this._assetList.length;
			while (i < max)
			{
				var asset:* = this._assetList[i];
				if (asset is String)
				{
					var loader:QueueUnitAssetLoader = ObjectPoolManager.getInstance().fromPool(QueueUnitAssetLoader, asset, this._queue, this.loaderUnitComplete);
					loader.name = asset;
					this._dataLoaderList.push(loader);
					this._queue.add(loader);
				}
				i++;
			}
			this._queue.add(this.disposeLoaders);
			this._queue.commit();
			
			this.loaderStatu = LoaderStatus.LOADER_STATU_LOADING;
		}
		
		protected function disposeLoaders():void
		{
			var i:int = 0;
			var max:int = this._dataLoaderList.length;
			while (i < max)
			{
				var loader:QueueUnitAssetLoader = this._dataLoaderList.shift();
				reclaim(loader);
				ObjectPoolManager.getInstance().toPool(loader);
				i++;
			}
			this._dataLoaderList = [];
			this.loaderStatu = LoaderStatus.LOADER_STATU_COMPLETE;
		}
		
		protected function isStorageAsset(index:int):Boolean
		{
			return false;
		}
		
		protected function isStorageXMLAsset(index:int):Boolean
		{
			return true;
		}
		
		protected function getAssetPathForVersion(index:int):String
		{
			return this._assetList[index];
		}
		
		protected function getXMLPathForVersion(index:int):String
		{
			return this._assetList[index] + "_xml";
		}
		
		protected function assetQueueComplete():void
		{
			(!!this._complete) && this._complete();
			this.queueNext();
			(!this._completeEvent) && (this._completeEvent = ObjectPoolManager.getInstance().fromPool(AssetQueueEvent, AssetQueueEvent.ASSET_QUEUE_COMPLETE_EVENT));
			this.dispatchEvent(this._completeEvent);
		}
		
		protected function assetManagerLoadOK(ratio:Number):void
		{
			(!!this._update) && this._update(Math.floor(ratio * 100));
			if (ratio == 1)
			{
				this.loaderStatu = LoaderStatus.LOADER_STATU_FINISH;
				this.assetQueueComplete();
			}
			else
			{
				(!this._progressEvent) && (this._progressEvent = ObjectPoolManager.getInstance().fromPool(AssetQueueEvent, AssetQueueEvent.ASSET_QUEUE_PROGRESS_EVENT));
				this._progressEvent.setProgress(ratio, 1);
				this.dispatchEvent(this._progressEvent);
			}
		}
		
		/**
		 * 执行此对象所在队列的下一个队列元素
		 *
		 */
		public function queueNext():void
		{
			this.dispatchEventWith(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT);
		}
		
		/**
		 * 统一设置素材队列加载的参数信息
		 *
		 * @param	list
		 * @param	assetType
		 * @param	isScale
		 * @param	update
		 * @param	complete
		 */
		public function setAssetQueueInfo(list:Array, assetType:String, isScale:Boolean = true, update:Function = null, complete:Function = null):void
		{
			(assetType == null) && (assetType = AssetType.TYPE_PNG);
			this._update = update;
			this._complete = complete;
			this._assetList = list;
			this._assetType = assetType;
			this._isScale = isScale;
		}
		
		protected function resetAssetQueue():void
		{
			this._queue.reset();
		}
		
		public function resetPoolObject():void
		{
			this.setAssetQueueInfo([], null);
			this.resetAssetQueue();
			this.disposeLoaders();
		}
		
		public function reinitPoolObject(args:Array):void
		{
			while (args.length < 4)
				args.push(null);
			this._dataLoaderList = [];
			this.loaderStatu = LoaderStatus.LOADER_STATU_READY; //加载队列就绪
			this.setAssetQueueInfo(args[0], args[1], args[2], args[3], args[4]);
		}
		
		public function get assetType():String
		{
			return _assetType;
		}
		
		public function set assetType(value:String):void
		{
			_assetType = value;
		}
		
		public function get isReleaseInPool():Boolean
		{
			return ObjectPoolManager.getInstance().isReleaseInPool(this);
		}
		
		public function get loaderStatu():int
		{
			return _loaderStatu;
		}
		
		public function set loaderStatu(value:int):void
		{
			if (this._loaderStatu == value)
				return;
			LogsManager.getInstance().setLog("【SDLOADER】Load statu is change to " + LoaderStatus.LOADER_STATUS[value] + ", urls is " + this._assetList);
			this._loaderStatu = value;
		}
		
		public function get queueSize():uint
		{
			return this._queue.queueSize;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get eventDispatcher():EventDispatcher
		{
			return this;
		}
	}

}