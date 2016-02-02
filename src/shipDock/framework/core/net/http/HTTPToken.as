package shipDock.framework.core.net.http
{
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import shipDock.framework.core.command.HTTPCommand;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IHTTPToken;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.INotify;
	import shipDock.framework.core.interfaces.IObserver;
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.NoticeManager;
	import shipDock.framework.core.notice.HTTPProcessNotice;
	import shipDock.framework.core.notice.Notice;
	
	import starling.events.EventDispatcher;
	

	/**
	 * HTTP网络请求类
	 * 
	 * @author shaoxin.ji
	 * 
	 */
	public class HTTPToken extends EventDispatcher implements IObserver,IDispose,IHTTPToken,INotify
	{
		public static const STATUS_0:int = 0;//网络问题
		public static const STATUS_500:int = 500;//服务端接口报错
		
		public static const TYPE_TOKEN_NORMAL:String = "normal";//任意类型的数据
		public static const TYPE_TOKEN_JSON:String = "json";//json类型的数据
		public static const TYPE_TOKEN_BINARY:String = "binary";//二进制类型的数据
		
		private var _resultType:String;//数据类型
		private var _url:String;//接口地址
		private var _loader:URLLoader;//加载器
		private var _requestMethod:String;
		private var _data:*;//数据
		private var _doSuccess:Function;//服务的请求成功时的回调函数，需要一个Object参数
		private var _doFail:Function;//服务的请求失败时的回调函数，需要一个Object参数
		private var _retry:int = 0;//重连次数
		private var _params:Object;//参数
		private var _method:String;//发送方式，POST/GET
		private var _dataFormat:String;//数据格式
		private var _resendTimer:Timer;//重连计时器
		private var _sendTimer:Timer;//发送超时计时器
		private var _isUseRawResult:Boolean;//处理返回值时是否使用服务端的原始返回值
		private var _isUseDefaultFail:Boolean;//是否使用默认的失败处理
		private var _responseHeaders:Array;
		private var _resultLength:int;
		private var _URLInfo:String;
		
		private var _subjects:Object;
		
		public function HTTPToken(doSuccess:Function = null, doFail:Function = null)
		{
			this._doSuccess = doSuccess;
			this._doFail = doFail;
		}
		
		public function dispose():void {
			this.removeEvents();
			
			this.cancelResendTimer();
			this.cancelTimeoutTimer();
			
			this._subjects = null;
			
			this._loader = null;
			this._doSuccess = null;
			this._params = null;
			this._data = null;
			this._retry = 0;
		}
		
		public function notify(notice:INotice):* {
			return null;
		}
		
		/**
		 * 广播消息
		 * 
		 * @param	notice
		 * @return
		 */
		public function sendNotice(target:*, body:* = null, subCommand:String = null, observer:IObserver = null, autoDispose:Boolean = true):* {
			var result:*;
			var notice:INotice;
			if(target is INotice)
				notice = target;
			else if (target is String)
				notice = new Notice(target, body, observer, autoDispose);
			result = NoticeManager.sendNotice(notice);
			return result;
		}
		
		public function addNotice(noticeName:String, handler:Function, owner:* = null):void {
			NoticeManager.addNotice(noticeName, this, handler);
		}
		
		public function removeNotice(noticeName:String, handler:Function):void {
			NoticeManager.removeNotice(noticeName, this, handler);
		}
		
		public function setSubject(subject:ISubject):void {
			if (this._subjects == null) {
				this._subjects = { };
			}
			this._subjects[subject.subjectName] = subject;
		}
		
		public function removeSubject(subject:ISubject):void {
			delete this._subjects[subject.subjectName];
		}
		
		/**
		 * 调用服务度接口或加载文件数据
		 *  
		 * @param url
		 * @param complete
		 * @param method 接口名
		 * @param params 接口参数
		 * @param dataFormat 数据格式类型
		 * @param requestMethod 请求提交的类型
		 * 
		 */
		public function send(method:String = null, params:Object = null, isUseDefaultFail:Boolean = true, dataFormat:String = null, requestMethod:String = "POST"):void {
			if (this._loader == null) {
				this._loader = new URLLoader();
			}
			if(this._resultType == null) {
				this._resultType = TYPE_TOKEN_JSON;//返回值类型
				
			}
			
			this.addEvents();
			
			this._url = ServerConfig.host;
			if(params == null) {
				params = this.defaultParams();
			}else {
				var defaults:Object = this.defaultParams();//默认需要传递的参数
				if(defaults != null) {//把默认传递的参数设置到接口参数中
					for(var key:* in defaults) {
						params[key] = defaults[key];
					}
				}
			}
			this._params = params;//接口参数
			this._method = method;//接口名
			this._dataFormat = (dataFormat == null) ? URLLoaderDataFormat.TEXT : dataFormat;
			this._loader.dataFormat = this._dataFormat;
			
			var request:URLRequest = new URLRequest(this._url);
			//request.contentType = "text/xml";//这里不知道需不需要
			request.method = (requestMethod == null) ? URLRequestMethod.POST : requestMethod;
			this._requestMethod = request.method;
			var value:*;
			value = new URLVariables();
			value["method"] = method;
			if (this._params != null) {
				for (var k:* in this._params) {
					value[k] = this._params[k];
				}
			}
			request.data = value;
			this._loader.load(request);
			
			this.startTimeoutTimer();//开始超时计时
			
			this._URLInfo = request.url + "?" + this.getParamsInfo(value);
			if(this._retry == 0) {
				LogsManager.getInstance().setLog("【HTTP CALL SUCCESS】:\n" + this._URLInfo);
			}else {
				LogsManager.getInstance().setLog("Caution HTTPToken-checkRetry: \n服务端请求已重新发送，已重试 ", this._retry, " 次.");
			}
			
			this.sendNotice(new HTTPProcessNotice(HTTPCommand.HTTP_SUCCESS_SEND_COMMAND));//请求已发送
		}
		
		public function loadFile(url:String):void {
			if (this._loader == null) {
				this._loader = new URLLoader();
			}
			this.addEvents();
			this._url = ServerConfig.asset + url;
			var value:Object = { };
			this._url += "?1=1&" ;
			this._url = this._url.replace("null", "");
			if (this._url.indexOf("null") > -1) {
				trace("null url", this._url);
			}
			var request:URLRequest = new URLRequest(this._url);
			request.method = URLRequestMethod.GET;
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.load(request);
			LogsManager.getInstance().setLog("【LOAD File】\n" + this._url);
			
		}
		
		private function getParamsInfo(params:Object):String {
			var result:String = "";
			var i:int;
			for (var name:String in params) {
				if (params[name] is Array) {
					for (i = 0; i < params[name].length; i++) {
						result += name + "=" + params[name][i] + "&";
					}
				} else {
					result += name + "=" + params[name] + "&";
				}
			}
			return result;
		}
		
		/**
		 * 默认传递的参数 
		 * 
		 */
		protected function defaultParams():Object {
			return ServerConfig.HTTPTokenParams;
		}
		
		/**
		 * 添加事件 
		 * 
		 */
		private function addEvents():void {
			this._loader.addEventListener(Event.COMPLETE, callCompleteHandler);
			this._loader.addEventListener(Event.OPEN, openHandler);
			this._loader.addEventListener(ProgressEvent.PROGRESS, callProgressHandler);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		/**
		 * 移除事件 
		 * 
		 */
		private function removeEvents():void {
			if (_loader)
			{
				this._loader.removeEventListener(Event.COMPLETE, callCompleteHandler);
				this._loader.removeEventListener(Event.OPEN, openHandler);
				this._loader.removeEventListener(ProgressEvent.PROGRESS, callProgressHandler);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
		}
		
		/**
		 * 完成数据加载或接收
		 *  
		 * @param event
		 * 
		 */
		public function callCompleteHandler(event:Event):void {
			this.removeEvents();
			
			this.cancelResendTimer();
			this.cancelTimeoutTimer();
			
			this._data = this._loader.data;
			
			this.executeCallback();
		}
		
		/**
		 * 处理回调函数
		 *  
		 * @param result
		 * 
		 */
		private function executeCallback():void {
			if (this._resultType == TYPE_TOKEN_JSON) {
				this.JSONDataResult();
				
			}else if (this._resultType == TYPE_TOKEN_BINARY) {
				this.binaryResult();
				
			}
		}
		
		/**
		 * 处理JSON格式的返回值
		 * 
		 */
		private function JSONDataResult():void {
			var result:Object;
			try {
				result = JSON.parse(this._data);
			}catch (error:Error) {
				LogsManager.getInstance().setLog("Error HTTPToken-JSONDataResult: Server result can't parse to json!");
				return;
			}
			
			if (this.checkResultSuccess(result)) {
				this.successResult(result);//正常处理返回值
			}else {
				this.failResult(result);
			}
		}
		
		protected function checkResultSuccess(value:Object):Boolean {
			var result:* = this.sendNotice(new HTTPProcessNotice(HTTPCommand.CHECK_HTTP_RESULT_SUCCESS_COMMAND, value));
			if (result == null) {
				result = true;
			}
			return result;
		}
		
		/**
		 * 处理二进制格式的返回值
		 * 
		 */
		private function binaryResult():void {
			var result:ByteArray = this._data as ByteArray;
			if(result == null) {
				LogsManager.getInstance().setLog("Error HTTPToken-binaryResult: Server byteArray result is null!");
			}
			this.successResult(result);//正常处理返回值
		}
		
		/*
		 * 服务端请求成功的处理
		 * 
		*/
		private function successResult(result:Object):void {
			var isByteArray:Boolean = (result is ByteArray);
			if(!isByteArray) {
				this.sendNotice(new HTTPProcessNotice(HTTPCommand.HTTP_SUCCESS_RESULT_COMMAND, result));//统一处理返回值
			}
			if (this._doSuccess != null) {
				var params:* = (this._isUseRawResult) ? this._data : result;
				this._doSuccess(params);
			}else {
				LogsManager.getInstance().setLog("【NET】Get data from server without any processing." + JSON.stringify(result, null, 4));
			}
			this.dispose();
		}
		/*
		 * 服务端请求失败的处理
		 * 
		*/
		private function failResult(result:Object):void {
			this.sendNotice(new HTTPProcessNotice(HTTPCommand.HTTP_FAIL_RESULT_COMMAND, result));//处理失败结果
			if(this._isUseDefaultFail) {
				this.failHandler(result);
			}
			if(this._doFail != null) {
				this._doFail(result);
			}
		}
		
		/*
		 * 服务端请求失败的默认处理
		 * 
		*/
		protected function failHandler(result:Object):void {
			
		}
		
		public function callProgressHandler(event:ProgressEvent):void {
			this.sendNotice(new HTTPProcessNotice(HTTPCommand.CALL_HTTP_PROGRESS_COMMAND));
		}
		
		public function openHandler(event:Event):void {
			
		}
		
		public function securityErrorHandler(event:SecurityErrorEvent):void {
			
		}
		
		public function httpStatusHandler(event:HTTPStatusEvent):void {
			LogsManager.getInstance().setLog("服务端接口返回状态值 http_status：" + event.status);
			this._responseHeaders = event.responseHeaders;
			this._resultLength = int(this.getResponseHeader("Content-Length") || this.getResponseHeader("Raw-Content-Length"));
			if(event.status == 0) {
				this.checkRetry();
			}
			var status:int = event.status;
			var onOk:Function;
			//var notice:AlertPopupNotice;
			if (status == STATUS_500) {
				//errorContent = Language.transError("100001");
				
				//notice = new AlertPopupNotice(Language.trans("error_title"), errorContent, null, null, 0, false);
				//if (ActivePannelListener.defaultPannel != null) {
					//notice.okCallbackNotice = new ViewChangeNotice(null, false, true);
				//}else {
					////TODO 停止所有活动
				//}
				//
				//this.notify(notice);
				
			}else if (event.status == STATUS_0) {
				
				//errorContent = Language.transError("100002");
				
				//if (ActivePannelListener.defaultPannel == null) {//考虑还未进入游戏的预加载阶段
					//this.checkRetry();//直接重试
				//}else {
					//notice = new AlertPopupNotice(Language.trans("error_title"), errorContent, this.checkRetry, null, 0, false);//点击确定后重试
				//}
			}
		}
		
		public function getResponseHeader(name:String):String
		{
			if (_responseHeaders != null) {
				for (var i:int = 0; i < _responseHeaders.length; i++) {
					if (_responseHeaders[i].name == name) {
						return _responseHeaders[i].value;
					}
				}
			}
			return null;
		}
		
		public function ioErrorHandler(event:IOErrorEvent):void {
			
		}
		
		/*
		 * 检测是否需要重发请求
		 * 
		*/
		private function checkRetry():void {
			if(this._retry < ServerConfig.retryMax) {
				var msg:String = "Error HTTPToken-sendTimeout: 服务端请求无响应或连接超时! ";
				LogsManager.getInstance().setLog(msg + "将在 " + ServerConfig.retryTimeout / 1000, " 秒后重试!");
				this.startResendTimer();
				
			}else {//超过重发尝试次数后销毁请求
				LogsManager.getInstance().setLog("Error HTTPToken-checkRetry: 服务端请求发送失败\n" + this._URLInfo);
				this.dispose();
			}
		}
		
		/*
		 * 重新发送请求
		 * 
		*/
		private function retrySend(event:TimerEvent):void {
			this.cancelResendTimer();
			
			this.removeEvents();
			this.send(this._method, this._params, this.isUseDefaultFail, this._dataFormat, this._requestMethod);
			
			this._retry++;
		}
		
		/*
		 * 启动重发请求计时器
		 * 
		*/
		private function startResendTimer():void {
			this.cancelResendTimer();
			this._resendTimer = new Timer(ServerConfig.retryTimeout, 1);
			this._resendTimer.addEventListener(TimerEvent.TIMER, this.retrySend);
			this._resendTimer.start();
		}
		
		/*
		 * 取消重发请求计时器
		 * 
		*/
		private function cancelResendTimer():void {
			if (this._resendTimer == null) {
				return;
			}
			this._resendTimer.removeEventListener(TimerEvent.TIMER, this.retrySend);
			this._resendTimer.stop();
			this._resendTimer = null;
		}
		
		/**
		 * 响应超时的处理 
		 * 
		 */
		private function sendTimeout(event:TimerEvent):void {
			this.cancelTimeoutTimer();//取消超时计时器
		}
		
		/**
		 * 启动请求超时计时器 
		 * 
		 */
		private function startTimeoutTimer():void {
			this.cancelTimeoutTimer();
			this._sendTimer = new Timer(ServerConfig.noResponderTime, 1);
			this._sendTimer.addEventListener(TimerEvent.TIMER, this.sendTimeout);
			this._sendTimer.start();
		}
		
		/**
		 * 取消请求超时计时器 
		 * 
		 */
		private function cancelTimeoutTimer():void {
			if (this._sendTimer == null) {
				return;
			}
			this._sendTimer.removeEventListener(TimerEvent.TIMER, this.retrySend);
			this._sendTimer.stop();
			this._sendTimer = null;
		}

		public function get url():String
		{
			return _url;
		}

		public function get data():*
		{
			return _data;
		}

		public function get resultType():String
		{
			return _resultType;
		}

		public function set resultType(value:String):void
		{
			_resultType = value;
		}
		
		public function get isUseRawResult():Boolean 
		{
			return _isUseRawResult;
		}
		
		public function set isUseRawResult(value:Boolean):void 
		{
			_isUseRawResult = value;
		}
		
		public function get isUseDefaultFail():Boolean 
		{
			return _isUseDefaultFail;
		}
		
		public function set isUseDefaultFail(value:Boolean):void 
		{
			_isUseDefaultFail = value;
		}
		
		public function get responseHeaders():Array 
		{
			return _responseHeaders;
		}
		
		public function get resultLength():int 
		{
			return _resultLength;
		}
	}
}