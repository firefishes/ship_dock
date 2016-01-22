package shipDock.framework.application.component
{
	import shipDock.framework.application.SDConfig;
	import starling.display.Quad;
	
	/**
	 * 四边形类
	 *
	 * ...
	 * @author HongSama
	 * @author shaoxin.ji
	 *
	 */
	public class SDQuad extends Quad
	{
		private var _globalScaleX:Number = 0;
		private var _globalScaleY:Number = 0;
		private var _globalScalePivotX:Number = 0;
		private var _globalScalePivotY:Number = 0;
		
		public function SDQuad(width:Number, height:Number, color:uint = 16777215, premultipliedAlpha:Boolean = true)
		{
			super(width * SDConfig.globalScale, height * SDConfig.globalScale, color, premultipliedAlpha);
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