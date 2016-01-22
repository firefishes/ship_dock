package shipDock.framework.application.loader
{
	import flash.events.ProgressEvent;
	
	import shipDock.framework.application.events.FileLoaderEvent;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	import shipDock.framework.core.utils.SDUtils;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 文件同步加载器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class FileSyncer extends Syncer
	{
		
		public function FileSyncer(waitingList:Array, assetType:String, complete:Function = null, progress:Function = null)
		{
			super(waitingList, assetType, complete, progress);
		
		}
		
		/**
		 * 检测文件版本
		 *
		 */
		public function checkFileVersion():void
		{
			var list:Array = [];
			SDUtils.wLoop(0, this.waitingList.length, this.checkFileItem);
		}
		
		/**
		 * 检测一个文件版本
		 *
		 * @param	index
		 */
		private function checkFileItem(index:int):void
		{
			var item:* = this.waitingList[index];
			var flag:Boolean = this.checkIsNeedLoad(item);
			if (!flag)
			{
				item = null;
			}
			this.waitingList[index] = item;
		}
		
		protected function checkIsNeedLoad(item:*):Boolean
		{
			return true;
		}
		
		/**
		 * 开始同步文件
		 *
		 */
		override public function commit():void
		{
			super.commit();
			this.checkFileVersion();
			SDUtils.wLoop(0, this.waitingList.length, this.loadFile);
			this._queue.start();
			LogsManager.getInstance().setLog("【FILE SYNCER】 Sync queue start. size is " + this._waitingList.length);
		}
		
		/**
		 * 按顺序添加需要同步的文件
		 *
		 * @param	index
		 */
		protected function loadFile(index:int):void
		{
			if (this.waitingList[index] == null)
			{
				return;
			}
			var url:String = this.getFileURL(index);
			var fileName:String = this.getFilePath(index);
			var fileLoader:FileLoader = new FileLoader(fileName, url);
			fileLoader.name = this.getFileLoaderName(index);
			fileLoader.addEventListener(Event.COMPLETE, this.loadComplete);
			fileLoader.addEventListener(FileLoaderEvent.FILE_LOADER_IO_ERROR_EVENT, this.ioErrorHandler);
			fileLoader.addEventListener(ProgressEvent.PROGRESS, this.loadProgress);
			this._queue.add(fileLoader);
		}
		
		protected function ioErrorHandler(event:FileLoaderEvent):void
		{
			var target:DataLoader = event.target as DataLoader;
			LogsManager.getInstance().setLog("【FILE SYNCER】 file loader io error. Url is : " + target.url);
		}
		
		override protected function loadComplete(event:Event):void
		{
			super.loadComplete(event);
			var target:FileLoader = event.target as FileLoader;
			this.disposeFileLoader(target);
		}
		
		protected function disposeFileLoader(target:FileLoader):void
		{
			if (target == null)
			{
				return;
			}
			target.dispatchEvent(new QueueExecuterEvent(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT)); //通知同步素材的队列执行下一个队列单元
			
			target.removeEventListener(Event.COMPLETE, this.loadComplete);
			target.removeEventListener(FileLoaderEvent.FILE_LOADER_IO_ERROR_EVENT, this.ioErrorHandler);
			target.removeEventListener(ProgressEvent.PROGRESS, this.loadProgress);
			
			target.dispose();
		}
		
		protected function getFilePath(index:int):String
		{
			return this.waitingList[index];
		}
		
		protected function getFileURL(index:int):String
		{
			return null;
		}
		
		protected function getFileLoaderName(index:int):String
		{
			return null;
		}
	}

}