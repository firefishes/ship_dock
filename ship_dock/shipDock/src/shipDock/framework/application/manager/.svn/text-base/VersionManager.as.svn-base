package shipDock.framework.application.manager
{
	import shipDock.framework.application.manager.ConfigManager;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class VersionManager
	{
		/**
		 * 创建素材资源版本管理器
		 *
		 */
		public static function crateAssetVersion():void
		{
			ConfigManager.getInstance().createConfig(VersionName.ASSET_VERSION);
		}
		
		/**
		 * 添加一个素材版本
		 *
		 * @param	key
		 * @param	version
		 * @return
		 */
		public static function addAssetVersion(key:String, version:*):void
		{
			if (getAssetVersion() == null)
			{
				VersionManager.crateAssetVersion();
			}
			ConfigManager.getInstance().addConfigValue(VersionName.ASSET_VERSION, key, version);
		}
		
		/**
		 * 获得所有素材版本
		 *
		 * @return
		 */
		public static function getAssetVersion():*
		{
			return ConfigManager.getInstance().getConfig(VersionName.ASSET_VERSION);
		}
		
		/**
		 * 检测一个素材版本是否过期，一般是用OS里的版本号与生成的SyncModle里的验证号比对
		 *
		 * @param	naem
		 * @param	key
		 * @param	checkValue
		 * @return
		 */
		public static function isAssetOverdue(name:String, key:String, checkValue:*):Boolean
		{
			var data:Object = VersionManager.getAssetVersion();
			if (data == null)
			{
				VersionManager.crateAssetVersion();
				data = VersionManager.getAssetVersion();
			}
			var target:*;
			if (!!data[name])
			{
				target = (!!key) ? data[name][key] : data[name];
			}
			return (target != checkValue);
		}
		
		public function VersionManager()
		{
		
		}
	
	}

}