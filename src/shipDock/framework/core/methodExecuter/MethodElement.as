package shipDock.framework.core.methodExecuter
{
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IMethodElement;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	
	/**
	 * 函数执行器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class MethodElement implements IDispose, IPoolObject, IMethodElement
	{
		
		private var _method:Function;
		private var _args:Array;
		private var _thisArgs:*;
		
		public function MethodElement(method:Function, args:Array = null, owner:* = null)
		{
			this.reset(method, args, owner);
		}
		
		public function setMethod(value:Function):void
		{
			this._method = value;
		}
		
		public function getMethod():Function
		{
			return this._method;
		}
		
		public function dispose():void
		{
			this.reset();
			if (this.isReleaseInPool)
				return;
		}
		
		public function apply(thisArgs:* = null, args:Array = null):*
		{
			var result:*;
			(thisArgs == null) && (thisArgs = this._thisArgs);
			(args == null) && (args = this._args);
			(!!this._method) && (result = this._method.apply(thisArgs, args));
			return result;
		}
		
		public function reset(method:Function = null, args:Array = null, owner:* = null):void
		{
			this._args = args;
			this._method = method;
			this._thisArgs = owner;
			(_args == null) && (_args = []);
		}
		
		public function resetPoolObject():void
		{
			this.reset();
		}
		
		public function reinitPoolObject(args:Array):void
		{
		}
		
		public function get isReleaseInPool():Boolean
		{
			return ObjectPoolManager.getInstance().isReleaseInPool(this);
		}
		
		public function get args():Array
		{
			return _args;
		}
		
		public function set args(value:Array):void
		{
			_args = value;
		}
		
		public function get method():Function
		{
			return _method;
		}
	
	}
}