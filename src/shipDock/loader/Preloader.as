package shipDock.loader 
{
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.manager.NoticeManager;
	import shipDock.framework.application.loader.SDLoader;
	
	/**
	 * 预加载器基类
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class Preloader extends SDLoader 
	{
		
		public function Preloader(url:String, complete:Function=null, progress:Function=null) 
		{
			super(url, complete, progress);
		}
		
		override public function commit():void 
		{
			super.commit();
			var notice:INotice = this.createPreloaderNotice();
			if(notice != null) {
				NoticeManager.sendNotice(notice);
			}
		}
		
		protected function HTTPNoticeSuccess(result:Object):void {
			this.setLoadedData(result);
			this.loadCompleted(null);
		}
		
		protected function HTTPNoticeFail(result:Object):void {
		}
		
		protected function createPreloaderNotice():INotice {
			return null;
		}
	}

}