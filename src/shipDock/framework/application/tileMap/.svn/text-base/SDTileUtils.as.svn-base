package shipDock.framework.application.tileMap
{
	import flash.geom.Point;
	
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.tileMap.base.SDTilePoint;
	
	public class SDTileUtils
	{
		public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2;// 1.2247的精确计算版本
		
		public function SDTileUtils()
		{
		}
		
		/**
		 * 把等角空间中的一个3D坐标点转换成屏幕上的2D坐标点
		 * 
		 * @param pos 是一个3D坐标点 IsoWorldPoint
		 * @return 
		 * 
		 */
		public static function diamondISOToScreen(pos:SDTilePoint):Point {
			var screenX:Number = pos.x - pos.z;
			var screenY:Number = pos.y * Y_CORRECT + (pos.x + pos.z) * 0.5;
			return new Point(screenX * SDConfig.antScale, screenY * SDConfig.antScale);
		}
		
		/**
		 * 把屏幕上的2D坐标点转换成等角空间中的一个3D坐标点，设y=0
		 * 
		 * @param point 是一个2D坐标点
		 * @return 
		 * 
		 */
		public static function diamondScreenToISO(point:Point):SDTilePoint
		{
			var xpos:Number = (point.y + point.x * .5);// * SDConfig.globalScale;
			var ypos:Number = 0;
			var zpos:Number = (point.y - point.x * .5);// * SDConfig.globalScale;
			return new SDTilePoint(xpos, ypos, zpos);
		}
		
		/**
		 * 根据网格坐标取得象素坐标
		 * 
		 * @param	pos
		 * @param	tileSize
		 * @return
		 */
		public static function staggeredISOToScreen(tileSize:int, tx:int, ty:int):Point
		{
			var tileHeight:int = tileSize * 0.5;
			var tileCenter:int = (tx * tileSize) + tileSize * 0.5;//偶数行tile中心
			var x:int = tileCenter + (ty & 1) * tileSize * 0.5;// x象素  如果为奇数行加半个宽
			var y:int = (ty + 1) * tileSize * 0.25;// y象素
			return new Point(x, y);
		}
		
		//根据屏幕象素坐标取得网格的坐标
		public static function staggeredScreenToISO(tileSize:int, screenX:int, screenY:int):SDTilePoint
		{
			var x:int = 0, y:int = 0, z:int = 0;
			var cx:int, cy:int, rx:int, ry:int;
			var tileHeight:int = tileSize * 0.5;
			
			cx = int(screenX / tileSize) * tileSize + tileSize / 2;	//计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
			cy = int(screenY / tileHeight) * tileHeight + tileHeight / 2;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
			
			rx = (screenX - cx) * tileHeight / 2;
			ry = (screenY - cy) * tileSize / 2;
			
			if (Math.abs(rx) + Math.abs(ry) <= tileSize * tileHeight / 4)
			{
				x = int(screenX / tileSize);
				z = int(screenY / tileHeight) * 2;
			}
			else
			{
				screenX = screenX - tileSize / 2;
				x = int(screenX / tileSize) + 1;
				
				screenY = screenY - tileHeight / 2;
				z = int(screenY / tileHeight) * 2 + 1;
			}
			
			return new SDTilePoint(x - (z & 1), 0, z);
		}

	}
}