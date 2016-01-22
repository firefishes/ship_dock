package shipDock.framework.core.net.http
{
	import shipDock.framework.core.interfaces.IHTTPToken;
	
	/**
	 * HTTP 网络请求类
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class HTTPServer
	{
		
		/*
		 * 发送网络请求
		 *
		 * @params method 网络接口名
		 * @params params 网络接所需参数
		 * @params doSuccess 网络接口处理成功的回调函数
		 * @params doFail 网络接口处理失败的回调函数
		 * @params tokenTarget 不使用默认的HTTPToken对象发送网络请求
		 * @params isUseDefaultFail 是否使用默认的
		 * @params dataFormat 加载器的数据格式类型
		 * @params requestMethod URLRequest对象发送数据的提交方式
		 *
		 */
		public static function send(method:String, params:Object = null, doSuccess:Function = null, doFail:Function = null, tokenTarget:IHTTPToken = null, isUseDefaultFail:Boolean = true, dataFormat:String = null, requestMethod:String = "POST"):void
		{
			var defaultCls:Class = ServerConfig.defaultHTTPTokenClass;
			var token:IHTTPToken = (tokenTarget != null) ? tokenTarget : new defaultCls(doSuccess, doFail);
			token.send(method, params, isUseDefaultFail, dataFormat, requestMethod);
		}
		
		public function HTTPServer()
		{
		
		}
	
	}

}