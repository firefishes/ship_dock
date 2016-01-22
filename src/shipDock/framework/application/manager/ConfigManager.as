package shipDock.framework.application.manager
{
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.singleton.SingletonBase;
	
	/**
	 * 配置管理器（单例）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class ConfigManager extends SingletonBase
	{
		
		public static const CONFIG_MANAGER:String = "configMgr";
		
		public static function getInstance():ConfigManager
		{
			return SingletonManager.singletonManager().getSingleton(CONFIG_MANAGER) as ConfigManager;
		}
		
		private var _configs:HashMap;
		
		public function ConfigManager()
		{
			super(this, CONFIG_MANAGER);
			this._configs = new HashMap();
		}
		
		public function createConfig(name:String):void
		{
			if (this._configs.isContainsKey(name))
				return;
			this._configs.put(name, {});
		}
		
		public function getConfig(name:String):Object
		{
			var result:Object = this._configs.getValue(name);
			if (result == null)
			{
				result = FileManager.getInstance().readConfigFile(name);
				(!!result) && this._configs.put(name, result);
			}
			return result;
		}
		
		public function addConfigValue(name:String, key:String, value:*):void
		{
			var data:Object = this.getConfig(name);
			data[key] = value;
			this._configs.put(name, data);
		}
		
		public function getFileConfig(name:String):Object
		{
			//TODO get file config
			//var file:File = File
			return null;
		}
	}

}