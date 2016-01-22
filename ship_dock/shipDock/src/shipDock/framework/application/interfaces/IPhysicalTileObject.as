package shipDock.framework.application.interfaces
{
	public interface IPhysicalTileObject extends ITileObject
	{
		function gravityMotion():void;
		function bounceMotion():void;
		function frictionMotion():void;
	}
}