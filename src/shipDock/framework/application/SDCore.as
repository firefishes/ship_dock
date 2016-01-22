package shipDock.framework.application
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import shipDock.framework.application.manager.LoaderManager;
	
	import shipDock.framework.application.interfaces.IApplication;
	import shipDock.framework.application.manager.ApplicationDomainManager;
	import shipDock.framework.application.manager.FileManager;
	import shipDock.framework.application.manager.SDAssetManager;
	import shipDock.framework.core.SDFramework;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.methodExecuter.MethodCenter;
	import shipDock.framework.core.singleton.SingletonBase;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 *
	 * 应用框架控制器，核心单例
	 *
	 * @author shaoxin.ji
	 */
	public class SDCore extends SingletonBase
	{
		
		public static const SD_CORE:String = "shipDockCore";
		
		public static function getInstance():SDCore
		{
			var result:SDCore = SingletonManager.singletonManager().getSingleton(SD_CORE) as SDCore;
			if (result == null)
			{
				SingletonManager.singletonManager().addSingleton(SDCore);//首次获取，注册单例
				result = getInstance();
			}
			return result;
		}
		
		/*帧率*/
		private var _frameRate:int;
		/*是否已被激活*/
		private var _isActive:Boolean;
		/*总体的水平方向坐标修正*/
		private var _offsetX:Number;
		/*总体的竖直方向坐标修正*/
		private var _offsetY:Number;
		/*播放速度，用于加速或放慢游戏速度*/
		private var _playSpeed:Number;
		/*原生舞台对象*/
		private var _rawStage:Stage;
		/*框架的动画控制器*/
		private var _juggler:SDJuggler;
		/*starling对象*/
		private var _SDStarling:Starling;
		/*应用单例引用*/
		private var _gameApplication:IApplication;
		/*TODO SoundManager*/
		private var _gameSound:*;
		/*启动核心的参数*/
		private var _runCoreParams:CoreParams;
		/*回调函数中心*/
		private var _methodCenter:MethodCenter;
		
		public function SDCore()
		{
			super(this, SD_CORE);
			this._offsetX = 0;
			this._offsetY = 0;
			this._playSpeed = 1;
			this._frameRate = 60;
			this._methodCenter = new MethodCenter();
		}
		
		/**
		 * 设置入口外壳的实例
		 * 
		 * @param	main
		 */
		public function setMain(main:flash.display.Sprite, appClass:Class, w:Number, h:Number, frameRatge:uint):void {
			this._runCoreParams = new CoreParams(main, appClass, w, h, frameRate);
			if (!!main.stage)
				this.addMainToStageHandler();
			else
				main.addEventListener(flash.events.Event.ADDED_TO_STAGE, this.addMainToStageHandler);
		}
		
		/**
		 * 入口外壳被加入显示列表事件处理函数
		 * 
		 * @param	event
		 */
		private function addMainToStageHandler(event:flash.events.Event = null):void {
			var main:flash.display.Sprite = this._runCoreParams.main;
			main.removeEventListener(flash.events.Event.ADDED_TO_STAGE, this.addMainToStageHandler);
			
			this.initRawStage();
			this.run(this._runCoreParams.cls, main.stage, this._runCoreParams.width, this._runCoreParams.height, this._runCoreParams.frameRate);
		}
		
		/**
		 * 初始化原生舞台
		 * 
		 */
		private function initRawStage():void
		{
			var main:flash.display.Sprite = this._runCoreParams.main;
			main.mouseEnabled = false;
			main.mouseChildren = false;
			
			this.rawStage = main.stage;
			
			if (!!this.rawStage)
			{
				this.rawStage.align = StageAlign.TOP_LEFT;
				this.rawStage.scaleMode = StageScaleMode.NO_SCALE;
				this.rawStage.addEventListener(flash.events.Event.RESIZE, rawStageResizeHandler, false, int.MAX_VALUE, true);
				this.rawStage.addEventListener(flash.events.Event.DEACTIVATE, rawStageDeactivateHandler, false, 0, true);
			}
		
			/*[IF-FLASH]*/NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			/*[IF-FLASH]*/Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
		
		/**
		 * 原生舞台尺寸重设置事件处理函数
		 * 
		 * @param	event
		 */
		private function rawStageResizeHandler(event:flash.events.Event):void
		{
			this.useCallbackAndAddEventParams("rawStageResize", event);//调用尺寸重置事件的回调
			(this.isActive) && this.checkResize();
		}
		
		/**
		 * 原生舞台失活事件处理函数
		 * 
		 * @param	event
		 */
		private function rawStageDeactivateHandler(event:flash.events.Event):void
		{
			this.useCallbackAndAddEventParams("rawStageDeactivate", event);//调用原生舞台失活事件的回调
			(!this._rawStage.hasEventListener(flash.events.Event.ACTIVATE)) && this._rawStage.addEventListener(flash.events.Event.ACTIVATE, rawStageActivateHandler, false, 0, true);
			this.starling.stop();
		}
		
		/**
		 * 原生舞台激活事件处理函数
		 * 
		 * @param	event
		 */
		private function rawStageActivateHandler(event:flash.events.Event):void
		{
			this.useCallbackAndAddEventParams("rawStageActivate", event);//调用原生舞台重激活事件的回调
			(this._rawStage.hasEventListener(flash.events.Event.ACTIVATE)) && this._rawStage.removeEventListener(flash.events.Event.ACTIVATE, rawStageActivateHandler, false);
			//ServerTime.instance.onStageActivate();
			this.starling.start();
		}
		
		/**
		 * 带上事件函数对象之后再调用外部的回调函数
		 * 
		 * @param	id
		 * @param	event
		 */
		private function useCallbackAndAddEventParams(id:String, event:*):void {
			var args:Array = this._methodCenter.getMethodArgs(id);
			args = args.concat();//使用参数列表的拷贝
			args.unshift(event);//使用事件参数对象作为第一个参数
			this._methodCenter.useCallback(id, args);
		}
		
		/**
		 * 运行框架
		 *
		 * @param	appCls
		 * @param	stage
		 * @param	width
		 * @param	height
		 * @param	frameRate
		 */
		public function run(appCls:Class, stage:Stage, width:int = 640, height:int = 960, frameRate:int = 60):void
		{
			if (this._isActive)
				return;
			this._isActive = true;
			var framework:SDFramework = new SDFramework(this.framworkStartUp); //启动 shipDock 框架核心
			
			SDConfig.stageWidth = width;
			SDConfig.stageHeight = height;
			
			(this.rawStage == null) && (this.rawStage = stage);
			this.rawStage.frameRate = frameRate;
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			
			this._SDStarling = new Starling(appCls, stage, null, null, "auto", ["baseline"]); //启动starling
			this._SDStarling.enableErrorChecking = false;
			this._SDStarling.addEventListener(starling.events.Event.ROOT_CREATED, this.starlingRootCreatedHandler);
			this._SDStarling.start();
			
			this.startJuggler();
		
		}
		
		protected function framworkStartUp():void
		{
			new FileManager(); //文件操作管理器
			new ApplicationDomainManager(); //应用域管理器
		}
		
		/**
		 * starling根显示列表创建完毕事件处理函数
		 *
		 * @param	event
		 */
		protected function starlingRootCreatedHandler(event:starling.events.Event):void
		{
			this._SDStarling.removeEventListener(starling.events.Event.ROOT_CREATED, this.starlingRootCreatedHandler);
			this._methodCenter.useCallback("starlingRootCreated");
			this.dispatchEventWith(starling.events.Event.ROOT_CREATED);
		}
		
		/**
		 * 启动框架的动画管理器
		 *
		 */
		public function startJuggler():void
		{
			if (this._juggler == null)
			{
				this._juggler = new SDJuggler();
				(!Starling.juggler.contains(this._juggler)) && Starling.juggler.add(this._juggler);
			}
		}
		
		/**
		 * 停止框架的动画管理器
		 *
		 */
		public function stopJuggler():void
		{
			Starling.juggler.remove(juggler);
		}
		
		/**
		 * 检测尺寸重设置
		 *
		 */
		public function checkResize():void
		{
			this._SDStarling.stage.stageWidth = this.rawStage.stageWidth;
			this._SDStarling.stage.stageHeight = this.rawStage.stageHeight;
			
			const viewPort:Rectangle = this._SDStarling.viewPort;
			viewPort.width = this.rawStage.stageWidth;
			viewPort.height = this.rawStage.stageHeight;
			try
			{
				_SDStarling.viewPort = viewPort;
			}
			catch (error:Error)
			{
				debug("【ERROR SDCore-checkResize】" + error.message);
			}
		}
		
		/**
		 * 输出调试信息
		 *
		 * @param	...rest
		 */
		public function debug(... rest):void
		{
			if (rest.length > 1)
			{ //shaoxin.ji 增加日志管理
				var i:int = 0;
				var max:int = rest.length;
				while (i < max)
				{
					LogsManager.getInstance().setLog(rest[i]);
					i++;
				}
			}
			else
				LogsManager.getInstance().setLog(rest);
		}
		
		/*
		 * 获取设备信息
		 *
		 */
		public function getDeviceInfo(isPCMode:Boolean):Object
		{
			var result:Object = {};
			if (!isPCMode)
			{
				var osValue:String = "";
				osValue = Capabilities.os;
				result["OSVersion"] = osValue.substr(osValue.indexOf("OS") + 3, 5);
				
				var end:int = osValue.indexOf(",");
				result["deviceModel"] = osValue.substring(osValue.indexOf(result["OSVersion"]) + 6, end);
			}
			else
			{
				result["deviceModel"] = "win";
				result["OSVersion"] = "win";
			}
			return result;
		}
		
		/**
		 * 显示为加载中
		 *
		 */
		public function showLoading():void
		{
			this._gameApplication.setTouchable(false, "SDCore");
		}
		
		/**
		 * 显示为加载完毕
		 *
		 */
		public function removeLoading():void
		{
			this._gameApplication.setTouchable(true, "SDCore");
		}
		
		/**
		 * getter 素材管理器
		 *
		 */
		public function get assetManager():SDAssetManager
		{
			return SDAssetManager.getInstance();
		}
		
		/**
		 * getter 加载器管理器
		 * 
		 */
		public function get loaderManager():LoaderManager
		{
			return LoaderManager.getInstance();
		}
		
		/**
		 * getter starling对象
		 *
		 */
		public function get starling():Starling
		{
			return _SDStarling;
		}
		
		/**
		 * getter 帧率
		 *
		 */
		public function get frameRate():int
		{
			return _frameRate;
		}
		
		/**
		 * setter 帧率
		 *
		 */
		public function set frameRate(value:int):void
		{
			_frameRate = this.rawStage.frameRate = value;
		}
		
		/**
		 * getter 播放速度，用于加速或放慢游戏速度
		 *
		 */
		public function get playSpeed():Number
		{
			return _playSpeed;
		}
		
		/**
		 * setter 播放速度，用于加速或放慢游戏速度
		 *
		 */
		public function set playSpeed(value:Number):void
		{
			_playSpeed = value;
		}
		
		/**
		 * getter 原生舞台对象
		 *
		 */
		public function get rawStage():Stage
		{
			return _rawStage;
		}
		
		/**
		 * setter 原生舞台对象
		 *
		 */
		public function set rawStage(value:Stage):void
		{
			_rawStage = value;
		}
		
		/**
		 * getter 框架的动画控制器
		 *
		 */
		public function get juggler():SDJuggler
		{
			return _juggler;
		}
		
		/**
		 * getter 总体的水平方向坐标修正
		 *
		 */
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		/**
		 * setter 总体的水平方向坐标修正
		 *
		 */
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}
		
		/**
		 * getter 总体的竖直方向坐标修正
		 *
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		/**
		 * setter 总体的竖直方向坐标修正
		 *
		 */
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}
		
		public function get gameSound():*
		{
			return _gameSound;
		}
		
		/**
		 * getter 应用单例引用
		 *
		 */
		public function get gameApplication():IApplication
		{
			return _gameApplication;
		}
		
		/**
		 * setter 应用单例引用
		 *
		 */
		public function set gameApplication(value:IApplication):void
		{
			_gameApplication = value;
		}
		
		/**
		 * getter 是否已被激活
		 *
		 */
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		/**
		 * setter 是否已被激活
		 *
		 */
		public function set isActive(value:Boolean):void
		{
			_isActive = value;
		}
		
		/**
		 * getter starling根显示列表创建完毕的回调函数
		 *
		 */
		public function get starlingRootCreated():Function
		{
			return this._methodCenter.getCallback("starlingRootCreated");
		}
		
		/**
		 * setter starling根显示列表创建完毕的回调函数
		 *
		 */
		public function set starlingRootCreated(value:Function):void
		{
			this._methodCenter.addCallback("starlingRootCreated", value);
		}
		
		/**
		 * getter 原生舞台的尺寸重置事件处理函数回调
		 * 
		 */
		public function get rawStageResize():Function 
		{
			return this._methodCenter.getCallback("rawStageResize");
		}
		
		/**
		 * setter 原生舞台的尺寸重置事件处理函数回调
		 * 
		 */
		public function set rawStageResize(value:Function):void 
		{
			this._methodCenter.addCallback("rawStageResize", value);
		}
		
		/**
		 * setter 原生舞台的尺寸重置事件处理函数回调参数
		 * 
		 */
		public function set rawStageResizeParams(value:Array):void {
			this._methodCenter.setMehodArgs("rawStageResize", value);
		}
		
		/**
		 * setter 原生舞台失活事件处理函数回调
		 * 
		 */
		public function set rawStageDeactivate(value:Function):void {
			this._methodCenter.addCallback("rawStageDeactivate", value);
		}
		
		/**
		 * getter 原生舞台失活事件处理函数回调
		 * 
		 */
		public function get rawStageDeactivate():Function {
			return this._methodCenter.getCallback("rawStageDeactivate");
		}
		
		/**
		 * setter 原生舞台失活事件处理函数回调参数
		 * 
		 */
		public function set rawStageDeactivateParams(value:Array):void {
			this._methodCenter.setMehodArgs("rawStageDeactivate", value);
		}
		
		/**
		 * setter 原生舞台重激活事件处理函数回调
		 * 
		 */
		public function set rawStageActivate(value:Function):void {
			this._methodCenter.addCallback("rawStageActivate", value);
		}
		
		/**
		 * getter 原生舞台重激活事件处理函数回调
		 * 
		 */
		public function get rawStageActivate():Function {
			return this._methodCenter.getCallback("rawStageActivate");
		}
		
		/**
		 * setter 原生舞台重激活事件处理函数回调参数
		 * 
		 */
		public function set rawStageActivateParams(value:Array):void {
			this._methodCenter.setMehodArgs("rawStageActivate", value);
		}
	}
}

import flash.display.Sprite;

class CoreParams {
	
	public var main:Sprite;
	public var cls:Class;
	public var width:Number;
	public var height:Number;
	public var frameRate:uint;
	
	/**
	 * 启动核心单例使用的参数类
	 * 
	 * @author ch.ji
	 * 
	 * @param	m
	 * @param	a
	 * @param	w
	 * @param	h
	 * @param	f
	 */
	public function CoreParams(m:Sprite, a:Class, w:Number, h:Number, f:uint) {
		this.main = m;
		this.cls = a;
		this.width = w;
		this.height = h;
		this.frameRate = f;
	}
}