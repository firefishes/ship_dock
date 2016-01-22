package shipDock.framework.application.events
{
	import shipDock.framework.core.events.SDEvent;
	import shipDock.framework.core.utils.gc.reclaimHeap;
	import shipDock.framework.core.utils.SDMath;
	
	/**
	 * 素材加载队列事件类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class AssetQueueEvent extends SDEvent
	{
		
		public static const ASSET_QUEUE_COMPLETE_EVENT:String = "assetQueueCompleteEvent";
		public static const ASSET_QUEUE_PROGRESS_EVENT:String = "assetQueueProgressEvent";
		public static const ASSET_QUEUE_UNIT_LOADED_EVENT:String = "assetQueueUnitLoadedEvent";
		
		public function AssetQueueEvent(type:String, bubbles:Boolean = false, data:Object = null)
		{
			super(type, bubbles, data);
		
		}
		
		public function setProgress(loaded:Number, total:Number):void
		{
			data["pTotal"] = total;
			data["pLoaded"] = loaded;
		}
		
		public function get progressTotal():Number
		{
			return this.data["pTotal"]
		}
		
		public function get progressLoaded():Number
		{
			return this.data["pLoaded"];
		}
		
		public function get progress():Number
		{
			return SDMath.percent(this.progressLoaded, this.progressLoaded);
		}
	}

}