package shipDock.framework.application.events
{
	import shipDock.framework.core.events.SDEvent;
	
	public class UIEvent extends SDEvent
	{
		public static const UI_DISPOSED_EVENT:String = "UIDisposedEvent";
		public static const UI_DATA_CHANGE_EVENT:String = "UIDataChangeEvent";
		public static const FIRST_INIT_UI_EVENT:String = "firstInitUIEvent";
		public static const REDRAW_UI_EVENT:String = "redrawUIEvent";
		public static const GAME_EMBED_FINISH_EVENT:String = "gameEmbedEvent";
		public static const RUN_GAME_EVENT:String = "runGameEvent";
		public static const CREATION_EVENT:String = "creationEvent";
		public static const CREATE_UI_ERROR_EVENT:String = "createUIErrorEvent";
		
		public function UIEvent(type:String, bubbles:Boolean = false, data:Object = null)
		{
			super(type, bubbles, data);
		}
	}
}