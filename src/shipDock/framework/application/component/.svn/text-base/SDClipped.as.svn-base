package shipDock.framework.application.component
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import shipDock.framework.application.component.SDQuad;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.SDConfig;
	
	/**
	 * 裁剪区域类
	 * 
	 * @Modify ch.ji
	 * 
	 */
	public class SDClipped extends SDSprite
	{
		/*可点击区域的宽*/
		private var _clipWidth:Number;
		/*可点击区域的高*/
		private var _clipHeight:Number;
		/*可点击区域的x坐标*/
		private var _clipX:Number;
		/*可点击区域的y坐标*/
		private var _clipY:Number;
		/*是否开启区域测试模式*/
		private var _testMode:Boolean;
		/*用于检测触屏的四边形对象*/
		private var _testQuad:SDQuad;
		/*矩形框是否可点击*/
		private var _isClipRect:Boolean;
		
		public function SDClipped(width:Number, height:Number, clipX:Number = 0, clipY:Number = 0, applyClipRect:Boolean = true)
		{
			super();
			_clipWidth = width * SDConfig.globalScale;
			_clipHeight = height * SDConfig.globalScale;
			_clipX = clipX * SDConfig.globalScale;
			_clipY = clipY * SDConfig.globalScale;
			this._isClipRect = applyClipRect;
			
			this.doClip();
			
			_testQuad = new SDQuad(SDConfig.stageWidth, SDConfig.stageHeight, 0x00ff00);
			var p:Point = localToGlobal(new Point(0, 0));
			_testQuad.x = p.x;
			_testQuad.y = p.y;
			_testQuad.alpha = 0.4;
			_testQuad.visible = false;
			
			addChild(_testQuad);
		}
		
		/**
		 * 实现裁剪
		 * 
		 */
		private function doClip():void
		{
			if (_isClipRect)
				this.clipRect = new Rectangle(_clipX, _clipY, _clipWidth, _clipHeight);
			else
				this.clipRect = null;
		}
		
		/**
		 * 修改裁剪的起始位置
		 * 
		 * @param	clipX
		 * @param	clipY
		 */
		public function changeClipPos(clipX:Number, clipY:Number):void
		{
			_clipX = clipX * SDConfig.globalScale;
			_clipY = clipY * SDConfig.globalScale;
		}
		
		/**
		 * 修改裁剪尺寸
		 * 
		 * @param	width
		 * @param	height
		 */
		public function changeClipSize(width:int, height:int):void
		{
			_clipWidth = width * SDConfig.globalScale;
			_clipHeight = height * SDConfig.globalScale;
			this.doClip();
		}
		
		/**
		 * getter 是否开启测试模式
		 * 
		 */
		public function get testMode():Boolean
		{
			return _testMode;
		}
		
		/**
		 * setter 是否开启测试模式
		 * 
		 */
		public function set testMode(value:Boolean):void
		{
			_testMode = value;
			_testQuad.visible = value;
		}
		
		/**
		 * getter 裁剪位置的x坐标
		 * 
		 */
		public function get clipX():Number
		{
			return _clipX * SDConfig.antScale;
		}
		
		/**
		 * setter 裁剪位置的x坐标
		 * 
		 */
		public function set clipX(value:Number):void
		{
			_clipX = value * SDConfig.globalScale;
			this.doClip();
		}
		
		/**
		 * getter 裁剪位置的y坐标
		 * 
		 */
		public function get clipY():Number
		{
			return _clipY * SDConfig.antScale;
		}
		
		/**
		 * setter 裁剪位置的y坐标
		 * 
		 */
		public function set clipY(value:Number):void
		{
			_clipY = value * SDConfig.globalScale;
			this.doClip();
		}
		
		/**
		 * getter 裁剪尺寸的宽度
		 * 
		 */
		public function get clipWidth():Number
		{
			return _clipWidth * SDConfig.antScale;
		}
		
		/**
		 * setter 裁剪尺寸的宽度
		 * 
		 */
		public function set clipWidth(value:Number):void
		{
			_clipWidth = value * SDConfig.globalScale;
			this.doClip();
		}
		
		/**
		 * getter 裁剪尺寸的高度
		 * 
		 */
		public function get clipHeight():Number
		{
			return _clipHeight * SDConfig.antScale;
		}
		
		/**
		 * setter 裁剪尺寸的高度
		 * 
		 */
		public function set clipHeight(value:Number):void
		{
			_clipHeight = value * SDConfig.globalScale;
			this.doClip();
		}
		
		/**
		 * getter 是否开启裁剪
		 * 
		 */
		public function get isClipRect():Boolean 
		{
			return _isClipRect;
		}
		
		/**
		 * setter 是否开启裁剪
		 * 
		 */
		public function set isClipRect(value:Boolean):void 
		{
			_isClipRect = value;
			this.doClip();
		}
	}
}