package shipDock.ui 
{
	import shipDock.framework.application.component.SDComponent;
	import shipDock.framework.core.interfaces.IQueueExecuter;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.EventDispatcher;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ViewChildQueueUnit extends EventDispatcher implements IQueueExecuter
	{
		
		private var _target:SDComponent;
		private var _targetParent:DisplayObjectContainer;
		private var _callback:Function;
		
		public function ViewChildQueueUnit(target:SDComponent, p:DisplayObjectContainer, createCompleteCallback:Function = null) 
		{
			super();
			this._target = target;
			this._targetParent = p;
			this._callback = createCompleteCallback;
			
		}
		
		public function dispose():void {
			this._target = null;
			this._targetParent = null;
			this._callback = null;
		}
		
		/* INTERFACE shipDock.interfaces.IQueueExecuter */
		
		public function commit():void 
		{
			this._target.creationComplete = this.createComplete;
			this._targetParent.addChild(this._target);
		}
		
		private function createComplete():void {
			(this._callback != null) && this._callback();
			this.queueNext();
			this._target = null;
			this._targetParent = null;
			this._callback = null;
		}
		
		/**
		 * 执行此对象所在队列的下一个队列元素
		 * 
		 */
		public function queueNext():void {
			this.dispatchEventWith(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT);
		}
		
		public function get queueSize():uint {
			return 1;
		}
		
		public function get eventDispatcher():EventDispatcher {
			return this as EventDispatcher;
		}
	}

}