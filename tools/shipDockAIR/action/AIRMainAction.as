package action
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.DisplayObject;
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
	 * AIR应用主逻辑代理基类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRMainAction extends SDAction implements IAction
	{
		/**应用id*/
		private var _id:String;
		/**是否已加载皮肤*/
		private var _isLoadSkin:Boolean;
		/**AIR应用的配置*/
		private var _airAppConfig:Object;
		/**文件管理器*/
		private var _fileManager:FileManager;
		/**方法回调中心*/
		private var _methodCenter:MethodCenter;
		/**AIR应用配置加载器*/
		private var _airConfigLoader:DataLoader;
		/**本地共享数据消息对象的引用*/
		private var _shareObjectNotice:ShareObjectNotice;
		/**文件操作消息对象的引用*/
		private var _fileOperationNotice:AIRFileOperationNotice;
		/**文件列表加载消息对象的引用*/
		private var _fileReferenceLoadNotice:AIRFileReferenceLoadNotice;
		
		public function AIRMainAction(startUpClass:Class = null)
		{
			super(startUpClass);
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
		
		/**
		 * 创建应用
		 *
		 * @param	result
		 */
		private function createApplication(result:* = null):void
		{
			if (this._isLoadSkin)
			{
				this._methodCenter.useCallback("create");
			}
			this._methodCenter.useCallback("reloadConfig", null, null, true);
			this._isLoadSkin = false;
		}
		
		/**
		 * 加载AIR应用配置
		 *
		 * @param	callback
		 * @param	isInit
		 */
		public function loadAIRConfig(callback:Function, isInit:Boolean = true):void
		{
			if (isInit)
			{
				this._isLoadSkin = true;
				this._methodCenter.addCallback("create", callback);
			}
			else
			{
				this._methodCenter.addCallback("reloadConfig", callback);
			}
			this._airConfigLoader = ObjectPoolManager.getInstance().fromPool(DataLoader, null);
			this._airConfigLoader.setSDLoaderInfo("airConfig.json", this.airConfigLoadComplete);
			this._airConfigLoader.loadError = this.airConfigLoadError;
			this._airConfigLoader.commit();
		}
		
		/**
		 * AIR应用配置加载完毕
		 *
		 * @param	result
		 */
		public function airConfigLoadComplete(result:Object):void
		{
			ObjectPoolManager.getInstance().toPool(this._airConfigLoader);
			this._airConfigLoader = null;
			this.updateAppConfig(result);
		}
		
		/**
		 * AIR应用配置加载出错
		 *
		 */
		protected function airConfigLoadError():void
		{
			this.sendNotice(new InvokeProxyedNotice("airConfigLoadError"));
		}
		
		/**
		 * 更新应用配置
		 *
		 * @param	result
		 */
		private function updateAppConfig(result:Object):void
		{
			this._airAppConfig = result;
			this._id = this.getAIRAppConfig("air_app.id");
			var restart:Function = this._methodCenter.getCallback("reloadConfig");
			var path:String = this.getAIRAppConfig("air_app.skin_swf");
			if (path && this._isLoadSkin)
			{
				var assetLoader:DisplayAssetLoader = new DisplayAssetLoader(path, this.createApplication);
				assetLoader.isAutoDispose = true;
				assetLoader.loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				assetLoader.load();
			}
			else
			{
				this.createApplication();
			}
		}
		
		/**
		 * 开启本地系统的文件拖拽交互功能
		 *
		 * @param	target
		 */
		public function applyNativeDrag(target:* = null):void
		{
			(!target) && (target = this.proxyed);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, this.nativeDragEnterHandler);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, this.nativeDragDropHandler);
		}
		
		/**
		 * 本地系统的文件开始拖拽
		 *
		 */
		private function nativeDragEnterHandler(event:NativeDragEvent):void
		{
			/*if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{*/
				NativeDragManager.acceptDragDrop(event.target as InteractiveObject);
			/*}*/
		}
		
		/**
		 * 本地系统的文件在应用程序上释放
		 *
		 */
		private function nativeDragDropHandler(event:NativeDragEvent):void
		{
			var airData:Object = event.clipboard.formats; //读取剪切板
			var type:String, typeKey:String;
			for each (type in airData)
			{
				if (type == ClipboardFormats.FILE_LIST_FORMAT)
				{
					typeKey = "File";//文件数据
				}
				else if (type == ClipboardFormats.BITMAP_FORMAT)
				{
					typeKey = "BMP";//图片数据
				}
				else if (type == ClipboardFormats.HTML_FORMAT)
				{
					typeKey = "HTML";//HTML数据
				}
				else if (type == ClipboardFormats.RICH_TEXT_FORMAT)
				{
					typeKey = "RTF";//富文本数据
				}
				else if (type == ClipboardFormats.TEXT_FORMAT)
				{
					typeKey = "Text";//字符串数据
				}
				else if (type == ClipboardFormats.URL_FORMAT)
				{
					typeKey = "URL";//URL链接数据
				}
				var airObjects:Array = event.clipboard.getData(type) as Array; //获取剪切板中的数据
				this.invokeProxyed(new InvokeProxyedNotice("nativeDragFor" + typeKey, new NativeDragParams(airObjects)));
			}
		}
		
		/**
		 * 应用程序重启
		 *
		 */
		public function restart(isReloadSkin:Boolean, restarted:Function = null):void
		{
			this._isLoadSkin = isReloadSkin;
			this.loadAIRConfig(restarted, false);
		}
		
		/**
		 * 获取AIR应用程序配置中的值，支持获取嵌套的值
		 *
		 * @param	key "a.b.c.value"
		 * @return
		 */
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
		
		/**
		 * 分析应用程序脚本
		 *
		 * @param	scriptText
		 */
		public function parseScript(scriptText:String):void
		{
			var notice:SDAScriptNotice = new SDAScriptNotice({"s": scriptText});
			notice.subCommand = ShipDockAIRScriptCommand.SDA_SCRIPT_NORMAL_COMMAND;
			this.sendNotice(notice);
		}
		
		/**
		 * 获取本地共享数据的值
		 *
		 */
		public function getSOData(keyField:String):*
		{
			var soName:String = ShareObjectManager.getInstance().SOName;
			var data:Object = this.shareObjectNotice.sendSelf(this, ShareObjectCommand.GET_SO_COMMAND, [soName]);
			return data[keyField];
		}
		
		/**
		 * 设置本地共享数据的值
		 *
		 * @param	keyField
		 * @param	value
		 */
		public function setSOData(keyField:String, value:*):void
		{
			if (keyField == null)
				return;
			var soName:String = ShareObjectManager.getInstance().SOName;
			this.shareObjectNotice.sendSelf(this, ShareObjectCommand.FLUSH_SO_COMMAND, [soName, keyField, value]);
		}
		
		/**
		 * 浏览本地文件
		 *
		 * @param	keyField
		 * @param	value
		 */
		public function browserFile(fileFilters:Array, browserComplete:Function = null, fileRefList:FileReferenceList = null):FileReferenceList
		{
			var args:Array = [fileFilters, browserComplete, fileRefList];
			return this.fileOperationNotice.sendSelf(this, AIRFileOperationCommand.BROWSER_FILE_COMMAND, args);
		}
		
		/**
		 * 选择多个文件
		 *
		 * @param	fileFilters
		 * @param	browserComplete
		 */ /*public function selectMultFile(fileFilters:Array, browserComplete:Function = null):void {
		   var args:Array = [fileFilters, browserComplete];
		   this.fileOperationNotice.sendSelf(this, AIRFileOperationCommand.SELECT_FILE_COMMAND, args);
		 }*/
		
		/**
		 * 文件浏览列表加载完毕
		 *
		 * @param	list
		 * @param	callback
		 * @param	isApplyData
		 */
		public function fileReferenceLoad(list:Array, callback:Function, isApplyData:Boolean = true):void
		{
			this.fileReferenceLoadNotice.sendSelf(this, null, [list, callback, isApplyData]);
		}
		
		public function openWithDefaultApplication(notice:*):void
		{
		
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