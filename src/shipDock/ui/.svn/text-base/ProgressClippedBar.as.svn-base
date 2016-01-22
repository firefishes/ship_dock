package shipDock.ui
{
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.component.SDClipped;
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ProgressClippedBar extends SDSprite
	{
		public var progressWidth:Number;
		public var progressHeight:Number;
		
		private var _direction:int = DirectionType.HORIZONTAL;
		
		protected var _bar:SDImage;
		protected var _percentValue:Number = 0;
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;
		protected var clip:SDClipped;
		protected var onUpdate:Function;
		
		public function ProgressClippedBar(width:Number, height:Number, progress:*, offsetX:Number = 0, offsetY:Number = 0, border:* = null, bg:* = null, onUpdate:Function = null, rotation:Number = 0)
		{
			super();
			this.rotation = rotation;
			this.onUpdate = onUpdate;
			this.progressWidth = width;
			this.progressHeight = height;
			this._offsetX = offsetX;
			this._offsetY = offsetY;
			
			this.initUI(progress, border, bg);
		}
		
		protected function initUI(progress:*, border:* = null, bg:* = null):void {
			this.initBg(bg);
			this.initBar(progress);
			this.initClip();
			
			this.addChild(this.clip);
			
			this.initBorder(border);
		}
		
		protected function initBg(value:*):void {
			this.addProgressBarImage(value);
		}
		
		protected function initBar(value:*):void {
			this._bar = this.addProgressBarImage(value, false);
		}
		
		protected function initBorder(value:*):void {
			this.addProgressBarImage(value);
		}
		
		protected function initClip():void {
			this.clip = new SDClipped(progressWidth, progressHeight);
			this.clip.addChild(this._bar);
		}
		
		protected function addProgressBarImage(value:*, isApplyOffset:Boolean = true):SDImage
		{
			var result:SDImage;
			if (value != null)
			{
				if (value is String)
				{
					result = SDCore.getInstance().assetManager.getImage(value);
					if (isApplyOffset)
					{
						this.setImageOffset(result);
					}
					this.addChild(result);
				}
				else if (value is SDImage)
				{
					this.x = value.x;
					this.y = value.y;
					if (isApplyOffset)
					{
						this.setImageOffset(value);
					}
					value.x = 0;
					value.y = 0;
					result = value;
					this.addChild(result);
				}
			}
			return result;
		}
		
		private function setImageOffset(value:SDImage):void {
			value.x = -_offsetX;
			value.y = -_offsetY;
		}
		
		public function get percentValue():Number
		{
			return _percentValue;
		}
		
		public function set percentValue(value:Number):void
		{
			if (value > 100)
			{
				value = 100;
			}
			if (value < 0)
			{
				value = 0;
			}
			_percentValue = value;
			update();
		}
		
		public function get direction():int 
		{
			return _direction;
		}
		
		public function set direction(value:int):void 
		{
			_direction = value;
		}
		
		protected function update():void
		{
			var value:Number = this._percentValue / 100;
			switch(this._direction) {
				case DirectionType.HORIZONTAL:
					clip.changeClipSize(progressWidth * value, progressHeight);
					break;
				case DirectionType.VERTICAL:
					clip.changeClipSize(progressWidth, progressHeight * value);
					break;
			}
			if (onUpdate != null)
			{
				onUpdate();
			}
		}
	}

}