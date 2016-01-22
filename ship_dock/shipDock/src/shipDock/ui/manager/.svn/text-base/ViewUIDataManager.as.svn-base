package shipDock.ui.manager 
{
	
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.singleton.SingletonBase;
	
	
	/**
	 * 界面配置管理器（单例）
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class ViewUIDataManager extends SingletonBase
	{
		
		public static function getInstance():ViewUIDataManager {
			var result:ViewUIDataManager = SingletonManager.singletonManager().getSingleton("viewUIDataMgr") as ViewUIDataManager;
			if(result == null) {
				SingletonManager.singletonManager().addSingleton(ViewUIDataManager);
				result = getInstance();
			}
			return result;
		}
		
		private var _UIDataCache:Object;
		
		public function ViewUIDataManager(name:String = "viewUIDataMgr") 
		{
			super(this, name);
			this._UIDataCache = { };
		}
		
		public function addUIDataCache(name:String, data:Object):void {
			this._UIDataCache[name] = data;
		}
		
		public function getUIDataCache(name:String):Object {
			return this._UIDataCache[name];
		}	
	}
}