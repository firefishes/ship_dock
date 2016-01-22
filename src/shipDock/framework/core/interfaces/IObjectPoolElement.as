package shipDock.framework.core.interfaces 
{
	
	/**
	 * 对象池元素接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IObjectPoolElement extends IDispose, IPoolObject
	{
		function clear(v:*):void;
		function get objectClass():Class;
		function get className():String;
		function set target(value:*):void;
		function get target():*;
	}
	
}