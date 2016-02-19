package shipDock.framework.application
{
	import shipDock.framework.application.loader.FileLoaderConfig;
	import shipDock.framework.core.net.http.ServerConfig;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import starling.events.EventDispatcher;
	
	/**
	 * 框架总体配置
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDConfig
	{
		
		/**starling的显示基类*/
		public static const displayCls:Class = starling.display.DisplayObject;
		public static const containerCls:Class = starling.display.DisplayObjectContainer;
		
		/**原生的显示基类*/
		public static const displayRawCls:Class = flash.display.DisplayObject;
		public static const containerRawCls:Class = flash.display.DisplayObjectContainer;
		
		/**starling的事件类*/
		public static const eventDispatcherCls:Class = starling.events.EventDispatcher;
		
		/**原生的事件类*/
		public static const eventDispatcherRawCls:Class = flash.events.EventDispatcher;
		
		/**期望呈现的宽度*/
		public static var stageWidth:Number = 640;
		/**期望呈现的高度*/
		public static var stageHeight:Number = 960;
		/**屏幕自适应缩放因子，用于设置值坐标、宽高、缩放、注册点等信息时做缩放运算*/
		public static var globalScale:Number = 1;
		/**屏幕自适应的反缩放因子，用于获取值坐标、宽高、缩放、注册点等信息时做缩放逆运算*/
		public static var antScale:Number = 1;
		/**屏幕自适应后的总体水平偏移*/
		public static var mainOffsetX:Number;
		/**屏幕自适应后的总体垂直偏移*/
		public static var mainOffsetY:Number;
		/**具体项目的本地共享数据名*/
		public static var SOName:String = "SDGame";
		/**是否为Laya转换模式*/
		public static var isApplyLaya:Boolean = false;
		/**界面配置路径*/
		public static var viewConfigPath:String = "view/";
		
		/**
		 * 设置屏幕自适应所需的信息
		 *
		 */
		public static function setSizeSetting():void
		{
			var core:SDCore = SDCore.getInstance();
			var scaleX:Number = core.rawStage.stageWidth / SDConfig.stageWidth;
			var scaleY:Number = core.rawStage.stageHeight / SDConfig.stageHeight;
			SDConfig.globalScale = Math.min(scaleX, scaleY);
			SDConfig.antScale = 1 / SDConfig.globalScale;
			
			SDConfig.mainOffsetX = (core.rawStage.stageWidth - SDConfig.stageWidth * globalScale) / 2;
			SDConfig.mainOffsetY = (core.rawStage.stageHeight - SDConfig.stageHeight * globalScale) / 2;
			
			core.offsetX = SDConfig.mainOffsetX;
			core.offsetY = SDConfig.mainOffsetY;
			
			var application:Application = Application.application;
			if (!!application)
			{
				application.x = SDConfig.mainOffsetX;
				application.y = SDConfig.mainOffsetY;
			}
		}
		
		/**
		 * 设置服务器素材网关地址配置，及HTTP请求处理类
		 *
		 * @param	host
		 * @param	asset
		 * @param	HTTPTokenClass
		 */
		public static function setServerSetting(host:String, asset:String, HTTPTokenClass:Class):void
		{
			ServerConfig.host = host;
			ServerConfig.asset = asset;
			(!!HTTPTokenClass) && (ServerConfig.defaultHTTPTokenClass = HTTPTokenClass);
			FileLoaderConfig.assetHost = asset;
		}
		
		/**
		 * 设置文件地址配置
		 *
		 * @param	fileAsset
		 * @param	assetFilePath
		 * @param	configFilePaht
		 * @param	localeFilePath
		 */
		public static function setFileSetting(fileAsset:String, assetFilePath:String, configFilePaht:String, localeFilePath:String):void
		{
			FileLoaderConfig.assetHost = fileAsset;
			FileLoaderConfig.assetFilePath = assetFilePath;
			FileLoaderConfig.configFilePath = configFilePaht;
			FileLoaderConfig.localeFilePath = localeFilePath;
		}
		
		public function SDConfig()
		{
		
		}
	
	}

}