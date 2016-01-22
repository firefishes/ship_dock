package shipDock.framework.application.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.singleton.SingletonBase;
	
	/**
	 * 应用域管理器（单例）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class ApplicationDomainManager extends SingletonBase
	{
		
		public static const APPLICATION_DOMAIN_MANAGER:String = "applicationDomainMgr";
		
		public static function getInstance():ApplicationDomainManager
		{
			return SingletonManager.singletonManager().getSingleton(APPLICATION_DOMAIN_MANAGER) as ApplicationDomainManager;
		}
		
		/**应用域集合*/
		private var _domainMap:HashMap;
		
		public function ApplicationDomainManager()
		{
			super(this, APPLICATION_DOMAIN_MANAGER);
			
			this._domainMap = new HashMap();
			
			this.addDomain("current", ApplicationDomain.currentDomain);
		}
		
		/**
		 * 添加一个应用域
		 *
		 * @param	domainName
		 * @param	domain
		 */
		public function addDomain(domainName:String, domain:ApplicationDomain):void
		{
			this._domainMap.put(domainName, domain);
		}
		
		/**
		 * 移除一个应用域
		 *
		 * @param	domainName
		 * @return
		 */
		public function removeDomain(domainName:String):ApplicationDomain
		{
			if (domainName == "current")
				return null;
			var result:ApplicationDomain = this._domainMap.getValue(domainName, true) as ApplicationDomain;
			return result;
		}
		
		/**
		 * 获取一个应用域内的类定义
		 *
		 * @param	clsName
		 * @param	domainName
		 * @return
		 */
		public function getDefined(clsName:String, domainName:String = "current"):Class
		{
			var domain:ApplicationDomain = this.getDomain(domainName);
			return domain.getDefinition(clsName) as Class;
		}
		
		/**
		 * 获取一个应用域
		 *
		 * @param	domainName
		 * @return
		 */
		public function getDomain(domainName:String = "current"):ApplicationDomain
		{
			return this._domainMap.getValue(domainName) as ApplicationDomain;
		}
		
		/**
		 * 获取某个应用域内的影片剪辑实例
		 *
		 * @param	clsName
		 * @param	domainName
		 * @return
		 */
		public function getMovieClip(clsName:String, domainName:String = "current"):MovieClip
		{
			var cls:Class = this.getDefined(clsName, domainName) as Class;
			var result:MovieClip = new cls() as MovieClip;
			return result;
		}
		
		/**
		 * 获取某个应用域内的位图数据实例
		 *
		 * @param	clsName
		 * @param	domainName
		 * @return
		 */
		public function getBitmapData(clsName:String, domainName:String = "current"):BitmapData
		{
			var cls:Class = this.getDefined(clsName, domainName) as Class;
			var result:BitmapData = new cls() as BitmapData;
			return result;
		}
		
		/**
		 * 获取某个应用域内的位图实例
		 *
		 * @return
		 */
		public function getBitmap(clsName:String, domainName:String = "current"):Bitmap
		{
			var bitmapData:BitmapData = this.getBitmapData(clsName, domainName);
			var result:Bitmap = new Bitmap(bitmapData);
			return result;
		}
	}

}