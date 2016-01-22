package shipDock.framework.application.component
{
	import shipDock.framework.application.SDConfig;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDQuadBatch extends QuadBatch
	{
		
		private var _globalScaleX:Number = 0;
		private var _globalScaleY:Number = 0;
		private var _globalScalePivotX:Number = 0;
		private var _globalScalePivotY:Number = 0;
		
		public function SDQuadBatch()
		{
			super();
		}
		
		public function addChild(child:DisplayObject):void
		{
			if (child is Image)
			{
				this.addImage(child as Image);
				
			}
			else if (child is Quad)
			{
				this.addQuad(child as Quad);
				
			}
			else if (child is QuadBatch)
			{
				this.addQuadBatch(child as QuadBatch);
			}
		}
		
		override public function get x():Number
		{
			return _globalScaleX;
		}
		
		override public function set x(value:Number):void
		{
			_globalScaleX = value;
			super.x = value * SDConfig.globalScale;
		}
		
		override public function get y():Number
		{
			return _globalScaleY;
		}
		
		override public function set y(value:Number):void
		{
			_globalScaleY = value;
			super.y = value * SDConfig.globalScale;
		}
		
		override public function get width():Number
		{
			return super.width * SDConfig.antScale;
		}
		
		override public function get height():Number
		{
			return super.height * SDConfig.antScale;
		}
		
		override public function get pivotX():Number
		{
			return _globalScalePivotX;
		}
		
		override public function set pivotX(value:Number):void
		{
			_globalScalePivotX = value;
			super.pivotX = value * SDConfig.globalScale;
		}
		
		override public function get pivotY():Number
		{
			return _globalScalePivotX;
		}
		
		override public function set pivotY(value:Number):void
		{
			_globalScalePivotY = value;
			super.pivotY = value * SDConfig.globalScale;
		}
	
	}

}