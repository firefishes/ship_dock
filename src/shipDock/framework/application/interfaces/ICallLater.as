package shipDock.framework.application.interfaces 
{
	
	/**
	 * 推迟下一帧更新机制接口
	 * 
	 * ...
	 * @author ch.ji
	 */
	public interface ICallLater 
	{
		function redraw():void;
		function invalidate():void;
		function invalidateHandler(event:* = null):void;
		function get isApplyCallLater():Boolean;
		function set isApplyCallLater(value:Boolean):void;
	}
	
}