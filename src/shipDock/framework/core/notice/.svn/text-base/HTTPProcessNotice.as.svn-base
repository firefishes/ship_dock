package shipDock.framework.core.notice 
{
	import shipDock.framework.core.notice.SDNoticeName;
	
	/**
	 * HTTP请求流程消息类
	 * 
	 * 负责HTTP请求发出后的操作
	 * 配合HTTP网络请求命令类封装和调用逻辑，并发送HTTP网络请求的消息
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class HTTPProcessNotice extends Notice 
	{
		
		public function HTTPProcessNotice(subCommand:String, data:*=null) 
		{
			this.subCommand = subCommand;
			super(SDNoticeName.SD_HTTP, data);
			
		}
		
	}

}