package shipDock.framework.application.effect
{
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	import shipDock.framework.core.utils.SDUtils;
	
	/**
	 * 队列特效
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class QueueEffect extends SDEffect
	{
		
		protected var _effectList:Array;
		protected var _waitingCount:int;
		
		/**
		 * 队列特效
		 *  
		 * @param list
		 * 
		 */		
		public function QueueEffect(list:Array = null)
		{
			super();
			this._waitingCount = 0;
			this._effectList = (!!list) ? list : [];
		}
		
		override public function effectFinish(event:QueueExecuterEvent = null):void
		{
			this._queue.removeEventListener(QueueExecuterEvent.QUEUE_UNIT_EXECUTED_EVENT, this.queueUnitExecutedHandler);
			super.effectFinish(event);
		}
		
		private function initQueue(index:int):void
		{
			this._queue.add(this._effectList[index]);
		}
		
		/**
		 * 启动动画
		 *
		 */
		override public function effectStart():void {
			
			this._waitingCount = this._effectList.length;
			SDUtils.wLoop(0, this._effectList.length, this.initQueue);
			this._queue.addEventListener(QueueExecuterEvent.QUEUE_UNIT_EXECUTED_EVENT, this.queueUnitExecutedHandler);
			this._queue.commit();
		}
		
		protected function queueUnitExecutedHandler(event:QueueExecuterEvent):void
		{
			this._waitingCount--;
		}
		
		override protected function finishCallback():void
		{
			super.finishCallback();
			this._effectList = null;
		}
		
		public function get waitingCount():int
		{
			return _waitingCount;
		}
		
		public function get effectList():Array
		{
			return _effectList;
		}
	}

}