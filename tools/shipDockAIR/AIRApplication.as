package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;
	
	import action.AIRMainAction;
	
	import shipDock.framework.application.manager.ApplicationDomainManager;
	import shipDock.framework.application.manager.FileManager;
	import shipDock.framework.application.utils.DisplayUtils;
	import shipDock.framework.core.SDFramework;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.ShareObjectManager;
	
	/**
	 * 工具应用主类的基类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRApplication extends Sprite
	{
		
		protected var _soName:String;
		protected var _skinClass:Class;
		protected var _actionClass:Class;
		protected var _skin:DisplayObjectContainer;
		protected var _action:AIRMainAction;
		protected var _infoText:TextField;
		
		private var _logsCount:int = 0;
		
		public function AIRApplication(applyNotice:Boolean = true, applyCommand:Boolean = true, applySOManager:Boolean = true):void
		{
			var framework:SDFramework = new SDFramework(this.framworkStartUp, applyNotice, applyCommand, applySOManager);
			this.initSkinClass();
			if (this.stage == null)
				this.addEventListener(Event.ADDED_TO_STAGE, this.initApplication);
			else
				this.initApplication();
		}
		
		private function framworkStartUp():void
		{
			new FileManager();
			new ApplicationDomainManager();
		}
		
		protected function initSkinClass():void
		{
			this._skinClass = null;
		}
		
		protected function initActionClass():void
		{
			this._actionClass = AIRMainAction;
		}
		
		protected function initSOName():void
		{
			this._soName = null;
		}
		
		protected function shipDockAIRScriptUp(type:int = 0):void {
			if(type == 0) {
				(this.stage) && this.stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
			}
		}
		
		private function keyboardHandler(event:KeyboardEvent):void {
			var keyCode:Number = event.keyCode;
			if(keyCode == Keyboard.ENTER) {
				this.parseScript();
			}
		}
		
		protected function parseScript():void {
			(this._action) && this._action.parseScript(this.getScriptContent());
		}
		
		/**
		 * 覆盖此方法，返回脚本命令值
		 *  
		 * @return 
		 * 
		 */		
		protected function getScriptContent():String {
			return "";
		}
		
		protected function getSkinElement(name:String):*
		{
			return DisplayUtils.getChildByPath(this._skin, name);
		}
		
		protected function getMovieClip(name:String):MovieClip
		{
			return this.getSkinElement(name) as MovieClip;
		}
		
		protected function getTextField(name:String):TextField
		{
			return this.getSkinElement(name) as TextField;
		}
		
		protected function setLog(text:String):void
		{
			(LogsManager.text == null) && (LogsManager.text = this._infoText);
			LogsManager.getInstance().setLog(text);
			
			//设置显示输出信息的文本
			if (this._logsCount > 50)
			{
				this._logsCount = 0;
				(this._infoText != null) && (this._infoText.text = "");
			}
			this._logsCount++;
			if (this._infoText != null)
			{
				this._infoText.appendText(text + "\r\n");
				this._infoText.scrollV = this._infoText.bottomScrollV;
			}
		}
		
		protected function clearLogs():void {
			LogsManager.getInstance().clear();
		}
		
		protected function initApplication(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.initApplication);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.initActionClass();
			this._action = new _actionClass();
			this._action.setProxyed(this);
			
			this._action.loadAIRConfig(this.createUI);
		}
		
		protected function reloadAIRConfigSuccess():void {
			
		}
		
		protected function createUI():void
		{
			
			if (this._skinClass == null)
			{
				var skinClsName:String = this._action.getAIRAppConfig("air_app.skin_class");
				this._skinClass = ApplicationDomainManager.getInstance().getDefined(skinClsName) as Class;
			}
			(this._soName == null) && (this._soName = this._action.getAIRAppConfig("air_app.so_name"));
			ShareObjectManager.getInstance().SOName = this._soName;
			
			this._skin = new this._skinClass() as DisplayObjectContainer;
			
			this.setLogText();
			
//			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
//			var version:XMLList = appXml.child("versionNumber");
//			this.setLog(this._id + " version " + appXml[2]);
			this.setLog(this._action.id + " start. Welcome!");
			
			this.addChild(this._skin);
		}
		
		public function airConfigLoadError(params:*):void {
			
			this.graphics.beginFill(0xFFFFFF * Math.random());
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
			
			setInterval(this.airConfigLoadError, 1500, null);
		}
		
		protected function setLogText():void
		{
		}
		
		protected function get airAction():AIRMainAction
		{
			return this._action;
		}
	
	}

}