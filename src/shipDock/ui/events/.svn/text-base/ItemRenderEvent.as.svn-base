package shipDock.ui.events 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author HongSama
	 */
	public class ItemRenderEvent extends Event
	{
		public static var CHOOSER_EVENT:String = "SCGameChooserEvent";
		public static var REFRESH_EVENT:String = "SCGameRefreshEvent";
		public static var SET_PAGE_OK_EVENT:String = "setPageOkEvent";//曾经的 setPageOk 事件
		
		public var index:int = 0;
		public var eventType:int = 0;
		
		public function ItemRenderEvent(type:String,index:int,eventType:int) 
		{
			this.eventType = eventType;
			this.index = index;
			super(type);
		}
		
	}

}