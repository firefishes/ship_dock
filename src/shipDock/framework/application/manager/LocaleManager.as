﻿package shipDock.framework.application.manager
{
	
	import flash.filesystem.File;
	import shipDock.framework.core.command.ShareObjectCommand;
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.core.manager.NoticeManager;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.interfaces.ISingleton;
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.FileLoaderConfig;
	import shipDock.framework.application.loader.LoadType;
	import shipDock.framework.core.notice.ShareObjectNotice;
	import shipDock.framework.application.singletonAgent.LocaleManagerSingleton;
	import shipDock.framework.core.utils.StringUtils;
	import starling.events.Event;
	
	import flash.utils.ByteArray;
	
	/**
	 * 本地化语言资源管理器（代理单例）
	 *
	 * @author shaoxin.ji
	 *
	 */
	public class LocaleManager extends DataLoader implements ISingleton
	{
		
		public static const LOCALE_MANAGER:String = "localeMgr";
		
		public static const E_FORMAT_HTML:String = "E_FORMAT_HTML";
		public static const E_NOT_FOUND_HTML:String = "E_NOT_FOUND_HTML";
		public static const E_BOLD_HTML:String = "E_BOLD_HTML";
		
		public static function getInstance():LocaleManager
		{
			return SingletonManager.singletonManager().getSingleton(LOCALE_MANAGER) as LocaleManager;
		}
		
		private var _languages:Object;
		private var _localeKeys:Object;
		private var _singletonAgent:LocaleManagerSingleton;
		
		public function LocaleManager()
		{
			super(null);
			
			this._singletonAgent = new LocaleManagerSingleton(this, LOCALE_MANAGER);
			
			this._languages = {};
			this._localeKeys = {};
		}
		
		public function initSingleton():void
		{
			this._singletonAgent.getInstance().initSingleton();
		}
		
		public function getInstance():ISingleton
		{
			return this._singletonAgent.getInstance();
		}
		
		override public function commit():void
		{
			this.loadType = LoadType.LOAD_TYPE_TEXT;
			
			this.url = FileLoaderConfig.localeFilePath + FileLoaderConfig.locale + "/lang.txt";
			
			var subCommand:String = ShareObjectCommand.GET_FILE_VERSION_CHECKER_SO_COMMAND;
			var notice:ShareObjectNotice = new ShareObjectNotice(subCommand, SDConfig.SOName, "localFileVersion");
			var localFileVersion:Object = NoticeManager.sendNotice(notice);
			var flag:Boolean = localFileVersion.hasOwnProperty("lang.txt");
			if (flag)
			{
				this._localeKeys[url] = FileLoaderConfig.locale;
				var fileManager:FileManager = FileManager.getInstance();
				var file:File = fileManager.storageFile.resolvePath(this.url);
				this._loadedData = fileManager.readFile(file, AssetType.TYPE_TEXT);
				
				this.loadFromData(this._loadedData, this._localeKeys[this.url]);
				return;
			}
			
			this.loadLocale(this.url, FileLoaderConfig.locale);
		}
		
		private function loadLocale(url:String, key:String = "zh_CN", complete:Function = null, progress:Function = null):void
		{
			this.complete = complete;
			this.progress = progress;
			this._localeKeys[url] = key;
			super.commit();
		}
		
		override protected function loadCompleted(event:* = null):void
		{
			super.loadCompleted(event);
			this.loadFromData(this._loadedData, this._localeKeys[this.url]);
		}
		
		/**
		 * 设置语言包
		 *
		 * @param data
		 * @param key
		 * @param isBinary
		 *
		 */
		public function loadFromData(data:*, key:String, isBinary:Boolean = false):void
		{
			var textData:String;
			if (isBinary)
				textData = String(ByteArray(data).uncompress());
			else
				textData = data;
			var line:String, indexOf:int, mKey:String /*字符的key TID_A = test，mKey is TID_A*/, rtrim:String, flag:Boolean, r:String, subText:int, index:int;
			var list:Array = [];
			var languageData:Object = {};
			var lineNum:int = -1; //总的行数
			while (index < textData.length)
			{
				if (textData.charAt(index) == "\n" || textData.charAt(index) == "\r")
				{ //找出最先有换行的位置
					if (lineNum != -1)
					{
						list[subText] = textData.substring(lineNum, index);
						subText++;
						lineNum = -1; //记录下来行号
					}
				}
				else
					(lineNum == -1) && (lineNum = index);
				index++;
			}
			if (lineNum != -1)
			{
				list[subText] = textData.substring(lineNum);
				subText++;
			}
			for each (line in list)
			{
				indexOf = line.indexOf("="); //找出=号的位置
				if (indexOf == -1)
					throw new Error("Error EUI LocaleManager-loadFromData: parsing sheet");
				mKey = StringUtils.trim(line.substring(0, indexOf), " ");
				rtrim = StringUtils.trim(line.substring(indexOf + 1), " "); //右边的
				flag = true;
				do
				{
					r = rtrim.replace("\\n", "\n");
					(r == rtrim) && (flag = false);
					rtrim = r;
				} while (flag);
				languageData[mKey] = rtrim;
			}
			this._languages[key] = languageData;
			
			this._languages[key][E_NOT_FOUND_HTML] = "<b>502 NOT FOUND</b>";
			this._languages[key][E_FORMAT_HTML] = '<font color="#{0}" size="{1}">{2}</font>';
			this._languages[key][E_BOLD_HTML] = "<b>{0}</b>";
			
			this.dispatchEventWith(Event.COMPLETE);
			this.queueNext();
		}
		
		/**
		 * 使用这个方法来做本地化配置
		 *
		 */
		public function getText(value:String, parameters:Array = null, localKey:String = null):String
		{
			var result:String = this.getLocalLanguages(value, localKey);
			(!!parameters) && (result = StringUtils.substitute(result, parameters));
			return (!!result || (result == "")) ? result : value;
		}
		
		private function getLocalLanguages(key:String, locale:String):String
		{
			(locale == null) && (locale = FileLoaderConfig.locale);
			var result:String;
			var languageData:Object = this._languages[locale];
			result = (!!languageData) ? languageData[key] : null;
			return result;
		}
		
		public function get singletonName():String
		{
			return this._singletonAgent.singletonName;
		}
		
		public function get singleRefrence():*
		{
			return this._singletonAgent.singleRefrence;
		}
	}
}