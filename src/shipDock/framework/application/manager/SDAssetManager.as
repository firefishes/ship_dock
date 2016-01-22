package shipDock.framework.application.manager
{
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDMovieClip;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.LoadType;
	import shipDock.framework.application.singletonAgent.SDAssetManagerSingleton;
	import shipDock.framework.application.utils.DisplayUtils;
	import shipDock.framework.core.interfaces.ISingleton;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.utils.StringUtils;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	/**
	 * 素材管理器（代理单例）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDAssetManager extends AssetManager implements ISingleton
	{
		
		public static const SD_ASSET_MANAGER:String = "SDAssetMgr";
		
		private static var textureCache:Object = {};
		private static var atlasCache:Object = {};
		private static var texturesCache:Object = {};
		private static var instance:SDAssetManager;
		
		public static function getInstance(antScale:Number = 0):SDAssetManager
		{
			var result:SDAssetManager = SingletonManager.singletonManager().getSingleton(SD_ASSET_MANAGER) as SDAssetManager;
			if (result == null)
			{
				antScale = (antScale == 0) ? SDConfig.antScale : antScale;
				result = new SDAssetManager(antScale);
			}
			return result;
		}
		
		private var _assetLoaded:Array = [];
		private var _basePath:String = '/assets/';
		private var _pngPath:String = 'pngs/';
		private var _atfPath:String = 'atf/';
		private var _atfsPath:String = 'atfs/';
		private var _assetConfigPath:String = 'xml/';
		private var _defaultFontName:String = "font";
		private var _isPackageByAtf:Boolean;
		private var _fontXMLPath:String = "../../../embed/font/font.fnt";
		private var _singletonAgent:SDAssetManagerSingleton;
		
		public function SDAssetManager(scaleValue:Number = 1, flag:Boolean = false)
		{
			super(scaleValue, flag);
			this._singletonAgent = new SDAssetManagerSingleton(this, SD_ASSET_MANAGER);
		}
		
		public function initSingleton():void
		{
			this._singletonAgent.initSingleton();
		}
		
		public function getInstance():ISingleton
		{
			return this._singletonAgent.getInstance();
		}
		
		public function enqueueATF(name:String):void
		{
			Texture.bgraFormat = "bgra";
			var assetsPath:String = this._basePath + this._atfPath + this._atfsPath + name;
			var XMLPath:String = this._basePath + this._assetConfigPath + this._atfsPath + name;
			this.enqueue(assetsPath + ".atf");
			this.enqueue(XMLPath + ".xml");
		}
		
		public function enqueuePNG(name:String, hasXML:Boolean = true):void
		{
			Texture.bgraFormat = "bgra"; //原值为"bgraPacked4444"，但图片色彩会丢失，需要进一步研究;
			var assetsPath:String = this._basePath + this._atfPath + this._pngPath + name;
			var XMLPath:String = this._basePath + this._assetConfigPath + this._pngPath + name;
			this.enqueue(assetsPath + ".png");
			(hasXML) && this.enqueue(XMLPath + ".xml");
		}
		
		public function getImage(name:String, isFlip:Boolean = false, isRePivot:Boolean = false):SDImage
		{
			var tt:Texture = getTexture(name);
			if (tt == null)
				return null;
			var image:SDImage = new SDImage(tt);
			(isFlip) && (image.scaleX = -1);
			(isRePivot) && DisplayUtils.rePivot(image);
			return image;
		}
		
		public function getMovieClip(mcName:String, fps:Number):SDMovieClip
		{
			var result:SDMovieClip = new SDMovieClip(mcName, fps);
			return result;
		}
		
		override public function getTexture(name:String):Texture
		{
			(textureCache[name] == null) && (textureCache[name] = super.getTexture(name));
			return textureCache[name];
		}
		
		override public function getTextures(prefix:String = "", result:Vector.<Texture> = null):Vector.<Texture>
		{
			(texturesCache[prefix] == null) && (texturesCache[prefix] = super.getTextures(prefix, result));
			return texturesCache[prefix];
		}
		
		override public function getTextureAtlas(name:String):TextureAtlas
		{
			(atlasCache[name] == null) && (atlasCache[name] = super.getTextureAtlas(name));
			return atlasCache[name];
		}
		
		public function loadFont(path:String):*
		{
			var result:*;
			(!!path) && (this._fontXMLPath = path);
			var fontName:String = StringUtils.getTextureIDByPath(path);
			var dataLoader:DataLoader = new DataLoader(path, this.loadFontComplete);
			dataLoader.loadType = LoadType.LOAD_TYPE_TEXT;
			dataLoader.isAutoDispose = true;
			dataLoader.isAutoQueueNext = true;
			dataLoader.completeParams = [fontName];
			result = dataLoader;
			return result;
		}
		
		private function loadFontComplete(data:*, fontName:String):void
		{
			var texture:Texture = this.getTexture(fontName);
			var fontXML:XML = new XML(data);
			fontXML.info.@face = fontName;
			var bitmapFont:BitmapFont = new BitmapFont(texture, fontXML);
			TextField.registerBitmapFont(bitmapFont);
		}
		
		override public function removeTextureAtlas(name:String, dispose:Boolean = true):void
		{
			var index:int = assetLoaded.indexOf(name);
			if (index >= 0)
			{
				assetLoaded.splice(index, 1);
				this.releaseTextureAtlas(name, dispose);
			}
		}
		
		public function removeTextureAtlaes(names:Array):void
		{
			for (var i:int = 0; i < names.length; i++)
			{
				removeTextureAtlas(names[i]);
			}
		}
		
		public function removeGAFTextureAtlas(gafAry:Array):void
		{
			for each (var key:String in gafAry)
			{
				this.releaseTexture(key);
			}
		}
		
		/**
		 * 释放纹理
		 *
		 * @param target 支持字符串和数组
		 *
		 */
		public function releaseTextures(target:*):void
		{
			var list:Array = [];
			if (target is Array)
				list = target;
			else if (target is String)
				list.push(target);
			else
				return;
			var i:int = 0;
			var max:int = list.length;
			while (i < max)
			{
				var name:String = list[i];
				var texture:Texture = super.getTexture(name);
				if (texture == null)
				{
					/*[IF-SCRIPT-BEGIN]
					   var atlas:TextureAtlas = super.getTextureAtlas(name);
					   if(!!atlas) {
					   super.removeTextureAtlas(name);
					 }[IF-SCRIPT-END]*/
				}
				else
				{
					var index:int = assetLoaded.indexOf(name);
					(index >= 0) && assetLoaded.splice(index, 1);
					this.releaseTexture(name);
				}
				i++;
			}
		}
		
		/**
		 * 释放纹理
		 *
		 * @param name 纹理名
		 * @param dispose
		 *
		 */
		private function releaseTexture(name:String, dispose:Boolean = true):void
		{
			super.removeTexture(name, dispose);
			super.removeXml(name);
		}
		
		/**
		 * 释放纹理集
		 *
		 * @param name 纹理名
		 * @param dispose
		 *
		 */
		private function releaseTextureAtlas(name:String, dispose:Boolean = true):void
		{
			super.removeTextureAtlas(name, dispose);
			super.removeXml(name);
		}
		
		public function get assetLoaded():Array
		{
			return _assetLoaded;
		}
		
		public function set assetLoaded(value:Array):void
		{
			_assetLoaded = value;
		}
		
		public function get basePath():String
		{
			return _basePath;
		}
		
		public function set basePath(value:String):void
		{
			_basePath = value;
		}
		
		public function get pngPath():String
		{
			return _pngPath;
		}
		
		public function set pngPath(value:String):void
		{
			_pngPath = value;
		}
		
		public function get atfPath():String
		{
			return _atfPath;
		}
		
		public function set atfPath(value:String):void
		{
			_atfPath = value;
		}
		
		public function get atfsPath():String
		{
			return _atfsPath;
		}
		
		public function set atfsPath(value:String):void
		{
			_atfsPath = value;
		}
		
		public function get assetConfigPath():String
		{
			return _assetConfigPath;
		}
		
		public function set assetConfigPath(value:String):void
		{
			_assetConfigPath = value;
		}
		
		public function get isPackageByAtf():Boolean
		{
			return _isPackageByAtf;
		}
		
		public function set isPackageByAtf(value:Boolean):void
		{
			_isPackageByAtf = value;
		}
		
		public function get fontXMLPath():String
		{
			return _fontXMLPath;
		}
		
		public function set fontXMLPath(value:String):void
		{
			_fontXMLPath = value;
		}
		
		public function get singletonName():String
		{
			return this._singletonAgent.singletonName;
		}
		
		public function get singleRefrence():*
		{
			return this._singletonAgent.singleRefrence;
		}
		
		public function get defaultFontName():String
		{
			return _defaultFontName;
		}
		
		public function set defaultFontName(value:String):void
		{
			_defaultFontName = value;
		}
	
	}
}