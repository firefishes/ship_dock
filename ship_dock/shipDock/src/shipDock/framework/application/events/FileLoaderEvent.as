package shipDock.framework.application.events {
	import starling.events.Event;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FileLoaderEvent extends Event 
	{
		
		public static const FILE_LOADER_IO_ERROR_EVENT:String = "fileLoaderIOErrorEvent";
		
		public function FileLoaderEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
			
		}
		
	}

}