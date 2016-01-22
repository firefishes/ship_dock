package shipDock.framework.application.component
{
	import flash.geom.Point;
	
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.manager.SDAssetManager;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	/**
	 * 位图文本类
	 *
	 * */
	public class SDQuadText extends SDQuadBatch
	{
		private var _textWidth:Number;
		private var _textHeight:Number;
		private var _fontSize:Number;
		private var _color:uint;
		private var _hAlign:String;
		private var _vAlign:String;
		private var _text:String;
		private var _fontName:String;
		private var _isShadow:Boolean;
		private var _point:Point;
		private var _bitmapFont:BitmapFont;
		private var _multiLine:Boolean;
		
		public function SDQuadText(textWidth:Number = 400, textHeight:Number = 0, text:String = "", fontSize:Number = -1, color:uint = 16777215, hAlign:String = "center", vAlign:String = "center", isShadow:Boolean = false)
		{
			super();
			this.fontName = SDCore.getInstance().assetManager.defaultFontName;
			this._point = new Point();
			this._color = color;
			this._textWidth = textWidth;
			this._textHeight = textHeight;
			this._fontSize = fontSize;
			this._hAlign = hAlign;
			this._vAlign = vAlign;
			
			this._isShadow = isShadow;
			this.text = text;
			this.touchable = false;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if (!!value && (fontSize != -1) && this._multiLine)
			{
				var num:int = this.textWidth / this.fontSize;
				var length:int = value.length;
				var newValue:String = "";
				for (var i:int = 0; i <= length; i++)
				{
					if ((i > 0) && ((i % num) == 0))
					{
						newValue += "\n";
					}
					newValue += value.charAt(i);
				}
				value = newValue;
			}
			if (value == null)
			{
				value = "";
			}
			_text = value;
			this.updateText();
		}
		
		public function updateText():void
		{
			this.reset();
			if(this._bitmapFont == null) {
				return;
			}
			this._bitmapFont.fillQuadBatch(this, this._textWidth * SDConfig.globalScale, this._textHeight * SDConfig.globalScale, this._text, this._fontSize * SDConfig.globalScale, this._color, this._hAlign, this._vAlign, true, true);
			this.checkShadow();
		}
		
		private function checkShadow():void
		{
			if (this._isShadow)
			{
				super.x = this._point.x + 2;
				super.y = this._point.y + 2;
			}
			else
			{
				super.x = this._point.x - 2;
				super.y = this._point.y - 2;
			}
		}
		
		public function get textWidth():Number
		{
			return _textWidth;
		}
		
		public function set textWidth(value:Number):void
		{
			_textWidth = value;
			this.updateText();
		}
		
		public function get textHeight():Number
		{
			return _textHeight;
		}
		
		public function set textHeight(value:Number):void
		{
			_textHeight = value;
			this.updateText();
		}
		
		public function get fontSize():Number
		{
			return _fontSize;
		}
		
		public function set fontSize(value:Number):void
		{
			_fontSize = value;
			this.updateText();
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			this.updateText();
		}
		
		public function get hAlign():String
		{
			return _hAlign;
		}
		
		public function set hAlign(value:String):void
		{
			_hAlign = value;
			this.updateText();
		}
		
		public function get vAlign():String
		{
			return _vAlign;
		}
		
		public function set vAlign(value:String):void
		{
			_vAlign = value;
			this.updateText();
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			this._point.x = this.x;
			this.checkShadow();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			this._point.y = this.y;
			this.checkShadow();
		}
		
		public function get multiLine():Boolean
		{
			return _multiLine;
		}
		
		public function set multiLine(value:Boolean):void
		{
			_multiLine = value;
		}

		public function get fontName():String
		{
			return _fontName;
		}

		public function set fontName(value:String):void
		{
			_fontName = value;
			this._bitmapFont = TextField.getBitmapFont(this._fontName);
		}

	}

}