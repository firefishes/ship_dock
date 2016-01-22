package shipDock.framework.application.interfaces {
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IQueueExecuter;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	
	import starling.animation.IAnimatable;
	
	/**
	 * 特效接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IEffect extends IQueueExecuter,IAnimatable,IDispose
	{
		
		function effectFinish(event:QueueExecuterEvent = null):void;
		function frameRender(time:Number):void;
		function get delayFinishTime():Number;
		function set delayFinishTime(value:Number):void;
		function get autoRemove():Boolean;
		function set autoRemove(value:Boolean):void;
		function get frameRate():int;
		function set frameRate(value:int):void;
	}
	
}