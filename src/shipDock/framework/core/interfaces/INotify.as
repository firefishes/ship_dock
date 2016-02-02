package shipDock.framework.core.interfaces 
{
	
	/**
	 * 消息通知器
	 * 
	 * 实现此接口的类同时具备发送和接收消息的功能
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface INotify extends INoticeSender
	{
		function addNotice(noticeName:String, handler:Function, owner:* = null):void;
		function removeNotice(noticeName:String, handler:Function):void;
	}
	
}