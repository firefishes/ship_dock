package shipDock.framework.core.notice {
	/**
	 * 框架级别的消息名集合
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDNoticeName 
	{
		/**程序启动*/
		public static const SD_START_UP:String = "startUp";
		/**HTTP请求消息*/
		public static const SD_HTTP:String = "SDHttp";
		/**框架级别核心消息*/
		public static const SD_CORE:String = "SDCore";
		/**本地共享数据对象操作消息*/
		public static const SD_SHARE_OBJECT:String = "SDShareObject";
		/**界面消息*/
		public static const SD_UI:String = "SDUI";
		/**逻辑代理调用被代理对象内部方法消息*/
		public static const SD_INVOKE_PROXYED:String = "SDInvokeProxyed";
		/**文件素材队列消息*/
		public static const SD_FILE_ASSET_LIST:String = "SDFileAssetList";
		
		public function SDNoticeName() 
		{
			
		}
		
	}

}