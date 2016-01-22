package shipDock.framework.application.loader
{
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import shipDock.framework.application.events.FileLoaderEvent;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	import shipDock.framework.core.interfaces.IQueueExecuter;
	import shipDock.framework.application.manager.FileManager;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 基础文件加载器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class FileLoader extends EventDispatcher implements IQueueExecuter
	{
		
		private var _name:String;
		private var _url:String;
		private var _fileName:String;
		private var _dataLoader:DataLoader;
		private var _fileManager:FileManager;
		
		public function FileLoader(fileName:String, url:String = null, complete:Function = null, progress:Function = null)
		{
			super();
			
			this._fileName = fileName;
			this._fileManager = FileManager.getInstance();
			this._url = (url == null || url == "") ? (FileLoaderConfig.assetHost + this._fileName) : url;
			
			this._dataLoader = new DataLoader(url, complete, progress);
			this._dataLoader.loadType = LoadType.LOAD_TYPE_BINARY;
			
			this.addEvents();
		}
		
		private function addEvents():void
		{
			if (this._dataLoader == null)
			{
				return;
			}
			this._dataLoader.addEventListener(Event.COMPLETE, this.loadComplete);
			this._dataLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			this._dataLoader.addEventListener(ProgressEvent.PROGRESS, this.loadProgress);
		}
		
		private function removeEvents():void
		{
			if (this._dataLoader == null)
			{
				return;
			}
			this._dataLoader.removeEventListener(Event.COMPLETE, this.loadComplete);
			this._dataLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			this._dataLoader.removeEventListener(ProgressEvent.PROGRESS, this.loadProgress);
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			this.dispatchEvent(new FileLoaderEvent(FileLoaderEvent.FILE_LOADER_IO_ERROR_EVENT));
		}
		
		protected function loadComplete(event:Event):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeBytes(this._dataLoader.rawData);
			this.writeFile(this._fileName, byteArray);
			
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		protected function loadProgress(event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		private function writeFile(path:String, bytes:ByteArray):void
		{
			this._fileManager.writeBytes(path, bytes);
		}
		
		public function dispose():void
		{
			this._fileManager = null;
			if (!!this._dataLoader)
			{
				this.removeEvents();
				this._dataLoader.dispose();
				this._dataLoader = null;
			}
		}
		
		public function commit():void
		{
			this._dataLoader.commit();
		}
		
		/**
		 * 执行此对象所在队列的下一个队列元素
		 *
		 */
		public function queueNext():void
		{
			this.dispatchEventWith(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT);
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get queueSize():uint
		{
			return 1;
		}
		
		public function get eventDispatcher():EventDispatcher {
			return this as EventDispatcher;
		}
	}

}