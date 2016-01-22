package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	
	import shipDock.framework.application.manager.FileManager;
	
	/**
	 * 船工配置编辑器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	[SWF(width="960",height="640",frameRate="60",backgroundColor="0xffffff")]
	
	public class Main extends AIRApplication
	{
		/*待转换的文件列表对象引用*/
		private var _fileReferenceList:FileReferenceList;
		/*待转换的配置文件队列*/
		private var _fileList:Array;
		private var _fileLoadeds:Array;
		/*转换完成的配置数据*/
		private var _dataList:Array;
		/*配置名列表*/
		private var _configNameList:Array;
		/*当前正在操作的配置名*/
		private var _currentName:String;
		/*配置表头*/
		private var _header:Array;
		/*配置的id主键名*/
		private var _mainKey:String;
		/*转换配置的总数*/
		private var _total:uint;
		
		public function Main():void
		{
			super();
		}
		
		override protected function initSkinClass():void
		{
			this._skinClass = UISkin;
		}
		
		override protected function initSOName():void
		{
			this._soName = "shipDockConfigParser";
		}
		
		override protected function setLogText():void
		{
			this._infoText = this.infoText;
		}
		
		override protected function createUI():void
		{
			super.createUI();
			
			this.shipDockAIRScriptUp();
			
			this.pathText.text = (this._action.getSOData("lastPath") == null) ? this._action.getAIRAppConfig("default_browser_path") : this._action.getSOData("lastPath");
			this.saveText.text = (this._action.getSOData("savePath") == null) ? this._action.getAIRAppConfig("default_save_path") : this._action.getSOData("savePath");
			
			this.cmdText.text = "脚本命令待命中……";
			this.cmdText.type = TextFieldType.INPUT;
			this.cmdText.selectable = true;
			
			this.infoText.selectable = true;
			
			this._mainKey = "id";
			this.browserButton.addEventListener(MouseEvent.CLICK, this.browser);
			
			this.airAction.applyNativeDrag();
		}
		
		override protected function reloadAIRConfigSuccess():void
		{
			this.setLog("配置已重新加载...");
		}
		
		override protected function getScriptContent():String
		{
			var result:String = this.cmdText.text;
			this.cmdText.text = "";
			return result;
		}
		
		private function reset():void
		{
			this._total = 0;
			this._dataList = [];
			this._configNameList = [];
			this._fileLoadeds = [];
		}
		
		public function nativeDrag(data:Object):void
		{
			var clipboadData:Array = data["clipboadData"];
			this._fileList = [];
			for each (var file:File in clipboadData)
			{
				this._fileList.push(file);
			}
			this.loadFileList(this._fileList);
		}
		
		private function browser(event:MouseEvent):void
		{
			this._fileReferenceList = this._action.browserFile([new FileFilter("csv", "*.csv")], this.browserComplete, this._fileReferenceList);
		}
		
		private function browserComplete(event:Event):void
		{
			this._fileList = this._fileReferenceList.fileList;
			this.loadFileList(this._fileList);
		}
		
		private function loadFileList(list:Array):void
		{
			this.reset();
			(!list) && (list = this._fileList);
			var i:int = 0;
			var max:int = list.length;
			this._total = max;
			while (i < max)
			{
				var fileRef:FileReference = list[i] as FileReference;
				fileRef.addEventListener(Event.COMPLETE, fileLoaded);
				fileRef.load();
				i++;
			}
		}
		
		private function fileLoaded(e:Event):void
		{
			var fileReference:FileReference = e.currentTarget as FileReference;
			fileReference.removeEventListener(Event.COMPLETE, fileLoaded);
			
			this._fileLoadeds.push(fileReference);
			this._dataList.push(fileReference.data);
			this._configNameList.push(fileReference.name);
			
			if (this._dataList.length == this._fileList.length)
			{
				this.loadConfigData();
			}
		}
		
		private function loadConfigData():void
		{
			var data:* = this._dataList.shift();
			var file:FileReference = this._fileLoadeds.shift() as FileReference;
			this._currentName = this._configNameList.shift(); // ["name"];
			
			if (data != null)
			{
				if (data is ByteArray)
				{
					var bytes:ByteArray = data as ByteArray;
					var charSet:String = this._action.getAIRAppConfig("char_set");
					var result:String = bytes.readMultiByte(bytes.length, charSet);
					this.writeJSONFile(result, file);
				}
			}
			this._total--;
			if (this._total <= 0)
			{
				this._action.setSOData("lastPath", this.pathText.text);
				this._action.setSOData("savePath", this.saveText.text);
			}
		}
		
		private function writeJSONFile(data:String, file:FileReference):void
		{
			var result:Array = this.parse(data);
			var keyResult:Object = {};
			var n:int = 0;
			var m:int = result.length;
			while (n < m)
			{
				var id:String = result[n][this._mainKey];
				keyResult[id] = result[n];
				n++;
			}
			this.setLog("字典json: " + JSON.stringify(keyResult) + "\r");
			var JSONContent:String = JSON.stringify(keyResult);
			var fileName:String = this._currentName.replace(".csv", ".json");
			//var savePath:String = this.saveText.text + "/" + fileName;
			var nativePath:String = (file is File) ? (file as File).nativePath : "";
			nativePath = nativePath.replace(file.name, "");
			var savePath:String = nativePath + "/" + fileName;
			savePath = AIRApplicationUtils.replaceSystemPath(savePath);
			FileManager.getInstance().writeUTFBytes(savePath, JSONContent, FileManager.getInstance().appFile);
			
			this.loadConfigData();
		}
		
		private function parse(data:String):Array
		{
			var result:Array = [];
			var row:int;
			var column:int;
			var defaultValue:Array;
			var list:Array = data.split('\r');
			list.shift(); //去掉头部标识
			list.shift(); //去掉中文表头
			defaultValue = (list.shift() as String).split(","); //保存各列对应的默认值
			list.pop(); //去掉尾部标识
			row = list.length; //记录行数
			this._header = (list[0] as String).split(","); //记录各表头的id
			this._header.shift(); //去掉表头第一列，第一列不保存有效数据
			defaultValue.shift();
			column = this._header.length; //记录列数
			
			var i:int = 1;
			var j:int = 0;
			while (i < row)
			{
				var item:Object = {};
				var properties:Object = {};
				var source:Array = (list[i] as String).split(","); //获取一行数据
				source.shift(); //去掉第一列，第一列不保存有效数据
				j = 0;
				while (j < column)
				{ //开始填充每列对应的表头属性
					var key:String = _header[j];
					if (j == 0 && this._mainKey == null)
					{
						this._mainKey = key;
					}
					if (source[j] == '')
					{
						source[j] = defaultValue[j]; //若没有值则设置为默认值
					}
					if (key != "")
					{
						if ((source[j] == "true") || (source[j] == "TRUE"))
						{
							source[j] = true;
						}
						if ((source[j] == "false") || (source[j] == "FALSE"))
						{
							source[j] = false;
						}
						item[key] = source[j];
					}
					else
					{
						if (source[j] != '')
						{
							while (j < column)
							{
								properties[source[j]] = source[j + 1];
								j += 2;
							}
							item["properties"] = properties;
						}
						j++;
						continue;
					}
					j++;
				}
				if (!item.hasOwnProperty("name"))
				{
					item["name"] = "NAME_" + (item["id"] as String).toLocaleUpperCase();
				}
				if (!item.hasOwnProperty("decs"))
				{
					item["decs"] = "DECS_" + (item["id"] as String).toLocaleUpperCase();
				}
				result.push(item);
				i++;
			}
			return result;
		}
		
		private function get browserButton():MovieClip
		{
			return this.getMovieClip("browserBtn");
		}
		
		private function get saveText():TextField
		{
			return this.getTextField("saveText");
		}
		
		private function get pathText():TextField
		{
			return this.getTextField("pathText");
		}
		
		private function get infoText():TextField
		{
			return this.getTextField("infoText");
		}
		
		private function get cmdText():TextField
		{
			return this.getTextField("cmdText");
		}
	}

}