package shipDock.framework.core.notice {
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.notice.Notice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class CallProxyedNotice extends Notice implements IPoolObject
	{
		
		public function CallProxyedNotice(name:String, data:*=null) 
		{
			super(name, data);
		}
		
		public function reinitPoolObject(args:Array):void {
			this._name = args[0];
			this._data = args[1];
			this._observer = args[2];
			this._isAutoDispose = args[3];
			this._resetSubCommand = true;
		}
		
		public function resetPoolObject():void {
			this.dispose();
		}
		
		public function get isReleaseInPool():Boolean {
			return ObjectPoolManager.getInstance().isReleaseInPool(this);
		}
	}

}