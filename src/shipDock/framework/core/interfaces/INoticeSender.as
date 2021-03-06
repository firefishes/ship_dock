package shipDock.framework.core.interfaces 
{
	
	/**
	 * 消息发送器
	 * 
	 * 实现此接口的类只能发送消息，不接收消息
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface INoticeSender 
	{
		function sendNotice(target:*, body:* = null, subCommand:String = null, observer:IObserver = null, autoDispose:Boolean = true):*;
	}
	
}