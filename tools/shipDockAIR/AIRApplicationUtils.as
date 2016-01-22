package
{
	
	/**
	 * 工具应用的工具类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRApplicationUtils
	{
		
		public static function checkFilePathHead(path:String):String
		{
			var result:String = path;
			(result.indexOf("app:") < 0) && (result = "file:///" + result);
			return result;
		}
		
		public static function replaceSystemPath(value:String):String
		{
			return value.replace(new RegExp("\\\\", '*g'), "/");
		}
		
		public function AIRApplicationUtils()
		{
		
		}
	
	}

}