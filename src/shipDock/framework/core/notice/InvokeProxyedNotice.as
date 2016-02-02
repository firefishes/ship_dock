package shipDock.framework.core.notice {
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.notice.Notice;
	
	/**
	 * 调用被代理对象逻辑的消息
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class InvokeProxyedNotice extends Notice implements IPoolObject
	{
		
		private var _invokeName:String;
		
		public function InvokeProxyedNotice(invokeName:String, params:* = null) 
		{
			super(SDNoticeName.SD_INVOKE_PROXYED, params);
			this._invokeName = invokeName;
		}
		
		public function reinitPoolObject(args:Array):void {
			this._invokeName = args[0];
			this._data = args[1];
			this._isAutoDispose = true;
			this._resetSubCommand = true;
		}
		
		public function resetPoolObject():void {
			this.dispose();
			this._invokeName = null;
		}
		
		public function get isReleaseInPool():Boolean {
			return ObjectPoolManager.getInstance().isReleaseInPool(this);
		}
		
		public function get invokeName():String {
			return this._invokeName;
		}
		
		public function set invokeName(value:String):void 
		{
			_invokeName = value;
		}
	}

}