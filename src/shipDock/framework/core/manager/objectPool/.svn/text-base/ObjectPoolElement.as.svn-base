package shipDock.framework.core.manager.objectPool 
{
	import flash.utils.getDefinitionByName;
	
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IObjectPoolElement;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.utils.SDUtils;
	import shipDock.framework.core.utils.StringUtils;
	
	/**
	 * 对象池的元素类
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	final public class ObjectPoolElement implements IObjectPoolElement 
	{
		/*是否可重置*/	
		private var _canClear:Boolean;
		/*被代理的对象*/
		private var _target:*;
		/*被代理对象的类*/	
		private var _cls:Class;
		/*被代理对象的类名*/	
		private var _clsName:String;
		
		public function ObjectPoolElement(v:*) 
		{
			this._canClear = true;
			clear(v);
		}
		
		/* INTERFACE shipDock.interfaces.IObjectPoolElement */
		/**
		 * 清理对象池代理
		 *  
		 * @param v
		 * 
		 */		
		public function clear(v:*):void {
			if(this._canClear) {
				var isCls:Boolean = (v && (v is Class));
				(!isCls) && (target = v);
				this._clsName = StringUtils.qualifiedClassName(v, true);
				(this._clsName) && (this._cls = getDefinitionByName(this._clsName) as Class);
				this._canClear = false;
			}
		}
		
		/**
		 * 重初始化对象池代理
		 *  
		 * @param args
		 * 
		 */
		public function reinitPoolObject(args:Array):void {
			if(_target == null)
				_target = SDUtils.createInstance(_cls, args);//实例化被代理的对象
			else
				(this._target is IPoolObject) && (this._target as IPoolObject).reinitPoolObject(args);
		}
		
		/**
		 * 重置对象池代理
		 * 
		 */
		public function resetPoolObject():void {
			(this._target is IPoolObject) && (this._target as IPoolObject).resetPoolObject();
		}
		
		/**
		 * 销毁对象池代理
		 * 
		 */		
		public function dispose():void 
		{
			this._canClear = true;
			(!!target && (this._target is IDispose)) && (this._target as IDispose).dispose();
			this.purge();
		}
		
		/**
		 * 回收
		 * 
		 */		
		private function purge():void {
			this._target = null;
			this._clsName = null;
			this._cls = null;
		}
		
		public function get objectClass():Class 
		{
			return this._cls;
		}
		
		public function set target(value:*):void 
		{
			_target = value;
		}
		
		public function get target():* 
		{
			return _target;
		}
		
		public function get className():String 
		{
			return _clsName;
		}
		
		public function get isReleaseInPool():Boolean 
		{
			return ObjectPoolManager.getInstance().isOwnPools(this.target);
		}
		
	}

}