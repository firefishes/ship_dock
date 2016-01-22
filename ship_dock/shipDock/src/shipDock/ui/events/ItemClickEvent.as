package shipDock.ui.events 
{
	import shipDock.framework.application.events.UIEvent;

	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class ItemClickEvent extends UIEvent 
	{
		public static const ITEM_CLICK_EVENT:String = "itemClickEvent";
		
		public var selectedIndex:int;
		public var itemTarget:*;
		public var selectedItem:Object;
		
		public function ItemClickEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
			
		}
		
	}

}