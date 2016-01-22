package shipDock.framework.application.tileMap.tileTest
{
	import shipDock.framework.application.interfaces.IPhysicalTileObject;
	import shipDock.framework.application.tileMap.SDTileWorldSetting;
	import shipDock.framework.application.tileMap.base.SDTileObject;

	public class SDPhysicalTileObject extends SDTileObject implements IPhysicalTileObject
	{
		public var isApplyGravity:Boolean = true;
		public var isApplyBounce:Boolean = true;
		public var isApplyFriction:Boolean = true;
		public var mass:Number = 1;
		
		public function SDPhysicalTileObject(size:Number)
		{
			super(size);
			this.draw();
		}
		
		override public function updateMotion():void {
			super.updateMotion();
		}
		
		/**
		 * 绘制等角图块的轮廓线 
		 * 
		 */
		public function draw():void
		{
//			graphics.clear();
			var red:int = 0x254898 >> 16;
			var green:int = 0x254898 >> 8 & 0xff;
			var blue:int = 0x254898 & 0xff;
			var leftShadow:uint = (red * .5) << 16 |(green * .5) << 8 |(blue * .5);
			var rightShadow:uint = (red * .75) << 16 |(green * .75) << 8 | (blue * .75);
			var h:Number = this.height * Y_CORRECT;
			
			// draw top
//			graphics.beginFill(0x254898);
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
		
		public function gravityMotion():void {
			if(SDTileWorldSetting.isApplyWorldGravity && this.isApplyGravity) {
				this.vy += SDTileWorldSetting.G;
			}
		}
		
		public function bounceMotion():void {
			if(SDTileWorldSetting.isApplyWorldBounce && this.isApplyBounce) {
				this.vx *= SDTileWorldSetting.bounce;
				this.vx *= SDTileWorldSetting.bounce;
				this.vx *= SDTileWorldSetting.bounce;
			}
		}
		
		public function frictionMotion():void {
			if(SDTileWorldSetting.isApplyWorldFriction && this.isApplyFriction) {
				this.vx *= SDTileWorldSetting.friction;
				this.vx *= SDTileWorldSetting.friction;
				this.vx *= SDTileWorldSetting.friction;
			}
		}
		
	}
}