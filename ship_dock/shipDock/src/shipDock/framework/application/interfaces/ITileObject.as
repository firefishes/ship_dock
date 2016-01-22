package shipDock.framework.application.interfaces
{
	import flash.geom.Rectangle;
	
	import shipDock.framework.application.tileMap.base.SDTilePoint;
	import shipDock.framework.core.interfaces.IDispose;
	
	public interface ITileObject extends ICallLater,IDispose
	{
		function setTileParams(value:Object):void;
		function updateTileObject():void;
		function updateScreenPos():void;
		function updateMotion():void;
		function set x(value:Number):void;
		function get x():Number;
		function set y(value:Number):void;
		function get y():Number;
		function set z(value:Number):void;
		function get z():Number;
		function set tilePoint(value:SDTilePoint):void;
		function get tilePoint():SDTilePoint;
		function get depth():Number;
		function get size():Number;
		function get rect():Rectangle;
	}
}