package shipDock.framework.application.manager
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.FileLoaderConfig;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.singleton.SingletonBase;
	
	/**
	 * 文件目录管理器（单例）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class FileManager extends SingletonBase
	{
		
		public static const FILE_MANAGER:String = "fileMgr";
		
		public static function getInstance():FileManager
		{
			return SingletonManager.singletonManager().getSingleton(FILE_MANAGER) as FileManager;
		}
		
		private var _appFile:File;
		private var _storageFile:File;
		private var _documentFile:File;
		private var _desktopFile:File;
		private var _userFile:File;
		private var _cacheFile:File;
		
		public function FileManager()
		{
			super(this, FILE_MANAGER);
		
		}
		
		/**
		 * 读取配置文件
		 *
		 * @param	name
		 * @param	isAppFile
		 * @return
		 */
		public function readConfigFile(name:String, isAppFile:Boolean = false):Object
		{
			var path:String = FileLoaderConfig.configFilePath + name + "." + AssetType.TYPE_JSON;
			var file:File = (isAppFile) ? this.appFile : this.storageFile;
			file = file.resolvePath(path);
			var result:Object = this.readFile(file, AssetType.TYPE_JSON);
			return result;
		}
		
		/**
		 * 读取文件
		 *
		 * @param	file
		 * @param	assetType 默认为null，此方式表示读取二进制数据
		 * @return
		 */
		public function readFile(file:*, assetType:String = null):*
		{
			var result:*;
			if (file == null)
				return;
			if (file.exists)
			{
				var fileStream:FileStream = this.openFileSteam(file, FileMode.READ);
				
				switch (assetType)
				{
					case AssetType.TYPE_JSON: //读取json格式文件数据
						var content:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
						result = JSON.parse(content);
						break;
					case AssetType.TYPE_TEXT: //读取文本格式
						result = fileStream.readUTFBytes(fileStream.bytesAvailable);
						break;
					default: //读取二进制数据
						var bytes:ByteArray = new ByteArray();
						fileStream.readBytes(bytes, 0, fileStream.bytesAvailable);
						result = bytes;
						break;
				}
				fileStream.close();
			}
			return result;
		}
		
		/**
		 * 
		 *
		 * @param	path
		 * @param	bytes
		 */
		/**
		 * 向文件写入二进制数据
		 * 
		 * @param	path
		 * @param	bytes
		 * @param	directoryFile
		 */
		public function writeBytes(path:String, bytes:ByteArray, directoryFile:File = null):void
		{
			var stream:FileStream = this.openFileSteam(path, FileMode.WRITE, directoryFile);
			stream.writeBytes(bytes);
			stream.close();
		}
		
		/**
		 * 向文件写入UTF文本数据
		 * 
		 * @param	path
		 * @param	fileContent
		 * @param	directoryFile
		 */
		public function writeUTFBytes(path:String, fileContent:String, directoryFile:File = null):void
		{
			var stream:FileStream = this.openFileSteam(path, FileMode.WRITE, directoryFile);
			stream.writeUTFBytes(fileContent);
			stream.close();
		}
		
		/**
		 * 使用特定字符集格式向文件写入文本数据
		 *
		 * @param	path
		 * @param	fileContent
		 */
		public function writeMultiBytes(path:String, fileContent:String, directoryFile:File = null, charSet:String = "iso-8859-01"):void
		{
			var stream:FileStream = this.openFileSteam(path, FileMode.WRITE, directoryFile);
			stream.writeMultiByte(fileContent, charSet);
			stream.close();
		}
		
		/**
		 * 打开一个文件流，为写入文件作准备
		 *
		 * @param	path
		 * @param	fileMode 打开文件流的模式
		 * @param	directoryFile 文件目录来源
		 * @return
		 */
		private function openFileSteam(from:*, fileMode:String, directoryFile:File = null):FileStream
		{
			var file:File = (directoryFile == null) ? this.storageFile : directoryFile; //获取文件对象
			if (from is String)
			{
				file = file.resolvePath(from);
				file = new File(file.nativePath);
			}
			else if (from is File)
			{
				file = from;
				if (file.isDirectory)
				{
					throw new Error("【X_X】Error FileManager-openFileSteam: Can't open a file steam from a directory.");
					return null;
				}
			}
			
			var result:FileStream = new FileStream(); //获取对应的文件流对象
			result.open(file, fileMode);
			return result;
		}
		
		public function get appFile():File
		{
			(!this._appFile) && (this._appFile = File.applicationDirectory);
			return _appFile;
		}
		
		public function get storageFile():File
		{
			(!this._storageFile) && (this._storageFile = File.applicationStorageDirectory);
			return _storageFile;
		}
		
		public function get documentFile():File
		{
			(!this._documentFile) && (this._documentFile = File.documentsDirectory);
			return _documentFile;
		}
		
		public function get desktopFile():File
		{
			(!this._desktopFile) && (this._desktopFile = File.desktopDirectory);
			return _desktopFile;
		}
		
		public function get userFile():File
		{
			(!this._userFile) && (this._userFile = File.userDirectory);
			return _userFile;
		}
		
		public function get cacheFile():File
		{
			(!this._cacheFile) && (this._cacheFile = File.cacheDirectory);
			return _cacheFile;
		}
	}
}