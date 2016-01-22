package shipDock.framework.core.events 
{
	import shipDock.framework.core.interfaces.IObserver;
	import starling.events.Event;
	
	/**
	 * 被代理对象相关的事件
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class ProxyedEvent extends SDEvent 
	{
		public static const PROXYED_SEND_NOTICE_EVENT:String = "proxyedSendNoticeEvent";
		
		public function ProxyedEvent(notice:*, body:Object = null, subCommand:String = null, observer:IObserver = null, autoDispose:Boolean = true) 
		{
			var params:Object = { "notice":notice, "body":body, "subCommand":subCommand, "observer":observer, "autoDispose":autoDispose };
			super(PROXYED_SEND_NOTICE_EVENT, false, params);
			
		}
		
		public function get notice():* {
			return this.data["notice"];
		}
		
		public function get body():Object {
			return this.data["body"];
		}
		
		public function get subCommand():String {
			return this.data["subCommand"];
		}
		
		public function get observer():IObserver {
			return this.data["observer"];
		}
		
		public function get autoDispose():Boolean {
			return this.data["autoDispose"];
		}
		
	}

}