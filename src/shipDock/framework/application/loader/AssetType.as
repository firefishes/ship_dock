package shipDock.framework.application.loader
{
	
	public class AssetType
	{
		/*swf资源*/
		public static const TYPE_SWF:String = "swf";
		/*atf资源*/
		public static const TYPE_ATF:String = "atf";
		/*png资源*/
		public static const TYPE_PNG:String = "png";
		/*jpg资源*/
		public static const TYPE_JPG:String = "jpg";
		
		/*Ship Dock 框架特有文件资源*/
		public static const TYPE_SD:String = "sd";
		/*xml资源*/
		public static const TYPE_XML:String = "xml";
		/*txt资源*/
		public static const TYPE_TEXT:String = "txt";
		/*ini配置资源*/
		public static const TYPE_INI:String = "ini";
		/*例子特效配置资源*/
		public static const TYPE_PEX:String = "pex";
		/*json数据类资源*/
		public static const TYPE_JSON:String = "json";
		/*语言包类资源*/
		public static const TYPE_LANGUAGE:String = "language";
		
		/*wmv格式的声音资源*/
		public static const TYPE_WMV:String = "wmv";
		/*mp3格式的声音资源*/
		public static const TYPE_MP3:String = "mp3";
		
		/*所有可视化资源类型*/
		public static const TYPE_DISPLAY:Array = [TYPE_SWF, TYPE_ATF, TYPE_PNG, TYPE_JPG];
		/*所有配置数据资源类型*/
		public static const TYPE_DATA:Array = [TYPE_XML, TYPE_TEXT, TYPE_INI, TYPE_PEX, TYPE_JSON, TYPE_LANGUAGE, TYPE_SD];
		/*所有在同步文件功能范围内的资源类型*/
		public static const SYNC_TYPE_LIST:Array = [TYPE_SWF, TYPE_JSON, TYPE_LANGUAGE, TYPE_PNG, TYPE_ATF, TYPE_XML];
		
		public function AssetType()
		{
		}
	}
}