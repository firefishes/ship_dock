package shipDock.framework.application.loader
{
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class QueueLoaderType
	{
		
		/*数据类型的资源*/
		public static const QUEUE_LOADER_TYPE_DATA:int = 0;
		/*可显示类型的资源*/
		public static const QUEUE_LOADER_TYPE_DISPLAY_ASSET:int = 1;
		/*文件类型的资源*/
		public static const QUEUE_LOADER_TYPE_FILE:int = 2;
		
		public static function checkQueueLoaderType(name:String):int {
			var list:Array = name.split(".");
			var tail:String = list[list.length - 1];
			var index:int = AssetType.TYPE_DISPLAY.indexOf(tail);
			var result:int;
			(index != -1) && (result = QUEUE_LOADER_TYPE_DISPLAY_ASSET);//如果是显示类型的资源
			return result;
		}
		
		public function QueueLoaderType()
		{
		
		}
	
	}

}