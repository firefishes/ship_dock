package action 
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.events.NativeDragEvent;
	import flash.net.FileReferenceList;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import shipDock.framework.core.notice.InvokeProxyedNotice;
	import starling.events.EventDispatcher;
	
	import command.AIRCommand;
	import command.AIRFileOperationCommand;
	import command.ShipDockAIRScriptCommand;
	
	import notices.AIRFileOperationNotice;
	import notices.AIRFileReferenceLoadNotice;
	import notices.AIRNoticeName;
	import notices.SDAScriptNotice;
	
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.DisplayAssetLoader;
	import shipDock.framework.application.manager.FileManager;
	import shipDock.framework.core.action.SDAction;
	import shipDock.framework.core.command.ShareObjectCommand;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.manager.ShareObjectManager;
	import shipDock.framework.core.methodExecuter.MethodCenter;
	import shipDock.framework.core.notice.ShareObjectNotice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRMainAction extends SDAction implements IAction
	{
		private var _id:String;
		private var _isLoadSkin:Boolean;
		private var _airAppConfig:Object;
		private var _fileManager:FileManager;
		private var _methodCenter:MethodCenter;
		private var _airConfigLoader:DataLoader;
		private var _shareObjectNotice:ShareObjectNotice;
		private var _fileOperationNotice:AIRFileOperationNotice;
		private var _fileReferenceLoadNotice:AIRFileReferenceLoadNotice;
		
		public function AIRMainAction() 
		{
			super();
			this._methodCenter = new MethodCenter();
			this._fileManager = FileManager.getInstance();
		}
		
		override protected function setCommand():void 
		{
			super.setCommand();
			
			this.registered(AIRNoticeName.SHIP_DOCK_AIR, AIRCommand);
			this.registered(AIRNoticeName.AIR_FILE_OPERATION, AIRFileOperationCommand);
			this.registered(AIRNoticeName.SDA_SCRIPT, ShipDockAIRScriptCommand);
		}
		
		private function createApplication(result:* = null):void {
			if(this._isLoadSkin) {
				this._methodCenter.useCallback("create");
			}
			this._methodCenter.useCallback("reloadConfig", null, null, true);
			this._isLoadSkin = false;
		}
		
		public function loadAIRConfig(callback:Function, isInit:Boolean = true):void {
			if(isInit) {
				this._isLoadSkin = true;
				this._methodCenter.addCallback("create", callback);
			}else {
				this._methodCenter.addCallback("reloadConfig", callback);
			}
			this._airConfigLoader = ObjectPoolManager.getInstance().fromPool(DataLoader, null);
			this._airConfigLoader.setSDLoaderInfo("airConfig.json", this.airConfigLoadComplete);
			this._airConfigLoader.commit();
		}
		
		public function airConfigLoadComplete(result:Object):void
		{
			ObjectPoolManager.getInstance().toPool(this._airConfigLoader);
			this._airConfigLoader = null;
			this.updateAppConfig(result);
		}
		
		private function updateAppConfig(result:Object):void {
			this._airAppConfig = result;
			this._id = this.getAIRAppConfig("air_app.id");
			var restart:Function = this._methodCenter.getCallback("reloadConfig");
			var path:String = this.getAIRAppConfig("air_app.skin_swf");
			if(path && this._isLoadSkin) {
				var assetLoader:DisplayAssetLoader = new DisplayAssetLoader(path, this.createApplication);
				assetLoader.isAutoDispose = true;
				assetLoader.loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				assetLoader.load();
			}else {
				this.createApplication();
			}
		}
		
		public function applyNativeDrag(target:* = null):void {
			(!target) && (target = this.proxyed);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, this.nativeDragEnterHandler);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, this.nativeDragDropHandler);
		}
		
		private function nativeDragEnterHandler(event:NativeDragEvent):void {
			if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				NativeDragManager.acceptDragDrop(event.target as InteractiveObject);
			}
		}
		
		private function nativeDragDropHandler(event:NativeDragEvent):void {
			var airData:Object = event.clipboard.formats;//读取剪切板
			var type:String;
			for each(type in airData) {
				if (type == ClipboardFormats.FILE_LIST_FORMAT) {
					var airObjects:Array = event.clipboard.getData(type) as Array;//获取剪切板中的数据
					this.invokeProxyed(new InvokeProxyedNotice("nativeDrag", {"clipboadData":airObjects}));
					//var inFile:File=airObjects[0]as File;//获取剪切板中的文件
					
					
					/*if (type != "air:url") {
						var airObjects:Array = event.clipboard.getData(type) as Array;//获取剪切板中的数据
						var inFile:File=airObjects[0]as File;//获取剪切板中的文件
						var fileInStream:FileStream=new FileStream();//文件流
						var contentArray:ByteArray=new ByteArray();
						fileInStream.open(inFile, FileMode.READ);
						fileInStream.readBytes(contentArray);//读取字节保存到contentArray
						picture.source=contentArray;
						savePictureObject(inFile.name, contentArray);//保存到数据库
					}*/
				}
			}
		}
		
		public function restart(isReloadSkin:Boolean, restarted:Function = null):void {
			this._isLoadSkin = isReloadSkin;
			this.loadAIRConfig(restarted, false);
		}
		
		public function getAIRAppConfig(key:String):*
		{
			if (this._airAppConfig == null)
				return null;
			var list:Array = key.split(".");
			var result:* = this._airAppConfig;
			while (list.length > 0)
			{
				var k:String = list.shift();
				if (result[k] != null)
					result = result[k];
				else
					break;
			}
			((result == "") || (result == this._airAppConfig)) && (result = null);
			((result != null) && (result is String) && (this._id != null)) && (result = result.replace(new RegExp("\\[id\\]", "g"), this._id));
			return result;
		}
		
		public function parseScript(scriptText:String):void {
			var notice:SDAScriptNotice = new SDAScriptNotice({"s":scriptText});
			notice.subCommand = ShipDockAIRScriptCommand.SDA_SCRIPT_NORMAL_COMMAND;
			this.sendNotice(notice);
		}
		
		public function getAIRConfig(key:String):* {
			return this.getAIRAppConfig(key);
		}
		
		public function getSOData(keyField:String):* {
			var soName:String = ShareObjectManager.getInstance().SOName;
			var data:Object = this.shareObjectNotice.sendSelf(this, ShareObjectCommand.GET_SO_COMMAND, [soName]);
			return data[keyField];
		}
		
		public function setSOData(keyField:String, value:*):void {
			if (keyField == null)
				return;
			var soName:String = ShareObjectManager.getInstance().SOName;
			this.shareObjectNotice.sendSelf(this, ShareObjectCommand.FLUSH_SO_COMMAND, [soName, keyField, value]);
		}
		
		public function browserFile(fileFilters:Array, browserComplete:Function = null, fileRefList:FileReferenceList = null):FileReferenceList {
			var args:Array = [fileFilters, browserComplete, fileRefList];
			return this.fileOperationNotice.sendSelf(this, AIRFileOperationCommand.BROWSER_FILE_COMMAND, args);
		}
		
		public function selectMultFile(fileFilters:Array, browserComplete:Function = null):void {
			var args:Array = [fileFilters, browserComplete];
			this.fileOperationNotice.sendSelf(this, AIRFileOperationCommand.SELECT_FILE_COMMAND, args);
		}
		
		public function fileReferenceLoad(list:Array, callback:Function, isApplyData:Boolean = true):void {
			this.fileReferenceLoadNotice.sendSelf(this, null, [list, callback, isApplyData]);
		}
		
		public function openWithDefaultApplication(notice:*):void {
			
		}
		
		public function get shareObjectNotice():ShareObjectNotice 
		{
			(!this._shareObjectNotice) && (this._shareObjectNotice = new ShareObjectNotice(null, null, null));
			return _shareObjectNotice;
		}
		
		public function get fileOperationNotice():AIRFileOperationNotice 
		{
			(this._fileOperationNotice == null) && (this._fileOperationNotice = new AIRFileOperationNotice(null));
			return _fileOperationNotice;
		}
		
		public function get fileReferenceLoadNotice():AIRFileReferenceLoadNotice 
		{
			(this._fileReferenceLoadNotice == null) && (this._fileReferenceLoadNotice = new AIRFileReferenceLoadNotice(null, null));
			return _fileReferenceLoadNotice;
		}
		
		public function get fileManager():FileManager 
		{
			return _fileManager;
		}

		public function get id():String
		{
			return _id;
		}

	}

}