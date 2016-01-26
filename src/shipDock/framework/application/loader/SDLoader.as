package shipDock.framework.application.loader
{
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import shipDock.framework.core.methodExecuter.MethodCenter;
	import shipDock.framework.core.utils.gc.reclaim;
	
	import shipDock.framework.application.interfaces.ISDLoader;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 基础加载器
	 *
	 * 提供数据文件的加载功能，可以是本地资源或网络资源
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDLoader extends EventDispatcher implements ISDLoader, IPoolObject
	{
		
		private static var instanceCount:uint = 0;
		
		private var _loadType:int;
		private var _url:String;
		/*是否自动销毁，启用此属性，请勿从对象池中获取此对象*/
		private var _isAutoDispose:Boolean;
		private var _isAutoQueueNext:Boolean;
		private var _name:String;
		private var _instanceIndex:int;
		private var _loaderStatu:int;
		private var _methodCenter:MethodCenter;
		
		protected var _request:URLRequest;
		protected var _loadedData:*;
		
		public function SDLoader(url:String, complete:Function = null, progress:Function = null)
		{
			super();
			
			this.loaderStatu = LoaderStatus.LOADER_STATU_READY; //加载器就绪
			this.setSDLoaderInfo(url, complete, progress);
			this._instanceIndex = instanceCount;
			instanceCount++;
		}
		
		public function setSDLoaderInfo(url:String, complete:Function = null, progress:Function = null):void
		{
			this.url = url;
			(!this._methodCenter) && (this._methodCenter = new MethodCenter());
			this._methodCenter.addCallback("complete", complete);
			this.progress = progress;
			this.name = null;
		}
		
		public function resetPoolObject():void
		{
			this.unload();
			this.setSDLoaderInfo(null);
			this._loadedData = null;
		}
		
		public function reinitPoolObject(args:Array):void
		{
			while (args.length < 3)
				args.push(null);
			this.unload();
			this.setSDLoaderInfo(args[0], args[1], args[2]);
		}
		
		public function dispose():void
		{
			this._request = null;
			this._loadedData = null;
			if (this.isReleaseInPool)
			{ //防止私自销毁时仍然遗留在对象池的已用对象集合中
				this.loaderStatu = LoaderStatus.LOADER_STATU_READY; //加载器就绪
				reclaim(this._methodCenter, "clear");
			}
			else
			{
				this.loaderStatu = LoaderStatus.LOADER_STATU_DISPOSED; //加载器被销毁
				reclaim(this._methodCenter);
				this._methodCenter = null;
			}
		}
		
		protected function addEvents(target:IEventDispatcher):void
		{
			if (target == null)
				return;
			target.addEventListener(Event.OPEN, this.loadOpen);
			target.addEventListener(flash.events.Event.INIT, this.loadInit);
			target.addEventListener(Event.COMPLETE, this.loadCompleted);
			target.addEventListener(ProgressEvent.PROGRESS, this.loadProgress);
			target.addEventListener(IOErrorEvent.IO_ERROR, this.loadIOError);
		}
		
		protected function removeEvents(target:IEventDispatcher):void
		{
			if (target == null)
				return;
			target.removeEventListener(Event.OPEN, this.loadOpen);
			target.removeEventListener(flash.events.Event.INIT, this.loadInit);
			target.removeEventListener(Event.COMPLETE, this.loadCompleted);
			target.removeEventListener(ProgressEvent.PROGRESS, this.loadProgress);
			target.removeEventListener(IOErrorEvent.IO_ERROR, this.loadIOError);
		}
		
		protected function loadCompleted(event:* = null):void
		{
			this.loaderStatu = LoaderStatus.LOADER_STATU_COMPLETE; //加载器完成加载
			if (!!this.complete)
			{
				var args:Array = [this.getLoadedData()];
				(!!this.completeParams) && (args = args.concat(this.completeParams));
				this._methodCenter.useCallback("complete", args);
			}
			this.dispatchEventWith(Event.COMPLETE);
			(this._isAutoQueueNext) && this.queueNext();
			(this._isAutoDispose) && this.dispose();
		}
		
		protected function loadOpen(event:*):void
		{
			this.loaderStatu = LoaderStatus.LOADER_STATU_OPEN; //加载器开启加载
		}
		
		protected function loadInit(event:flash.events.Event):void
		{
		
		}
		
		protected function loadIOError(event:IOErrorEvent):void
		{
			this.loaderStatu = LoaderStatus.LOADER_STATU_IOERROR; //加载器发生IO错误
			LogsManager.getInstance().setLog(event.text);
			(this._methodCenter) && this._methodCenter.useCallback("loadError");
			this.dispatchEventWith(event.type, false, {"errorID": event.errorID, "text": event.text});
		}
		
		protected function loadProgress(event:* = null):void
		{
			this.loaderStatu = LoaderStatus.LOADER_STATU_LOADING; //加载器加载中
			(this._methodCenter) && this._methodCenter.useCallback("progress");
		}
		
		protected function setLoadedData(result:*):void
		{
			this._loadedData = result;
		}
		
		protected function getLoadedData():*
		{
			return this._loadedData;
		}
		
		/**
		 * 执行此对象所在队列的下一个队列元素
		 *
		 */
		public function queueNext():void
		{
			this.dispatchEventWith(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT);
		}
		
		public function load():void
		{
			this.commit();
		}
		
		public function commit():void
		{
		}
		
		/**
		 * 停止加载
		 *
		 */
		public function unload():void
		{
			this.loaderStatu = LoaderStatus.LOADER_STATU_READY; //加载器就绪
		}
		
		public function get rawData():*
		{
			return null;
		}
		
		public function get loadedData():*
		{
			return _loadedData;
		}
		
		public function get loadType():int
		{
			return _loadType;
		}
		
		public function set loadType(value:int):void
		{
			_loadType = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
			this._request = new URLRequest(url);
		}
		
		public function get complete():Function
		{
			return (this._methodCenter) ? this._methodCenter.getCallback("complete") : null;
		}
		
		public function set complete(value:Function):void
		{
			(this._methodCenter) && this._methodCenter.addCallback("complete", value);
		}
		
		public function get progress():Function
		{
			return (this._methodCenter) ? this._methodCenter.getCallback("progress") : null;
		}
		
		public function set progress(value:Function):void
		{
			(this._methodCenter) && this._methodCenter.addCallback("progress", value);
		}
		
		/**
		 * getter 是否自动销毁
		 *
		 */
		public function get isAutoDispose():Boolean
		{
			return _isAutoDispose;
		}
		
		/**
		 * setter 是否自动销毁
		 *
		 */
		public function set isAutoDispose(value:Boolean):void
		{
			_isAutoDispose = value;
		}
		
		public function get isAutoQueueNext():Boolean
		{
			return _isAutoQueueNext;
		}
		
		public function set isAutoQueueNext(value:Boolean):void
		{
			_isAutoQueueNext = value;
		}
		
		public function get name():String
		{
			(this._name == null) && (this._name = "SDLoader_" + this._instanceIndex);
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
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
			LogsManager.getInstance().setLog("【SDLOADER】Load statu is change to " + LoaderStatus.LOADER_STATUS[value] + ", url is " + this.url);
			this._loaderStatu = value;
		}
		
		/**
		 * 是否准备就绪
		 *
		 */
		public function get isReady():Boolean
		{
			return ((this._loaderStatu == LoaderStatus.LOADER_STATU_READY) || (this._loaderStatu == LoaderStatus.LOADER_STATU_COMPLETE));
		}
		
		/**
		 * 是否正在加载
		 *
		 */
		public function get isLoading():Boolean
		{
			return (this._loaderStatu == LoaderStatus.LOADER_STATU_LOADING) || (this._loaderStatu == LoaderStatus.LOADER_STATU_OPEN) || (this._loaderStatu == LoaderStatus.LOADER_STATU_INIT);
		}
		
		/**
		 * 是否完成加载
		 *
		 */
		public function get isLoaded():Boolean
		{
			return ((this._loaderStatu == LoaderStatus.LOADER_STATU_COMPLETE) || (this._loaderStatu == LoaderStatus.LOADER_STATU_FINISH));
		}
		
		/**
		 * 加载是否完成，用于加载队列
		 *
		 */
		public function get isFinish():Boolean
		{
			return (this._loaderStatu == LoaderStatus.LOADER_STATU_FINISH);
		}
		
		public function get queueSize():uint
		{
			return 1;
		}
		
		public function get completeParams():Array
		{
			return (this._methodCenter) ? this._methodCenter.getMethodArgs("complete") : null; //_completeParams;
		}
		
		public function set completeParams(value:Array):void
		{
			(this._methodCenter) && this._methodCenter.setMehodArgs("complete", value);
		}
		
		public function set loadError(value:Function):void
		{
			(this._methodCenter) && this._methodCenter.addCallback("loadError", value);
		}
		
		public function get loadError():Function
		{
			return (this._methodCenter) ? this._methodCenter.getCallback("loadError") : null;
		}
		
		public function get eventDispatcher():EventDispatcher
		{
			return this;
		}
	
	}

}