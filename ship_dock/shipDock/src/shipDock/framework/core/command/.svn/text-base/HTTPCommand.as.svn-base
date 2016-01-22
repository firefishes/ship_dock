package shipDock.framework.core.command {
	import shipDock.framework.core.net.http.HTTPServer;
	import shipDock.framework.core.notice.CoreNotice;
	import shipDock.framework.core.notice.HTTPNotice;
	import shipDock.framework.core.notice.HTTPProcessNotice;
	
	/**
	 * HTTP网络请求命令类
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class HTTPCommand extends Command 
	{
		
		//--------------------------子命令--------------------------------------
		/*发送HTTP服务端请求*/
		public static const SEND_HTTP_SERVER_COMMAND:String = "sendHTTPServerCommand";
		/*HTTP服务度请求发送中*/
		public static const CALL_HTTP_PROGRESS_COMMAND:String = "callHTTPProgressCommand";
		/*HTTP服务度请求发送成功*/
		public static const HTTP_SUCCESS_SEND_COMMAND:String = "HTTPSuccessSendCommand";
		/*HTTP服务度请求返回值接收成功*/
		public static const HTTP_SUCCESS_RESULT_COMMAND:String = "HTTPSuccessResultCommand";
		/*HTTP服务度请求返回值接收失败*/
		public static const HTTP_FAIL_RESULT_COMMAND:String = "HTTPFailResultCommand";
		/*HTTP服务度请求返回值结构检测成功*/
		public static const CHECK_HTTP_RESULT_SUCCESS_COMMAND:String = "checkHTTPResultSuccessCommand";
		
		public function HTTPCommand() 
		{
			super();
			
		}
		
		/**
		 * 发送HTTP服务端请求 子命令的具体逻辑
		 * 
		 * @param	serverNotice
		 */
		public function sendHTTPServerCommand(serverNotice:HTTPNotice):void {
			if (serverNotice == null) {
				return;
			}
			if (serverNotice.isFalseData) {
				serverNotice.successed(null);//假数据
				
			}else {//与真实的服务度做HTTP请求交互
				HTTPServer.send(
					serverNotice.method, 
					serverNotice.data, 
					serverNotice.successed, 
					serverNotice.failed, 
					serverNotice.token, 
					serverNotice.isUseDefaultFail
				);
			}
		}
		
		/**
		 * HTTP服务度请求发送成功 子命令的具体逻辑
		 * 
		 * @param	notice
		 */
		public function HTTPSuccessSendCommand(notice:HTTPProcessNotice):void {
			this.sendNotice(new CoreNotice(CoreCommand.SHOW_LOADING_COMMAND));//加载数据中
		}
		
		/**
		 * HTTP服务度请求返回值接收成功 子命令的具体逻辑
		 * 
		 * @param	notice
		 */
		public function HTTPSuccessResultCommand(notice:HTTPProcessNotice):void {
			this.sendNotice(new CoreNotice(CoreCommand.HIDE_LOADING_COMMAND));//数据加载完毕
		}
		
		/**
		 * HTTP服务度请求发送中 子命令的具体逻辑
		 * 
		 * @param	notice
		 */
		public function callHTTPProgressCommand(notice:HTTPProcessNotice):void {
			
		}
		
		/**
		 * HTTP服务度请求返回值接收失败 子命令的具体逻辑
		 * 
		 * @param	notice
		 */
		public function HTTPFailResultCommand(notice:HTTPProcessNotice):void {
			this.sendNotice(new CoreNotice(CoreCommand.HIDE_LOADING_COMMAND));//数据加载完毕，但是结果失败
		}
		
		/**
		 * HTTP服务度请求返回值结构检测成功 子命令的具体逻辑
		 * 
		 * @param	notice
		 */
		public function checkHTTPResultSuccessCommand(notice:HTTPProcessNotice):void {
			
		}
	}

}