package shipDock.framework.application.tileMap.tileTest
{
	import shipDock.framework.application.tileMap.tile.SDTile;

	public class SDTileBox extends SDTile
	{
		public function SDTileBox(size:Number, color:uint, height:Number=0)
		{
			super(size, color, height);
		}

		override public function draw():void
		{
//			graphics.clear();
			var red:int = this._tileLineColor >> 16;
			var green:int = this._tileLineColor >> 8 & 0xff;
			var blue:int = this._tileLineColor & 0xff;
			var leftShadow:uint = (red * .5) << 16 |(green * .5) << 8 |(blue * .5);
			var rightShadow:uint = (red * .75) << 16 |(green * .75) << 8 | (blue * .75);
			var h:Number = _height * Y_CORRECT;
			
			// draw top
//			graphics.beginFill(this._tileLineColor);
//			graphics.lineStyle(0, 0, .5);
//			graphics.moveTo(-_size, -h);
//			graphics.lineTo(0, -_size * .5 - h);
//			graphics.lineTo(_size, -h);
//			graphics.lineTo(0, _size * .5 - h);
//			graphics.lineTo(-_size, -h);
//			graphics.endFill();
//			// draw left
//			graphics.beginFill(leftShadow);
//			graphics.lineStyle(0, 0, .5);
//			graphics.moveTo(-_size, -h);
//			graphics.lineTo(0, _size * .5 - h);
//			graphics.lineTo(0, _size * .5);
//			graphics.lineTo(-_size, 0);
//			graphics.lineTo(-_size, -h);
//			graphics.endFill();
//			// draw right
//			graphics.beginFill(rightShadow);
//			graphics.lineStyle(0, 0, .5);
//			graphics.moveTo(_size, -h);
//			graphics.lineTo(0, _size * .5 - h);
//			graphics.lineTo(0, _size * .5);
//			graphics.lineTo(_size, 0);
//			graphics.lineTo(_size, -h);
//			graphics.endFill();
		}
	}
}