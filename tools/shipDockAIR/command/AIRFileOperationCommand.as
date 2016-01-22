package command
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import notices.AIRFileOperationNotice;
	import notices.AIRFileReferenceLoadNotice;
	
	import shipDock.framework.core.command.Command;
	import shipDock.framework.core.manager.ObjectPoolManager;
	
	/**
	 * 工具文件操作命令
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRFileOperationCommand extends Command
	{
		
		public static const BROWSER_FILE_COMMAND:String = "browserFileCommand";
		public static const SELECT_FILE_COMMAND:String = "selectFileCommand";
		public static const FILEREFERENCE_LOAD_COMMAND:String = "fileReferenceLoadCommand";
		
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
		
		public function fileReferenceLoadCommand(notice:AIRFileReferenceLoadNotice):void {
			if(notice.callback == null || !notice.fileReferences)
				return;
			this._fileRefList = [];
			this._callback = notice.callback;
			var i:int = 0;
			var list:Array = notice.fileReferences;
			var max:int = list.length;
			while(i < max) {
				var fileRef:FileReference = list[i];
				this._fileRefList.push(fileRef);
				fileRef.addEventListener(Event.COMPLETE, fileRefLoadComplete);
				fileRef.load();
				this.release(fileRef);
				i++;
			}
		}
		
		private function fileRefLoadComplete(event:Event):void {
			var fileRef:FileReference = event.target as FileReference;
			fileRef.removeEventListener(Event.COMPLETE, fileRefLoadComplete);
			(this._callback != null) && this._callback(fileRef.data);
		}
		
		private function release(fileRef:FileReference):void {
			var id:uint;
			var callback:Function = function release():void {
				(!!fileRef) && fileRef.removeEventListener(Event.COMPLETE, fileRefLoadComplete);
				
				clearTimeout(id);
				
				var index:int = _fileRefList.indexOf(fileRef);
				(index != -1) && (_fileRefList.splice(index, 1));
				
				(_fileRefList.length == 0) && purge();
			}
			id = setTimeout(callback, 30000, fileRef);//长时间没有完成加载操作强制回收
		}
		
		private function purge():void {
			this._fileRefList = null;
			this._callback = null;
		}
	
	}

}