package shipDock.framework.application.loader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import shipDock.framework.application.manager.ParticleManager;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 粒子特效素材队列加载器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class ParticleAssetQueueLoader extends AssetQueueLoader
	{
		
		private var _curName:String = "";
		private var _curLoadCount:int = 0;
		private var _particleManager:ParticleManager;
		
		/**
		 *
		 * @param	list 元素形如：[xxxx], xxxx->path_xxxx
		 * @param	assetType
		 * @param	isScale
		 * @param	update
		 * @param	complete
		 */
		public function ParticleAssetQueueLoader(list:Array, isScale:Boolean = true, update:Function = null, complete:Function = null)
		{
			super(list, AssetType.TYPE_PEX, isScale, update, complete);
			this._particleManager = ParticleManager.getInstance();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if (this.isReleaseInPool)
				return;
		}
		
		override protected function loaderUnitComplete(data:*):void
		{
			var name:String = _assetList[_queue.currentIndex - 1];
			name = this._particleManager.getConfigName(name);
			this._particleManager.addPexConfig(name, data);
		}
		
		override public function setAssetQueueInfo(list:Array, assetType:String, isScale:Boolean = true, update:Function = null, complete:Function = null):void
		{
			super.setAssetQueueInfo(list, AssetType.TYPE_PEX, isScale, update, complete);
		}
		
		public function loadSindleTexture(path:String, callback:Function):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:*):void
				{
					var info:LoaderInfo = e.target as LoaderInfo;
					if (!!info)
					{
						if (callback is Function)
							callback(Texture.fromBitmap(info.content as Bitmap));
					}
				});
			loader.load(new URLRequest(path));
		}
		
		public function get loaderCount():uint
		{
			return this._queue.queueSize;
		}
		
		public function get currentIndex():int
		{
			return this._queue.currentIndex;
		}
	}

}