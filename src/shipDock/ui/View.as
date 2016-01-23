package shipDock.ui
{
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.component.SDComponent;
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDMovieClip;
	import shipDock.framework.application.component.SDQuadBatch;
	import shipDock.framework.application.component.SDQuadButton;
	import shipDock.framework.application.component.SDQuadText;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.events.AssetQueueEvent;
	import shipDock.framework.application.interfaces.IViewTransformEffect;
	import shipDock.framework.application.loader.AssetType;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.FileAssetQueueLoader;
	import shipDock.framework.core.action.Action;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	import shipDock.framework.core.utils.StringUtils;
	import shipDock.ui.manager.ViewUIDataManager;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	/**
	 * 界面视图基类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class View extends SDComponent implements IView
	{
		/**视图素材是否已加载过*/
		private var _isTextureLoaded:Boolean;
		/**是否自动渲染文本*/
		private var _isAutoRenderText:Boolean;
		
		/**界面配置数据*/
		private var _UIConfigData:Object;
		/**界面配置加载器*/
		private var _UIConfigLoader:DataLoader;
		
		/**背景纹理名*/
		protected var _bgTextureName:String;
		/**界面用到的纹理名列表*/
		protected var _viewTextures:Array;
		
		/**是否应用界面配置*/
		protected var _hasUIConfig:Boolean;
		/**界面配置名*/
		protected var _UIConfigName:String;
		/**界面配置的更改项，用于生成界面前增加或修改界面配置*/
		protected var _UIConfigChanged:Object;
		
		/**PNG纹理素材加载器*/
		protected var _PNGAssetFactory:FileAssetQueueLoader;
		/**ATF纹理素材加载器*/
		protected var _ATFAssetFactory:FileAssetQueueLoader;
		
		public function View(bg:String = null, assetList:Array = null)
		{
			super();
			this._hasUIConfig = true;
			this._bgTextureName = bg;
			this._viewTextures = assetList;
			
			this.initBgTextureName();
			this.initViewTexture();
			
			(this._viewTextures == null) && (this._viewTextures = []);
		
		}
		
		override protected function init():void
		{
			this.initComponent();
			this.addEvents();
		}
		
		/*
		 * 覆盖此方法，初始化背景纹理名
		 *
		 */
		protected function initBgTextureName():void
		{
			//设置 this._bgTextureName;
		}
		
		/*
		 * 覆盖此方法，初始化界面纹理列表
		 *
		 */
		protected function initViewTexture():void
		{
			//设置 this._viewTextures;
		}
		
		/*
		 * 覆盖此方法，修改已载入的界面配置
		 *
		 * 修改界面配置的方法包括以下方法：
		 *
		 * setLayout
		 * setTouchConfig
		 *
		 */
		protected function setViewConfig():void
		{
		
		}
		
		/*
		 * 覆盖此方法，执行子类的界面的创建或修改操作
		 *
		 */
		override protected function createUI():void
		{
			super.createUI();
		}
		
		override protected function addedToStageHandler(event:Event = null):void
		{
			super.addedToStageHandler(event);
			this.loadViewTextures(); //加载纹理素材
		}
		
		/**
		 * 加载界面纹理素材，可用于外部在界面不派发被添加到舞台事件的情况下重新加载纹理
		 *
		 */
		public function loadViewTextures():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			
			if (this._isTextureLoaded || (this._viewTextures == null))
				this.assetLoadComplete();
			else
				this.startLoadViewAsset();
		}
		
		/**
		 * 开始加载界面纹理素材
		 *
		 */
		protected function startLoadViewAsset():void
		{
			(!!this._PNGAssetFactory) && this._PNGAssetFactory.dispose();
			(!!this._ATFAssetFactory) && this._ATFAssetFactory.dispose();
			var queue:QueueExecuter = ObjectPoolManager.getInstance().fromPool(QueueExecuter);
			queue.addEventListener(QueueExecuterEvent.QUEUE_COMPLETE_EVENT, this.viewTexturesQueueComplete);
			
			var PNGList:Array = (this._viewTextures[0] is Array) ? this._viewTextures[0] : this._viewTextures;
			var ATFList:Array = (this._viewTextures[1] is Array) ? this._viewTextures[1] : [];
			this._PNGAssetFactory = new FileAssetQueueLoader(PNGList, AssetType.TYPE_PNG);
			this._ATFAssetFactory = new FileAssetQueueLoader(ATFList, AssetType.TYPE_ATF);
			
			queue.add(this._PNGAssetFactory, this._ATFAssetFactory, this.assetLoadComplete);
			queue.commit();
		}
		
		/**
		 * 界面纹理素材队列加载完毕
		 *
		 * @param	event
		 */
		private function viewTexturesQueueComplete(event:QueueExecuterEvent):void
		{
			var target:QueueExecuter = event.target as QueueExecuter;
			target.removeEventListener(QueueExecuterEvent.QUEUE_COMPLETE_EVENT, this.viewTexturesQueueComplete);
			ObjectPoolManager.getInstance().toPool(target);
		}
		
		/**
		 * 内部资源加载完毕
		 *
		 */
		public function assetLoadComplete(event:AssetQueueEvent = null):void
		{
			this._isTextureLoaded = true;
			this.disposeAssetFactory();
			this.loadUIConfig();
		}
		
		/**
		 * 加载界面配置
		 *
		 */
		private function loadUIConfig():void
		{
			if (!this._hasUIConfig)
			{
				this.displayUI();
				return;
			}
			(!this._UIConfigName) && (this._UIConfigName = StringUtils.qualifiedClassName(this));
			this._UIConfigData = ViewUIDataManager.getInstance().getUIDataCache(this._UIConfigName);
			if (!this._UIConfigData)
			{
				var path:String = SDConfig.viewConfigPath + this._UIConfigName + ".json";
				this._UIConfigLoader = new DataLoader(path, this.UIDataLoaded);
				this._UIConfigLoader.commit();
			}
			else
				this.displayUI();
		}
		
		/**
		 * UI界面配置加载完毕
		 *
		 * @param	result
		 */
		private function UIDataLoaded(result:Object):void
		{
			if (!result)
				return;
			this._UIConfigData = result;
			this.initViewBackgroud();
			ViewUIDataManager.getInstance().addUIDataCache(this._UIConfigName, this._UIConfigData); //建立配置数据缓存
			this.displayUI();
		}
		
		/**
		 * 显示UI界面
		 *
		 */
		override protected function displayUI():void
		{
			this.initUIConfigChanged();
			super.displayUI();
			(this.isPopup) && this.redraw();
		}
		
		protected function initUIConfigChanged():void
		{
			this._UIConfigChanged = {"touch": {}};
			if (this._UIConfigData != null)
			{
				this.setViewConfig(); //创建界面前修改已载入的配置的最后机会
				
				var creater:ViewUICreater = new ViewUICreater(this, this.childrenRaw, this._UIConfigChanged);
				creater.createUI();
				this.changeProperty("staticTextNames", creater.textList);
				creater.dispose();
			}
		}
		
		protected function initViewBackgroud():void
		{
			if (!!this._bgTextureName)
			{
				var bgImage:SDImage = SDCore.getInstance().assetManager.getImage(this._bgTextureName);
				if (!!bgImage)
				{
					bgImage.name = "viewBg";
					this.putChildraw(bgImage);
				}
			}
		}
		
		/**
		 * 设置界面元素的点击事件配置
		 *
		 * @param	name
		 * @param	click
		 */
		protected function setTouchConfig(name:String, click:Function):void
		{
			(!this._UIConfigChanged["touch"]) && (this._UIConfigChanged["touch"] = {});
			this._UIConfigChanged["touch"][name] = click;
		}
		
		/**
		 * 设置界面元素的布局配置
		 *
		 * @param	name
		 * @param	layoutType
		 */
		protected function setLayout(childName:String, layoutType:int = 0):void
		{
			(!this._UIConfigChanged["layout"]) && (this._UIConfigChanged["layout"] = {});
			var layout:Object = this._UIConfigChanged["layout"];
			layout[childName] = layoutType;
			layout[layoutType] = null; //clear cache
		}
		
		/**
		 * 获取界面元素的布局
		 *
		 * @param name
		 * @return
		 *
		 */
		public function getLayout(layoutType:int):Array
		{
			var result:Array = [];
			var layout:Object = this._UIConfigChanged["layout"];
			if (layout != null)
			{
				if (!layout[layoutType])
				{
					for (var n:* in layout)
					{
						(layout[n] == layoutType) && result.push(n);
					}
					layout[layoutType] = result; //create cache
				}
				else
					result = layout[layoutType]; //from cache
			}
			return result;
		}
		
		override protected function disposeChildraw():void
		{
			super.disposeChildraw();
			this.disposeAssetFactory();
			this.disposeView();
		}
		
		override protected function disposeChild(target:*):void
		{
			if (!!this._UIConfigChanged)
			{
				if (target is DisplayObject)
				{
					var name:String = (target as DisplayObject).name;
					if (this._UIConfigChanged.hasOwnProperty(name))
					{
						var handler:Function = this._UIConfigChanged[name];
						(target as DisplayObject).removeEventListener(TouchEvent.TOUCH, handler);
					}
				}
			}
			super.disposeChild(target);
		}
		
		/*
		 * 覆盖此方法，执行子类的销毁操作
		 *
		 * 可以避免在执行销毁操作时一些因为数据被置空后引起的空对象错误
		 *
		 */
		protected function disposeView():void
		{
		
		}
		
		override protected function disposeData():void
		{
			super.disposeData();
			this._UIConfigData = null;
			(this._UIConfigLoader != null) && this._UIConfigLoader.dispose();
		}
		
		/**
		 * 销毁纹理加载器
		 *
		 */
		private function disposeAssetFactory():void
		{
			(!!this._PNGAssetFactory) && this._PNGAssetFactory.dispose();
			(!!this._ATFAssetFactory) && this._ATFAssetFactory.dispose();
			this._PNGAssetFactory = null;
			this._ATFAssetFactory = null;
		}
		
		/**
		 * 设置文本的个别属性
		 *
		 * @param	name
		 * @param	property
		 * @param	value
		 */
		protected function setStaticTextValue(name:String, property:String, value:*):void
		{
			if (!this.isNeedResetStaticTexts)
				return;
			var target:SDQuadText = this.getTextUI(name);
			if (!target)
				return;
			if (target.hasOwnProperty(property))
			{
				target[property] = value;
				(property == "multiLine") && (target.text = target.text);
			}
		}
		
		/**
		 * 添加此界面之外的静态文本
		 *
		 * @param	target
		 */
		public function addStaticQuadBatchText(target:SDQuadText):void
		{
			if (this.isPropertySet("mergeStaticTextList"))
				return;
			else
			{
				this.changePropertySet("mergeStaticTextList", true);
				var list:Array = this.getPropertyChanged("mergeStaticTextList");
				(!list) && (list = []);
				list.push(target);
				this.changeProperty("mergeStaticTextList", list);
				this.invalidate();
			}
		}
		
		/**
		 * 获取界面中的静态文本渲染批
		 *
		 * @param	name
		 * @return
		 */
		protected function getTextQuadBatch():SDQuadBatch
		{
			return this.getQuadBatchUI("textQuadBatch");
		}
		
		/**
		 * 更新静态文本渲染批
		 *
		 */
		public function commitStaticTextsChanged():void
		{
			if (this.isPropertySet("resetTextQuadBatch", true))
			{
				var quadBatch:SDQuadBatch = this.getTextQuadBatch();
				var list:Array = this.staticTextNames;
				if ((list == null) || (list.length == 0) || (quadBatch == null))
					return;
				quadBatch.reset();
				var i:int = 0;
				var max:int = list.length;
				while (i < max)
				{
					var target:SDQuadText = (list[i] is String) ? this.getTextUI(list[i]) : (list[i] as SDQuadText);
					(!!target) && this.getTextQuadBatch().addQuadBatch(target);
					i++;
				}
			}
		}
		
		override public function redraw():void
		{
			super.redraw();
			if (this.staticTextNames != null)
			{
				if (this.isPropertySet("mergeStaticTextList", true))
				{
					var list:Array = this.getPropertyChanged("mergeStaticTextList");
					if (!!list)
					{
						var i:int = 0;
						var max:int = list.length;
						while (i < max)
						{
							var target:SDQuadText = list[i];
							(!!target) && this.staticTextNames.push(target);
							i++;
						}
						this.changeProperty("mergeStaticTextList", []); 
					}
				}
			}
		}
		
		/**
		 * 添加子显示对象到一个新的容器
		 *
		 * @param	child
		 * @param	newParent 若此参数为字符串，则尝试从子控件集合中查找对应的空容器
		 */
		protected function addChildToContainer(child:DisplayObject, name:String, newParent:DisplayObjectContainer = null):void
		{
			
			var emptyUI:DisplayObjectContainer;
			emptyUI = this.getEmptySpriteUI(name) as DisplayObjectContainer;
			if(!emptyUI)
				return;
			emptyUI.addChild(child);
			(newParent) && newParent.addChild(emptyUI);
		}
		
		/**
		 * 获取界面配置定义的空容器
		 *
		 * @param	name
		 * @return
		 */
		public function getEmptySpriteUI(name:String):SDSprite
		{
			return this.childrenRaw.getValue(name) as SDSprite;
		}
		
		/**
		 * 获取界面配置定义的文本（动态和静态）
		 *
		 * @param	name
		 * @return
		 */
		public function getTextUI(name:String):SDQuadText
		{
			return this.childrenRaw.getValue(name) as SDQuadText;
		}
		
		/**
		 * 获取界面配置定义的按钮
		 *
		 * @param	name
		 * @return
		 */
		public function getButtonUI(name:String):SDQuadButton
		{
			return this.childrenRaw.getValue(name) as SDQuadButton;
		}
		
		/**
		 * 获取界面配置定义的图片
		 *
		 * @param	name
		 * @return
		 */
		public function getImageUI(name:String):SDImage
		{
			return this.childrenRaw.getValue(name) as SDImage;
		}
		
		/**
		 * 获取界面配置定义的动画
		 *
		 * @param	name
		 * @return
		 */
		public function getMovieUI(name:String):SDMovieClip
		{
			return this.childrenRaw.getValue(name) as SDMovieClip;
		}
		
		/**
		 * 获取界面配置定义的四边形渲染批
		 *
		 * @param	name
		 * @return
		 */
		public function getQuadBatchUI(name:String):SDQuadBatch
		{
			return this.childrenRaw.getValue(name) as SDQuadBatch;
		}
		
		/**
		 * 获取界面配置名
		 *
		 */
		public function get UIConfigName():String
		{
			return _UIConfigName;
		}
		
		/**
		 * 获取是否应用界面配置属性
		 *
		 */
		public function get hasUIConfig():Boolean
		{
			return _hasUIConfig;
		}
		
		/**
		 * 是否自动渲染静态文本
		 *
		 */
		public function get isAutoRenderText():Boolean
		{
			return _isAutoRenderText;
		}
		
		public function set isAutoRenderText(value:Boolean):void
		{
			_isAutoRenderText = value;
		}
		
		/**
		 * 获取静态文本的UI名
		 *
		 */
		private function get staticTextNames():Array
		{
			return this.getPropertyChanged("staticTextNames") as Array;
		}
		
		/**
		 * 检查是否需要重置静态文本批
		 *
		 */
		private function get isNeedResetStaticTexts():Boolean
		{
			var result:Boolean = true;
			if (!this.isPropertySet("resetTextQuadBatch"))
			{
				if (!this.getTextQuadBatch())
					result = false; //没有静态文本批
				else
					this.changePropertySet("resetTextQuadBatch", true); //设置静态文本批需要更新的标记
			}
			return result;
		}
		
		/**
		 * 界面显示时的转换特效
		 *
		 * @return
		 *
		 */
		public function get showTransformEffect():IViewTransformEffect
		{
			return null;
		}
		
		/**
		 * 界面切换时的转换特效
		 *
		 * @return
		 *
		 */
		public function get hideTransformEffect():IViewTransformEffect
		{
			return null;
		}
		
		override public function get action():IAction
		{
			return (super.action != null) ? super.action : new Action(this.className + "Action");
		}
	}

}