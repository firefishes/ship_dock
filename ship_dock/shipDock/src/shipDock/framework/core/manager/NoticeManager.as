package shipDock.framework.core.manager
{
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.IObserver;
	import shipDock.framework.core.notice.NoticeController;
	
	/**
	 * 消息管理器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class NoticeManager
	{
		public static function sendNotice(notice:INotice):*
		{
			return NoticeController.getInstance().sendNotice(notice);
		}
		
		public static function addNotice(noticeName:String, observer:IObserver, handler:Function = null):void
		{
			NoticeController.getInstance().addNotice(noticeName, observer, handler);
		}
		
		public static function removeNotice(noticeName:String, observer:IObserver, handler:Function = null):void
		{
			NoticeController.getInstance().removeNotice(noticeName, observer, handler);
		}
		
		public function NoticeManager()
		{
		}
	}
}