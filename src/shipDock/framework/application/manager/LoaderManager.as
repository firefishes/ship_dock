package shipDock.framework.application.manager 
{
	import flash.events.ProgressEvent;
	import shipDock.framework.application.events.AssetQueueEvent;
	
	import shipDock.framework.application.interfaces.IAssetQueueLoader;
	import shipDock.framework.application.loader.AssetQueueLoader;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.methodExecuter.MethodElement;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import shipDock.framework.core.singleton.SingletonBase;
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.utils.SDUtils;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 加载器管理器
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class LoaderManager extends SingletonBase 
	{
		
		public static const LOADER_MANAGER:String = "loaderMgr";
		
		private static const MIAN_LOADER_ID:String = "mainLoader";
		private static const CALLBACK_TYPE_COMPLETE:int = 0;
		private static const CALLBACK_TYPE_PROGRESS:int = 1;
		
		public static function getInstance():LoaderManager
		{
			return SingletonManager.singletonManager().getSingleton(LOADER_MANAGER) as LoaderManager;
		}
		
		/**加载器队列*/
		private var _assetLoadListMap:HashMap;
		private var _loadCompleteMap:HashMap;
		private var _loadProgressMap:HashMap;
		private var _loadTypes:Array;
		
		public function LoaderManager() 
		{
			super(this, LOADER_MANAGER);
			
			this._assetLoadListMap = new HashMap();
			this._loadCompleteMap = new HashMap();
			this._loadProgressMap = new HashMap();
			
			this._loadTypes = [this._loadCompleteMap, this._loadProgressMap];
		}
		
		/**
		 * 添加素材加载队列
		 *
		 */
		public function load(source:*, loadID:String = null, complete:MethodElement = null, progress:MethodElement = null, loaderCls:Class = null, classArgs:Array = null):void
		{
			(!loadID) && (loadID = MIAN_LOADER_ID);
			(!loaderCls) && (loaderCls = AssetQueueLoader);
			
			var list:Array = (source is Array) ? source : [source];
			var args:Array = [list];
			
			(classArgs == null) && (classArgs = []); //初始化加载器实例所需的参数
			args = args.concat(classArgs);
			var loader:IAssetQueueLoader = SDUtils.createInstance(loaderCls, args);
			(loader as EventDispatcher).addEventListener(AssetQueueEvent.ASSET_QUEUE_COMPLETE_EVENT, this.completeHandler);
			(loader as EventDispatcher).addEventListener(AssetQueueEvent.ASSET_QUEUE_PROGRESS_EVENT, this.progressHandler);
			
			var queue:QueueExecuter = this._assetLoadListMap.getValue(loadID);
			(!queue) && (queue = new QueueExecuter()); //初始化数据
			queue.add(loader);
			queue.commit();
			this._assetLoadListMap.put(loadID, queue); //覆盖素材队列数据
			
			this.setLoaderCallback(loader, CALLBACK_TYPE_COMPLETE, complete);
			this.setLoaderCallback(loader, CALLBACK_TYPE_PROGRESS, progress);
		}
		
		private function setLoaderCallback(loader:IAssetQueueLoader, type:int, callback:MethodElement):void {
			if (!loader || !callback)
				return;
			var map:HashMap = this._loadTypes[type];
			if (!map)
				return;
			var method:MethodElement = map.isContainsKey(loader) ? map.getValue(loader) : null;
			(method) && method.dispose();
			this._loadCompleteMap.put(loader, callback);
		}
		
		private function removeLoaderCallback(loader:IAssetQueueLoader, type:int):void {
			if (!loader)
				return;
			var map:HashMap = this._loadTypes[type];
			if (!map)
				return;
			var method:MethodElement = map.remove(loader);
			(method) && method.dispose();
		}
		
		private function invokeCallback(loader:IAssetQueueLoader, type:int, args:Array = null):* {
			if (!loader)
				return null;
			var map:HashMap = this._loadTypes[type];
			if (!map)
				return null;
			var result:*;
			var method:MethodElement = map.getValue(loader);
			(method) && (result = method.apply(null, args));
			return result;
		}
		
		/**
		 * 默认的加载过程回调
		 *
		 * @param	event
		 */
		private function progressHandler(event:AssetQueueEvent):void
		{
			var target:IAssetQueueLoader = event.target as IAssetQueueLoader;
			this.invokeCallback(target, CALLBACK_TYPE_PROGRESS, [event]);
		}
		
		/**
		 * 默认的加载完成回调
		 *
		 * @param	event
		 */
		private function completeHandler(event:AssetQueueEvent):void
		{
			var target:IAssetQueueLoader = event.target as IAssetQueueLoader;
			(target as EventDispatcher).removeEventListener(AssetQueueEvent.ASSET_QUEUE_COMPLETE_EVENT, this.completeHandler);
			(target as EventDispatcher).removeEventListener(AssetQueueEvent.ASSET_QUEUE_PROGRESS_EVENT, this.progressHandler);
			
			this.invokeCallback(target, CALLBACK_TYPE_COMPLETE, [event]);
			
			this.removeLoaderCallback(target, CALLBACK_TYPE_COMPLETE);
			this.removeLoaderCallback(target, CALLBACK_TYPE_PROGRESS);
		}
	}

}