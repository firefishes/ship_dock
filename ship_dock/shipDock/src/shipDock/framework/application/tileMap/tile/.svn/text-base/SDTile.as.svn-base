package shipDock.framework.application.tileMap.tile
{
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.tileMap.SDTileTestSetting;
	import shipDock.framework.application.tileMap.base.SDTileObject;
	
	import starling.textures.Texture;
	import starling.utils.getNextPowerOfTwo;
	
	public class SDTile extends SDTileObject
	{
		
		private var _isTileDraw:Boolean;
		
		protected var _testTexture:Texture;
		protected var _height:Number;//等角图块的高度
		protected var _tileLineColor:uint;//等角图块轮廓线的颜色
		
		public function SDTile(size:Number, color:uint = 0xffffff, height:Number = 0)
		{
			super(size);
			this._height = height;
			this._tileLineColor = color;
			this.drawTile();
		}
		
		override public function dispose():void {
			super.dispose();
			(!!this._testTexture) && (this._testTexture.root.dispose());
		}
		
		override public function updateTileObject():void {
			super.updateTileObject();
			this.drawTile();
		}
		
		/**
		 * 绘制等角图块的轮廓线 
		 * 
		 */
		public function drawTile():void {
			if (this._isTileDraw)
				return;
			this._isTileDraw = true;
			var image:SDImage;
			if(!!SDTileTestSetting.testTextureName) {
				image = SDCore.getInstance().assetManager.getImage(SDTileTestSetting.testTextureName);
				image.x = -image.width / 2;
				image.y = -image.height / 2;
			}else if(!isNaN(SDTileTestSetting.testColor) && (SDTileTestSetting.testColor >= 0)) {
				var child:Shape = new Shape();
				var g:Graphics = child.graphics;
				g.clear();
				g.beginFill(this._tileLineColor);
				g.lineStyle(1, 0, 0.5);
				g.moveTo(-size, 0);
				g.lineTo(0, -size * 0.5);
				g.lineTo(size, 0);
				g.lineTo(0, size * 0.5);
				g.lineTo(-size, 0);
				g.endFill();
				var content:Sprite = new Sprite();
				content.addChild(child);
				var w:Number = getNextPowerOfTwo(int(content.width));
				var h:Number = getNextPowerOfTwo(int(content.height));
				var bmpData:BitmapData = new BitmapData(w, h, true, SDTileTestSetting.testColor);
				bmpData.draw(content);
				(!!this._testTexture) && (this._testTexture.root.dispose());
				this._testTexture = Texture.fromBitmapData(bmpData);
				bmpData.dispose();
				image = new SDImage(this._testTexture);
				image.pivotX = 0.5;
				image.pivotY = 0.5;
				content.x = 100;
				content.y = 100;
				SDCore.getInstance().rawStage.addChild(content);
			}
			(!!image) && (this.addChild(image));
		}
		
		override public function set height(value:Number):void {
			this._height = value;
			this.invalidate();
		}
		
		override public function get height():Number {
			return this._height;
		}
		
		public function set tileLineColor(value:uint):void {
			this._tileLineColor = value;
			this.invalidate();
		}
		
		public function get tileLIneColor():uint {
			return this._tileLineColor;
		}

	}
}