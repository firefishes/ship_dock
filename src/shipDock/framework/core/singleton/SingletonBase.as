package shipDock.framework.core.singleton {
	import shipDock.framework.core.interfaces.ISingleton;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.utils.StringUtils;
	import starling.events.EventDispatcher;
	
	/**
	 * 单例基类
	 * 
	 * 允许使用此类制作代理单例，代理单例通过另一个单例对象保证被代理对象实例的唯一性，
	 * 从而在不对源代码做大改动的前提下制作单例
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class SingletonBase extends EventDispatcher implements ISingleton
	{
		/*单例引用，可以用于制作代理单例*/
		protected var _refrence:*;
		/*单例名称*/
		protected var _singletonName:String;
		
		public function SingletonBase(target:* = null, singletonName:String = null) 
		{
			this._singletonName = singletonName;
			this._refrence = (target == null) ? this : target;
			this.initSingleton();
		}
		
		/**
		 * 单例的注册操作
		 * 
		 */
		final public function initSingleton():void {
			SingletonManager.singletonManager().registeredSingleton(this);
		}
		
		/**
		 * 单例的获取操作
		 * 
		 * @return
		 */
		final public function getInstance():ISingleton {
			return SingletonManager.singletonManager().getSingleton(this);
		}
		
		/**
		 * 单例引用，可以用于制作代理单例
		 * 
		 */
		public function get singletonName():String {
			(this._singletonName == null) && 
				(this._singletonName = StringUtils.qualifiedClassName(this._refrence));
			return this._singletonName;
		}
		
		/**
		 * 单例名称
		 * 
		 */
		public function get singleRefrence():* 
		{
			return _refrence;
		}
		
	}

}