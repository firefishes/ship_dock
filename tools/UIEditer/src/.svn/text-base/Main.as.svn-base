package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.DisplayAssetLoader;
	import shipDock.framework.application.loader.LoadType;
	
	/**
	 * UI界面导出工具主类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class Main extends AIRApplication
	{
		/*静态文本UI，可以合并为一个文本批次进行渲染，元件名前缀：stxt_*/
		public static const VIEW_UI_TYPE_TEXT:int = 0;
		
		/*图片UI，元件名前缀：img_*/
		public static const VIEW_UI_TYPE_IMAGE:int = 1;
		
		/*动画UI，元件名前缀：ani_*/
		public static const VIEW_UI_TYPE_MOVIE:int = 2;
		
		/*按钮UI，元件名前缀：btn_*/
		public static const VIEW_UI_TYPE_BUTTON:int = 3;
		
		/*四边形UI，元件名前缀：quad_*/
		public static const VIEW_UI_TYPE_QUAD:int = 4;
		
		/*容器UI，元件名前缀：null_或c_*/
		public static const VIEW_UI_TYPE_CONTAINER:int = 5;
		
		/*动态文本UI，元件名前缀：txt_*/
		public static const VIEW_UI_TYPE_DYNAMIC_TEXT:int = 6;
		
		/*swf加载器*/
		private var _loader:DisplayAssetLoader;
		/*数据加载器*/
		private var _dataLoader:DataLoader;
		/*需要加载的配置列表*/
		private var _configList:Array;
		/*当前处理的文件名*/
		private var _currentName:String;
		/*正在处理的文件目录列表*/
		private var _fileList:FileReferenceList;
		/*已加载的数据*/
		private var _dataList:Array = [];
		/*正在处理的文件目录列表中的当前文件目录*/
		private var _currentFileRef:FileReference;
		/*纹理xml配置集合*/
		private var _xmlPools:Object = {};
		/*需要独立一个层的UI类别*/
		private var _oneBatchs:Array = [VIEW_UI_TYPE_QUAD, VIEW_UI_TYPE_CONTAINER];
		/*纹理配置路径*/
		private var _xmlPath:String;
		
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
			this._soName = "shipDockUIParser";
		}
		
		override protected function createUI():void
		{
			super.createUI();
			
			var lastPath:String = this._action.getSOData("lastPath");
			(lastPath == null) && (lastPath = this.getToolAppConfig("default_export_path"));
			this.exportText.text = lastPath;
			
			this._xmlPath = this._action.getSOData("xmlPath");
			(this._xmlPath == null) && (this._xmlPath = this.getToolAppConfig("default_texture_xml_path"));
			if (this._xmlPath != null)
			{
				this.xmlPathText.text = this._xmlPath;
			}
			else
			{
				this.xmlPathText.text = "";
			}
			if (this.xmlPathText.text == "")
			{
				this._xmlPath = "";
				this.xmlPathText.text = "请填写项目里纹理XML的路径";
			}
			
			this.loadButton.addEventListener(MouseEvent.CLICK, this.parseUIByConfig);
			this.browserButton.addEventListener(MouseEvent.CLICK, this.parseByFileBrowser);
		}
		
		override protected function setLogText():void
		{
			this._infoText = this.getTextField("infoText");
		}
		
		private function parseUIByConfig(event:MouseEvent):void
		{
			var path:String = this.getToolAppConfig("default_load_path");
			this._dataLoader = new DataLoader(path, this.configComplete);
			this._dataLoader.commit();
		}
		
		private function configComplete(result:*):void
		{
			var data:Array = result as Array;
			var i:int = 0;
			var max:int = data.length;
			
			this.initData();
			while (i < max)
			{
				this._dataList.push(data[i]["name"]);
				this._configList.push(data[i]["name"]);
				i++;
			}
			this.loadSWF();
			this._dataLoader.dispose();
		}
		
		private function parseByFileBrowser(event:MouseEvent):void
		{
			this._fileList = this._action.browserFile([new FileFilter("swfs", "*.swf")], this.browserComplete);
		}
		
		private function initData():void
		{
			this._dataList = [];
			this._configList = [];
			this._xmlPools = {};
		}
		
		private function browserComplete(event:Event):void
		{
			this._infoText.text = "";
			this.initData();
			var i:int = 0;
			while (i < this._fileList.fileList.length)
			{
				var fileRef:FileReference = this._fileList.fileList[i];
				fileRef.addEventListener(Event.COMPLETE, fileLoaded);
				fileRef.load();
				i++;
			}
		}
		
		private function fileLoaded(e:Event):void
		{
			this._currentFileRef = e.currentTarget as FileReference;
			this._currentFileRef.removeEventListener(Event.COMPLETE, fileLoaded);
			this._dataList.push(this._currentFileRef.data);
			this._configList.push(this._currentFileRef.name);
			
			if (this._dataList.length == this._fileList.fileList.length)
			{
				this.setLog("需要解析的配置名列表为：\r");
				var list:Array = [];
				var i:int = 0;
				var max:int = this._configList.length;
				var text:String = "";
				while (i < max)
				{
					this.setLog(this._configList[i] + "\r\n");
					i++;
				}
				this.setLog("开始生成配置\r");
				this.loadXML();
			}
			this._action.setSOData("lastPath", this.exportText.text);
		}
		
		private function loadXML():void
		{
			this.xmlPathText.text = ToolApplicationUtils.replaceSystemPath(this.xmlPathText.text);
			this._xmlPath = this.xmlPathText.text;
			this._action.setSOData("xmlPath", this._xmlPath);
			var file:File = this._action.fileManager.storageFile.resolvePath(this._xmlPath);
			file = new File(file.nativePath);
			if (!file.exists)
				file.createDirectory();
			var list:Array = file.getDirectoryListing();
			for each (var f:File in list)
			{
				var fileContent:* = this._action.fileManager.readFile(f, AssetType.TYPE_TEXT);
				var xml:XML = XML(fileContent);
				var key:String = xml.@imagePath;
				for each (var k:*in xml.children())
				{
					var kk:String = k.@name;
					if (!this._xmlPools.hasOwnProperty(kk))
					{
						this._xmlPools[kk] = key;
					}
					else
					{
						//纹理里有重名！
					}
				}
			}
			this.loadSWF();
		}
		
		private function loadSWF():void
		{
			if (_loader == null)
			{
				_loader = new DisplayAssetLoader(null, this.loadSWFComplete);
			}
			var data:* = this._dataList.shift();
			this._currentName = this._configList.shift(); // ["name"];
			
			if (data != null)
			{
				if (data is ByteArray)
				{
					var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
					lc.allowCodeImport = true;
					_loader.loadType = LoadType.LOAD_TYPE_BINARY;
					_loader.loaderContext = lc;
					_loader.bytesSource = data;
					
				}
				else if (data is String)
				{
					_loader.loadType = LoadType.LOAD_TYPE_WEB_ASSET;
					_loader.url = "assets/" + this._currentName + ".swf";
				}
				_loader.commit();
			}
			else
			{
				this.setLog("恭喜主人！所有的界面配置生成完毕!");
			}
		}
		
		private function loadSWFComplete(result:*):void
		{
			var content:DisplayObjectContainer = result as DisplayObjectContainer; // (event.currentTarget as LoaderInfo).content as DisplayObjectContainer;
			var i:int = 0;
			var max:int = content.numChildren;
			var result:Object = {"view": []};
			var viewData:Array = result["view"];
			var isError:Boolean;
			var layerName:String;
			var layerNames:Object = {};
			var layers:Array = [];
			var textLayer:Array = [];
			var dTextLayer:Array = [];
			var btnLayer:Array = [];
			while (i < max)
			{
				var child:* = content.getChildAt(i);
				if (child is DisplayObject)
				{
					var name:String = child.name;
					var nameInfo:Array = name.split("_");
					var texture:String = nameInfo[1];
					var childName:String = ((nameInfo[2] != null) && (nameInfo[2] != "img")) ? nameInfo[2] : nameInfo[1];
					
					var item:Object = {"name": childName, //名字，没有值时与纹理名相同
							"texture": texture, //纹理
							"x": child.x, //坐标
							"y": child.y //坐标
						};
					if (texture == null)
					{
						this.setLog(nameInfo + "'s texture is null");
					}
					switch (nameInfo[0])
					{
						case "stxt": //静态文本
							this.addTextItem(item, child);
							break;
						case "img": //图片
							item["type"] = VIEW_UI_TYPE_IMAGE;
							break;
						case "ani": //动画
							item["type"] = VIEW_UI_TYPE_MOVIE;
							break;
						case "btn": //按钮
							item["type"] = VIEW_UI_TYPE_BUTTON;
							if (nameInfo[3] != null)
							{
								item["labelTexture"] = nameInfo[3];
							}
							break;
						case "quad": //四边形区域
							item["type"] = VIEW_UI_TYPE_QUAD;
							break;
						case "c": //空容器
						case "null": //空容器
							item["type"] = VIEW_UI_TYPE_CONTAINER;
							delete item["texture"]; //容器不需要纹理
							break;
						case "txt": //动态文本
							this.addTextItem(item, child, true);
							break;
						default: 
							isError = true;
							this.setLog("在界面 " + this._currentName + " 的 " + child.name + " 上遇到未知的UI类型，请确保工具是最新版本");
							break;
					}
					var tn:String = item["texture"];
					if (item["type"] == VIEW_UI_TYPE_BUTTON)
					{
						tn = "btn0_" + tn;
					}
					if (tn == "matchResultTitle" || tn == "matchResultWord")
					{
						tn;
					}
					var isSameLayer:Boolean = (tn != null) ? (layerName == this._xmlPools[tn]) : true;
					layerName = (isSameLayer) ? layerName : this._xmlPools[tn];
					if (item["type"] == VIEW_UI_TYPE_TEXT)
					{
						textLayer.push(item);
						i++;
						continue;
					}
					else if (item["type"] == VIEW_UI_TYPE_BUTTON)
					{
						btnLayer.push(item);
						i++;
						continue;
					}
					else if (item["type"] == VIEW_UI_TYPE_DYNAMIC_TEXT)
					{
						dTextLayer.push(item);
						i++;
						continue;
					}
					else
					{
						if (!isSameLayer || _oneBatchs.indexOf(item["type"]) != -1)
						{ //不同纹理或需要独立放一层的情况
							layers.push([]);
						}
					}
					var ii:int = (layers.length > 0) ? (layers.length - 1) : 0;
					if (layers[ii] == null)
					{
						layers[ii] = []; //补充初始化
					}
					(layers[ii] as Array).push(item);
				}
				i++;
			}
			if (btnLayer.length > 0)
			{ //按钮层
				layers.push(btnLayer);
			}
			if (textLayer.length > 0)
			{ //文本层
				layers.push(textLayer);
			}
			if (dTextLayer.length > 0)
			{
				var di:int = 0;
				var dm:int = dTextLayer.length;
				while (di < dm)
				{
					layers.push([dTextLayer[di]]);
					di++;
				}
			}
			result["view"] = layers;
			if (isError)
			{
				return;
			}
			var fileContent:String = JSON.stringify(result);
			
			this._currentName = this._currentName.replace(".swf", "");
			this.exportText.text = ToolApplicationUtils.replaceSystemPath(this.exportText.text);
			var path:String = this.exportText.text + "/" + this._currentName + ".json";
			this._action.fileManager.writeUTFBytes(path, fileContent);
			
			this.setLog(this._currentName + "配置生成成功！\r");
			
			this.loadSWF();
		}
		
		private function addTextItem(item:Object, child:*, isDynamic:Boolean = false):void
		{
			item["type"] = (isDynamic) ? VIEW_UI_TYPE_DYNAMIC_TEXT : VIEW_UI_TYPE_TEXT;
			item["textWidth"] = child.width;
			item["textHeight"] = child.height;
			var textField:TextField;
			if (child is TextField)
			{
				textField = child as TextField;
			}
			else if (child is MovieClip)
			{
				textField = (child as MovieClip).getChildAt(0) as TextField;
			}
			if (textField != null)
			{
				if (textField.text == "")
				{
					textField.text = " ";
				}
				item["text"] = textField.text;
				item["color"] = textField.textColor;
				item["fontSize"] = textField.getTextFormat().size;
			}
			delete item["texture"]; //位图文本不需要纹理
		}
		
		private function get xmlPathText():TextField
		{
			return this.getTextField("xmlPathText");
		}
		
		private function get loadButton():MovieClip
		{
			return this.getMovieClip("loadBtn");
		}
		
		private function get browserButton():MovieClip
		{
			return this.getMovieClip("browserBtn");
		}
		
		private function get exportText():TextField
		{
			return this.getTextField("exportText");
		}
	}

}