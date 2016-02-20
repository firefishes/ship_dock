package command
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import notices.AIRFileOperationNotice;
	import notices.AIRFileReferenceLoadNotice;
	import notices.CopyFileToStorageNotice;
	
	import shipDock.framework.application.manager.FileManager;
	import shipDock.framework.core.command.Command;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.manager.ObjectPoolManager;
	
	/**
	 * 工具文件操作命令
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRFileOperationCommand extends Command
	{
		/**浏览文件目录*/
		public static const BROWSER_FILE_COMMAND:String = "browserFileCommand";
		/**选取文件目录 这个不知道有没有用*/
		public static const SELECT_FILE_COMMAND:String = "selectFileCommand";
		/**加载已浏览到的文件引用的数据*/
		public static const FILEREFERENCE_LOAD_COMMAND:String = "fileReferenceLoadCommand";
		/**将文件复制到应用程序的存储目录*/
		public static const COPY_FILE_TO_STORAGE_COMMAND:String = "copyFileToStorageCommand";
		
		private var _fileRefList:Array;
		private var _callback:Function;
		
		public function AIRFileOperationCommand()
		{
			super();
		}
		
		public function browserFileCommand(notice:AIRFileOperationNotice):FileReferenceList
		{
			var result:FileReferenceList = (!notice.fileRefList) ? ObjectPoolManager.getInstance().fromPool(FileReferenceList) : notice.fileRefList;
			result.browse(notice.fileFilters);
			result.addEventListener(Event.SELECT, notice.browserComplete);
			return result;
		}
		
		public function selectFileCommand(notice:AIRFileOperationNotice):File
		{
			var result:File = ObjectPoolManager.getInstance().fromPool(File);
			result.addEventListener(Event.SELECT, notice.browserComplete);
			result.browse(notice.fileFilters);
			return result;
		}
		
		public function fileReferenceLoadCommand(notice:AIRFileReferenceLoadNotice):void
		{
			if (notice.callback == null || !notice.fileReferences)
				return;
			this._fileRefList = [];
			this._callback = notice.callback;
			var i:int = 0;
			var list:Array = notice.fileReferences;
			var max:int = list.length;
			while (i < max)
			{
				var fileRef:FileReference = list[i];
				this._fileRefList.push(fileRef);
				fileRef.addEventListener(Event.COMPLETE, fileRefLoadComplete);
				fileRef.load();
				this.release(fileRef);
				i++;
			}
		}
		
		private function fileRefLoadComplete(event:Event):void
		{
			var fileRef:FileReference = event.target as FileReference;
			fileRef.removeEventListener(Event.COMPLETE, fileRefLoadComplete);
			(this._callback != null) && this._callback(fileRef.data);
		}
		
		private function release(fileRef:FileReference):void
		{
			var id:uint;
			var callback:Function = function release():void
			{
				(!!fileRef) && fileRef.removeEventListener(Event.COMPLETE, fileRefLoadComplete);
				
				clearTimeout(id);
				
				var index:int = _fileRefList.indexOf(fileRef);
				(index != -1) && (_fileRefList.splice(index, 1));
				
				(_fileRefList.length == 0) && purge();
			}
			id = setTimeout(callback, 30000, fileRef); //长时间没有完成加载操作强制回收
		}
		
		private function purge():void
		{
			this._fileRefList = null;
			this._callback = null;
		}
		
		public function copyFileToStorageCommand(notice:CopyFileToStorageNotice):void
		{
			var manager:FileManager = FileManager.getInstance();
			var sourceFile:File = new File();
			sourceFile = sourceFile.resolvePath(manager.appFile.nativePath + notice.sourcePath);
			var fileList:Array = sourceFile.getDirectoryListing();
			var file:File, appPath:String, sourcePath:String, targetPath:String, targetFile:File, bytes:ByteArray;
			while (fileList.length > 0)
			{
				file = fileList.shift();
				appPath = manager.appFile.nativePath;
				sourcePath = file.nativePath;
				sourcePath = sourcePath.replace(appPath, "");
				targetPath = manager.storageFile.nativePath + sourcePath;
				targetFile = new File(targetPath);
				if (notice.isCover)
					manager.writeBytes(targetPath, bytes);
				else if (!targetFile.isDirectory && !targetFile.exists)
				{
					bytes = manager.readFile(file);
					manager.writeBytes(targetPath, bytes);
				}
			}
		}
	
	}

}