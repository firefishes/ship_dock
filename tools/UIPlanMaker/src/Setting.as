package  
{
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class Setting 
	{
		
		public static const FILE_ASSET:String = "assets/";
		public static const FILE_CONFIG:String = "config/";
		public static const FILE_LOCALE:String = "locale/";
		public static const FILE_PLAN:String = "plan/";
		
		/*服务器地址*/
		private static const HOST:String = "http://127.0.0.1/ui_plan_maker/";
		private static const ASSET:String = HOST + FILE_ASSET;
		
		/*界面配置文件路径*/
		public static const VIEW_PATH:String = ASSET + "view";
		public static const OS_NAME:String = "UIPlanMaker";
		
		//public static function get asset():String {
			//if (assetValue == null) {
				//assetValue = (applyAssetServer) ? ASSET : FILE_ASSET;
			//}
			//return assetValue;
		//}
		
		public function Setting() 
		{
			
		}
		
	}

}