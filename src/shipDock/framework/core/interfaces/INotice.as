package shipDock.framework.core.interfaces 
{
	
	/**
	 * 消息接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface INotice extends IDispose
	{
		function changeName(value:String):void;
		function changeData(value:*):void;
		function sendSelf(noticeSender:INoticeSender, subCommand:String = null, args:Array = null, name:String = null):*;
		function get name():String;
		function get data():*;
		function set autoMethodName(value:String):void;
		function get autoMethodName():String;
		function get subCommand():String;
		function set subCommand(value:String):void;
		function set isExecuting(value:Boolean):void;
		function get isExecuting():Boolean;
		function get isAutoDispose():Boolean;
		function get observer():IObserver;
		function set actionName(name:String):void;
		function get actionName():String;
	}
	
}