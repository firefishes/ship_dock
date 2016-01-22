package shipDock.framework.application.tileMap.tileFactory
{
	import shipDock.framework.application.interfaces.ITileObject;
	
	public class SDTileObjectFactory
	{
		public function SDTileObjectFactory()
		{
		}
		
		public static function createInstance(cls:Class, tileSize:Number, params:Object):ITileObject {
			var result:ITileObject = new cls(tileSize);
			result.setTileParams(params);
			return result;
		}

	}
}