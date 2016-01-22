package shipDock.framework.core.queueExecuter
{
	import starling.events.Event;
	
	/**
	 * 流程队列执行器事件
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class QueueExecuterEvent extends Event
	{
		
		public static const QUEUE_UNIT_EXECUTED_EVENT:String = "queueUnitExecutedEvent";
		public static const QUEUE_UNIT_NEXT_EVENT:String = "queueUnitNextEvent";
		public static const QUEUE_COMPLETE_EVENT:String = "queueCompleteEvent";
		
		public function QueueExecuterEvent(type:String, bubbles:Boolean = false, data:Object = null)
		{
			super(type, bubbles, data);
		
		}
	
	}

}