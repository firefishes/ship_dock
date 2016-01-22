package shipDock.framework.core.interfaces 
{
	
	/**
	 * 发送网络请求命令的消息接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IHTTPNotice extends INotice, INoticeSender
	{
		function successed(result:Object):void;
		function failed(result:Object):void;
		function get method():String;
		function set method(value:String):void;
		function get doSuccess():Function;
		function set doSuccess(value:Function):void;
		function get doFail():Function;
		function set doFail(value:Function):void;
		function get token():IHTTPToken;
		function set token(value:IHTTPToken):void;
		function get isUseDefaultFail():Boolean;
		function set isUseDefaultFail(value:Boolean):void;
		function get dataFormat():String;
		function set dataFormat(value:String):void;
		function get requestMethod():String;
		function set requestMethod(value:String):void;
		function get isFalseData():Boolean;
		function set isFalseData(value:Boolean):void;
	}
	
}