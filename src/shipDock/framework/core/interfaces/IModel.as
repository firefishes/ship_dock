package shipDock.framework.core.interfaces 
{
	
	/**
	 * 数据模型接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IModel extends IDispose
	{
		function checkAndSet(keyField:String, property:String, source:Object):Boolean;
		function updateData(data:Object):void;
		function getList(name:String):Array;
		function getNumber(name:String):Number;
		function getInt(name:String):int;
		function getText(name:String):String;
		function clone():IModel;
		function set id(value:String):void;
		function get id():String;
		function get modelType():int;
		function get name():String;
		function get modelData():Object;
	}
	
}