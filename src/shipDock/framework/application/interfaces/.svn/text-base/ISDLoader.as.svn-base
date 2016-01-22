package shipDock.framework.application.interfaces
{
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IQueueExecuter;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public interface ISDLoader extends IQueueExecuter, IDispose
	{
		function load():void;
		function unload():void;
		function get rawData():*;
		function get loadedData():*;
		function get loadType():int;
		function set loadType(value:int):void;
		function get url():String;
		function set url(value:String):void;
		function get complete():Function;
		function set complete(value:Function):void;
		function get progress():Function;
		function set progress(value:Function):void;
		function set isAutoDispose(value:Boolean):void;
		function get isAutoDispose():Boolean;
		function get isAutoQueueNext():Boolean;
		function set isAutoQueueNext(value:Boolean):void;
		function get loaderStatu():int;
		function set loaderStatu(value:int):void;
		function get isLoading():Boolean;
		function get isLoaded():Boolean;
		function get isFinish():Boolean;
		function get isReady():Boolean;
		function get completeParams():Array;
		function set completeParams(value:Array):void;
	}

}