package shipDock.framework.core.interfaces 
{
	
	/**
	 * 主题接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface ISubject extends IDispose
	{
		function notify(notice:INotice = null):void;
		function registered(observer:IObserver):void;
		function unsubscribe(observer:IObserver):void;
		function getAction(actionName:String):IAction;
		function set subjectName(value:String):void;
		function get subjectName():String;
	}
	
}