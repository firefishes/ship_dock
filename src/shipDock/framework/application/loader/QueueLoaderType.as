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
		
		public static function checkQueueLoaderType(name:String):int
		{
			var list:Array = name.split(".");
			var tail:String = list[list.length - 1];
			var ranges:Array = [{"type":QUEUE_LOADER_TYPE_DISPLAY_ASSET, "range":AssetType.TYPE_DISPLAY}, {"type":QUEUE_LOADER_TYPE_DATA, "range":AssetType.TYPE_DATA}];
			var item:Object = getLoadType(ranges, tail);
			var result:int = (item) ? item["type"] : QUEUE_LOADER_TYPE_DISPLAY_ASSET;
			return result;
		}
		
		private static function getLoadType(ranges:Array, tail:String):Object
		{
			var item:Object = ranges.pop() as Array;
			var list:Array = item["range"];
			var index:int = -1;
			if (list)
				index = list.indexOf(tail);
			else
				return null;
			return (index == -1) ? getLoadType(ranges, tail) : ranges.pop();
		}
		
		public function QueueLoaderType()
		{
		
		}
	
	}

}