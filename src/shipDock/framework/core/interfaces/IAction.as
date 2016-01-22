package shipDock.framework.core.interfaces
{

	/**
	 * 逻辑代理接口
	 * 
	 */
	public interface IAction extends IObserver,IDispose,INotify
	{
		function registered(noticeName:String, command:Class):void;
		function unsubscribe(commandName:String):void;
		function setProxyed(target:*):void;
		function callProxyed(invokeName:String, data:* = null, isNewNotice:Boolean = false):*;
		function getProxyedMethod(methodName:String):Function;
		function getAction(actionName:String):IAction;
		function get actionName():String;
		function get proxyed():*;
	}
}