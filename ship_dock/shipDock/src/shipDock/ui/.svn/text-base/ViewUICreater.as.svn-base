package shipDock.ui
{
	
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDMovieClip;
	import shipDock.framework.application.component.SDQuadBatch;
	import shipDock.framework.application.component.SDQuadText;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.component.SDQuadButton;
	import shipDock.framework.application.SDCore;
	import shipDock.ui.manager.ViewUIDataManager;
	import shipDock.framework.core.utils.HashMap;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * View界面生成器
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class ViewUICreater
	{
		
		public static const VIEW_UI_TYPE_TEXT:int = 0;
		public static const VIEW_UI_TYPE_IMAGE:int = 1;
		public static const VIEW_UI_TYPE_MOVIE:int = 2;
		public static const VIEW_UI_TYPE_BUTTON:int = 3;
		public static const VIEW_UI_TYPE_QUAD:int = 4;
		public static const VIEW_UI_TYPE_CONTAINER:int = 5;
		public static const VIEW_UI_TYPE_DYNAMIC_TEXT:int = 6;
		
		private var _childraw:HashMap;
		private var _view:*;
		private var _UIConfigChanged:Object;
		private var _textList:Array;
		
		public function ViewUICreater(view:*, childraw:HashMap, configChanged:Object = null)
		{
			this._view = view;
			this._childraw = childraw;
			this._UIConfigChanged = configChanged;
			(this._UIConfigChanged == null) && (this._UIConfigChanged = {});
		}
		
		public function dispose():void
		{
			this._UIConfigChanged = null;
			this._childraw = null;
			this._textList = null;
		}
		
		public function createUI():void
		{
			var m:int;
			var i:int = 0;
			var j:int = 0;
			var UIData:Object = ViewUIDataManager.getInstance().getUIDataCache(this._view.UIConfigName);
			var UIList:Array = UIData["view"];
			var max:int = UIList.length;
			var content:SDSprite = this._view as SDSprite;
			if (content == null)
				return;
			this._textList = [];
			var quadBatch:SDQuadBatch;
			var list:Array, layerType:int, item:Object, name:String, type:int, staticText:SDQuadText;
			while (i < max)
			{
				j = 0;
				list = UIList[i];
				m = list.length;
				layerType = list[0]["type"];
				if (layerType == VIEW_UI_TYPE_TEXT)
				{
					quadBatch = new SDQuadBatch();
					quadBatch.touchable = false;
					quadBatch.name = "textQuadBatch";
				}
				while (j < m)
				{
					item = list[j];
					name = item["name"];
					type = int(item["type"]);
					if (type == VIEW_UI_TYPE_TEXT)
					{
						this._textList.push(name);
						staticText = this.initText(name, item);
						staticText.alpha = 0.99;
						quadBatch.addQuadBatch(staticText);
					}
					else if (type == VIEW_UI_TYPE_DYNAMIC_TEXT)
					{
						var dynamicText:SDQuadText = this.initText(name, item);
						if ((this._view as IView).isAutoRenderText)
						{ //默认不显示动态文本
							dynamicText.alpha = 0.99;
							content.addChild(dynamicText);
						}
						
					}
					else if (type == VIEW_UI_TYPE_IMAGE)
					{
						content.addChild(this.initImage(name, item));
					}
					else if (type == VIEW_UI_TYPE_MOVIE)
					{
						content.addChild(this.initMovie(name, item));
					}
					else if (type == VIEW_UI_TYPE_BUTTON)
					{
						content.addChild(this.initButton(name, item));
					}
					else if (type == VIEW_UI_TYPE_QUAD)
					{
						//暂时没有这项需求
					}
					else if (type == VIEW_UI_TYPE_CONTAINER)
					{
						content.addChild(this.initSDContainer(name, item));
					}
					j++;
				}
				if (quadBatch != null)
				{
					content.addChild(quadBatch);
					this._childraw.put(quadBatch.name, quadBatch);
				}
				quadBatch = null;
				i++;
			}
		}
		
		private function initSDContainer(name:String, item:Object):SDSprite
		{
			var container:SDSprite = new SDSprite();
			container.name = name;
			container.x = item["x"];
			container.y = item["y"];
			this._childraw.put(name, container);
			return container;
		}
		
		private function initText(name:String, item:Object):SDQuadText
		{
			this.checkPropertySet(item, "hAlign", "center");
			this.checkPropertySet(item, "vAlign", "center");
			var quadText:SDQuadText = new SDQuadText(item["textWidth"], item["textHeight"], item["text"], item["fontSize"], item["color"], item["hAlign"], item["vAlign"], item["isShadow"]);
			quadText.name = name;
			quadText.x = item["x"];
			quadText.y = item["y"];
			this._childraw.put(name, quadText);
			return quadText;
		}
		
		private function initImage(name:String, item:Object):SDImage
		{
			var image:SDImage = SDCore.getInstance().assetManager.getImage(item["texture"], item["isFlip"], item["isRePivot"]);
			image.x = item["x"];
			image.y = item["y"];
			image.name = name;
			this._childraw.put(name, image);
			var handler:Function = this._UIConfigChanged[name];
			(handler != null) && image.addEventListener(TouchEvent.TOUCH, handler);
			return image;
		}
		
		private function initMovie(name:String, item:Object):SDMovieClip
		{
			var movie:SDMovieClip = SDCore.getInstance().assetManager.getMovieClip(item["texture"], SDCore.getInstance().frameRate);
			movie.x = item["x"];
			movie.y = item["y"];
			movie.name = name;
			this._childraw.put(name, movie);
			return movie;
		}
		
		private function initButton(name:String, item:Object):SDQuadButton
		{
			this.checkPropertySet(item, "triggerPhase", TouchPhase.ENDED);
			this.checkPropertySet(item, "pi", 0);
			this.checkPropertySet(item, "isDown", true);
			
			var callback:Function = this._UIConfigChanged["touch"][name];
			var button:SDQuadButton = new SDQuadButton(item["texture"], item["labelTexture"], callback, item["triggerPhase"], item["needProvit"], item["pi"]);
			button.x = item["x"];
			button.y = item["y"];
			button.name = name;
			this._childraw.put(name, button);
			return button;
		}
		
		private function checkPropertySet(item:Object, key:String, defaultValue:*):void
		{
			(!item.hasOwnProperty(key)) && (item[key] = defaultValue);
		}
		
		public function get textList():Array
		{
			return _textList;
		}
	
	}

}