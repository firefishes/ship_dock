package shipDock.framework.core.interfaces {
	
	import shipDock.framework.core.interfaces.IDispose;
	
	import starling.events.EventDispatcher;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IQueueExecuter extends IDispose
	{
		function commit():void;
		function get queueSize():uint;
		function get eventDispatcher():EventDispatcher;
	}

}