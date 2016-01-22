package shipDock.framework.core.model
{
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.FileLoaderConfig;
	
	public class SyncModel extends DataModel
	{
		
		public var size:Number;
		public var verifyID:String;
		public var localFileName:String;
		
		private var _name:String;
		private var _assetType:int;
		private var _nameSplits:Array = [];
		
		private var _fileURL:String;
		private var _filePath:String;
		
		public function SyncModel(name:String, folder:String, verifyId:String, size:Number = 0)
		{
			this._name = name;
			this._nameSplits = name.split(".");
			this.id = this._nameSplits[0];
			
			this.size = size;
			this.verifyID = verifyId;
			
			var hasSplit:Boolean = (folder.indexOf("/") != -1);
			this._assetType = AssetType.SYNC_TYPE_LIST.indexOf(this.fileTail);
			var content:String;
			switch (this.fileTail)
			{
				case AssetType.TYPE_PNG: 
				case AssetType.TYPE_JPG:
				case AssetType.TYPE_XML:
				case AssetType.TYPE_ATF:
					this.localFileName = this.id + "." + this.fileTail;
					content = (hasSplit) ? folder + name : folder + "/" + name;
					this._fileURL = FileLoaderConfig.assetHost + content;
					content = (hasSplit) ? folder + name : folder + "/" + name;
					this._filePath = FileLoaderConfig.assetFilePath + content;
					break;
				case AssetType.TYPE_JSON: 
					content = (hasSplit) ? folder + name : folder + "/" + name;
					this._fileURL = FileLoaderConfig.assetHost + content;
					content = (hasSplit) ? folder + name : folder + "/" + name;
					this._filePath = FileLoaderConfig.assetFilePath + content;
					break;
				case AssetType.TYPE_TEXT:
					content = (hasSplit) ? folder + name : folder + "/" + name;
					this._fileURL = FileLoaderConfig.assetHost + content;
					content = (hasSplit) ? folder + name : folder + "/" + name;
					this._filePath = FileLoaderConfig.assetFilePath + content;
					break;
			}
		}
		
		override public function get name():String
		{
			return this._name;
		}
		
		public function get assetType():int
		{
			return this._assetType;
		}
		
		private function get fileTail():String
		{
			return this._nameSplits[1];
		}
		
		public function get filePath():String 
		{
			return _filePath;
		}
		
		public function get fileURL():String 
		{
			return _fileURL;
		}
		
	}
}