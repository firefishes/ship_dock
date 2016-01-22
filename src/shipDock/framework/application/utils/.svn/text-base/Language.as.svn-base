package shipDock.framework.application.utils
{
	import flash.filesystem.File;
	import shipDock.framework.core.command.ShareObjectCommand;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	import shipDock.framework.core.manager.ShareObjectManager;
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.FileLoaderConfig;
	import shipDock.framework.application.loader.LoadType;
	import shipDock.framework.application.manager.FileManager;
	import shipDock.framework.core.manager.NoticeManager;
	import shipDock.framework.core.notice.ShareObjectNotice;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Language extends DataLoader
	{
		
		private static var instance:Language;
		
		public static function getInstance():Language
		{
			if (instance == null)
			{
				instance = new Language(new SingletonEnterForcer());
			}
			return instance;
		}
		
		private var content:Object;
		
		public function Language(enterForcer:SingletonEnterForcer)
		{
			super(null, this.loadComplete);
		}
		
		override public function commit():void
		{
			this.loadType = LoadType.LOAD_TYPE_TEXT;
			
			this.url = FileLoaderConfig.localeFilePath + FileLoaderConfig.locale + "/lang.txt";
			
			var subCommand:String = ShareObjectCommand.GET_FILE_VERSION_CHECKER_SO_COMMAND;
			var notice:ShareObjectNotice = new ShareObjectNotice(subCommand, ShareObjectManager.getInstance().SOName, "localFileVersion");
			var localFileVersion:Object = NoticeManager.sendNotice(notice);
			var flag:Boolean = localFileVersion.hasOwnProperty("lang.txt");
			if (flag)
			{
				var fileManager:FileManager = FileManager.getInstance();
				var file:File = fileManager.storageFile.resolvePath(this.url);
				var value:Object = fileManager.readFile(file, AssetType.TYPE_TEXT);
				this.loadComplete(value);
				return;
			}
			super.commit();
		}
		
		private function loadComplete(result:*):void
		{
			this.content = result;
			this.dispatchEventWith(Event.COMPLETE);
			this.dispatchEvent(new QueueExecuterEvent(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT));
		}
		
		public function trans(key:String, ... items):String
		{
			if (content == null)
			{
				content = {};
			}
			var reg:RegExp;
			var result:* = content[key] || key;
			if (result is String)
			{
				for (var i:int = 0, len:int = items.length; i < len; i++)
				{
					result = result.replace(new RegExp('\\{' + i + '\\}', 'g'), items[i]);
				}
				return result as String;
			}
			return result;
		}
	}
}

class SingletonEnterForcer
{
	public function SingletonEnterForcer()
	{
	
	}
}