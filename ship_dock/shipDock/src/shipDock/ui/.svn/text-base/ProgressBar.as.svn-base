package shipDock.ui 
{
	import shipDock.framework.application.component.SDClipped;
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.manager.SDAssetManager;

	/**
	 * ...
	 * @author HongSama
	 */
	public class ProgressBar extends SDSprite
	{
		protected var progressWidth:int;
		protected var progressHeight:int;
		protected var bar:SDImage;
		
		private var _index:Number = 0;
		private var offsetX:int = 0;
		private var offsetY:int = 0;
		private var clip:SDClipped;
		protected var onUpdate:Function;
		
		public function ProgressBar(width:int, 
									height:int, 
									progress:String, 
									offsetX:int = 0, 
									offsetY:int = 0, 
									border:String = null, 
									bg:String = null,
									onUpdate:Function = null)
		{
			super();
			this.onUpdate = onUpdate;
			this.progressWidth = width;
			this.progressHeight = height;
			
			var assetManager:SDAssetManager = SDAssetManager.getInstance();
			if (bg)
			{
				var bgImg:SDImage = assetManager.getImage(bg);
				bgImg.x = -offsetX;
				bgImg.y = -offsetY;
				addChild(bgImg);
			}
			bar = assetManager.getImage(progress);
			addChild(bar);
			
			if (border)
			{
				var boxImg:SDImage = assetManager.getImage(border);
				boxImg.x = -offsetX;
				boxImg.y = -offsetY;
				addChild(boxImg);
			}
		}
		
		
		public function get index():Number 
		{
			return _index;
		}
		
		public function set index(value:Number):void 
		{
			if (value > 100)
			{
				value = 100;
			}
			if (value < 0)
			{
				value = 0;
			}
			_index = value;
			update();
		}
		
		private function update():void
		{
			bar.scaleX = _index / 100;;
			if (onUpdate != null)
			{
				onUpdate();
			}
		}
	}

}