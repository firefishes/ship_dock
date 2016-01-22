package shipDock.framework.core.events 
{
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.utils.gc.reclaimHeap;
	import starling.events.Event;
	
	/**
	 * 框架事件基类
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class SDEvent extends Event implements IDispose, IPoolObject 
	{
		
		private var _type:String;
		private var _eventData:Object;
		
		public function SDEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			(!data) && (data = {});
			super(type, bubbles, data);
		}
		
		/* INTERFACE shipDock.framework.core.interfaces.IPoolObject */
		
		public function get isReleaseInPool():Boolean 
		{
			return ObjectPoolManager.getInstance().isReleaseInPool(this);
		}
		
		public function reinitPoolObject(args:Array):void 
		{
			this.dispose();
			this._type = args[0];
			this._eventData = args[2];
			(this._eventData) && reclaimHeap(super.data);
		}
		
		public function resetPoolObject():void 
		{
			this.dispose();
		}
		
		/* INTERFACE shipDock.framework.core.interfaces.IDispose */
		
		public function dispose():void 
		{
			reclaimHeap(super.data);
			reclaimHeap(this._eventData);
			this._eventData = null;
			this._type = null;
		}
		
		override public function get type():String 
		{
			return (this._type) ? this._type : super.type;
		}
		
		override public function get data():Object 
		{
			return (this._eventData) ? this._eventData : super.data;
		}
	}

}