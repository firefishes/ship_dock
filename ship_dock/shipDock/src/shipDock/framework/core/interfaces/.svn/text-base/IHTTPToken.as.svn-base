package shipDock.framework.core.interfaces
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	public interface IHTTPToken
	{
		function send(method:String = null, params:Object = null, isUseDefaultFail:Boolean = true, dataFormat:String = null, requestMethod:String = "POST"):void;
		function callCompleteHandler(event:Event):void;
		function callProgressHandler(event:ProgressEvent):void;
		function openHandler(event:Event):void;
		function securityErrorHandler(event:SecurityErrorEvent):void
		function httpStatusHandler(event:HTTPStatusEvent):void;
		function ioErrorHandler(event:IOErrorEvent):void;
		function get url():String;
		function get data():*;
		function set resultType(value:String):void;
		function get resultType():String;
		function set isUseRawResult(value:Boolean):void;
		function get isUseRawResult():Boolean;
		function set isUseDefaultFail(value:Boolean):void;
		function get isUseDefaultFail():Boolean;
	}
}