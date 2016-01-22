package shipDock.framework.application.loader
{
	
	import flash.events.ProgressEvent;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IQueueExecuter;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 基础同步加载器基类
	 *
	 * 提供队列加载功能
	 *
	 * 子类可选择覆盖的方法：
	 *
	 * commit();
	 * loadComplete();
	 *
	 * @author shaoxin.ji
	 *
	 */
	public class Syncer extends EventDispatcher implements IQueueExecuter, IDispose
	{
		
		private var _assetType:String;
		private var _complete:Function;
		private var _progress:Function;
		
		protected var _waitingList:Array; //等待加载的队列
		protected var _waitingData:Object;
		
		protected var _queue:QueueExecuter;
		
		public function Syncer(waitingList:Array, assetType:String, complete:Function = null, progress:Function = null)
		{
			this._waitingData = {};
			this._waitingList = waitingList;
			this._assetType = (assetType == null) ? AssetType.TYPE_PNG : assetType;
			this._queue = new QueueExecuter();
			this._queue.addEventListener(QueueExecuterEvent.QUEUE_COMPLETE_EVENT, this.syncQueueComplete);
			
			this._complete = complete;
			this._progress = progress;
		
		}
		
		public function dispose():void
		{
			if (!!this._queue)
			{
				this._queue.removeEventListener(QueueExecuterEvent.QUEUE_COMPLETE_EVENT, this.syncQueueComplete);
				this._queue.dispose();
				this._queue = null;
			}
			this._complete = null;
			this._progress = null;
			this._waitingList = [];
			this._waitingData = {};
		}
		
		public function commit():void
		{
		}
		
		protected function loadComplete(event:Event):void
		{
			if (!!this._complete)
			{
				this._complete();
			}
		}
		
		protected function loadProgress(event:ProgressEvent):void
		{
			if (!!this._progress)
			{
				this._progress();
			}
		}
		
		protected function syncQueueComplete(event:QueueExecuterEvent):void
		{
			this.queueNext();
		}
		
		/**
		 * 执行此对象所在队列的下一个队列元素
		 *
		 */
		public function queueNext():void
		{
			this.dispatchEventWith(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT);
		}
		
		public function get waitingList():Array
		{
			return _waitingList;
		}
		
		public function get queueSize():uint
		{
			return this._queue.queueSize;
		}
		
		public function get eventDispatcher():EventDispatcher {
			return this as EventDispatcher;
		}
	
	}
}