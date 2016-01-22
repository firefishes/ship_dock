package shipDock.framework.core.manager {
	
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.singleton.SingletonBase;
	
	/**
	 * 日志管理器（单例）
	 * 
	 * @author shaoxin.ji
	 * 
	 */
	public class LogsManager extends SingletonBase {
	
		public static var text:*;//可以是starling 的，也可以是原生的
		
		public static function getInstance():LogsManager {
			return SingletonManager.singletonManager().getSingleton("logsMgr") as LogsManager;
		}
		
		public var isTraceMode:Boolean = true;
		public var isDebugMode:Boolean = true;
		public var isShowText:Boolean;
		
		private var _logsHistory:HashMap;
		private var _appendTextCount:int = 0;
		private var _isTraceMax:Boolean = true;
		
		public function LogsManager(name:String = "logsMgr") {
			super(this, name)
			this._logsHistory = new HashMap();
		}
		
		public function setLog(...args):String {
			if(!this.isDebugMode) {
				return null;
			}
			var result:String = "Log >>> ";
			if(String(args[0]).indexOf("Caution") != -1) {
				result = "【0_-】" + result;//表示有警告，可以睁一只眼闭一只眼
			}else if(String(args[0]).indexOf("Error") != -1) {
				result = "【X_X】" + result;//表示有报错，需要注意
			}
			var i:int = 0;
			while(i < args.length) {
				if(args[i] is String) {
					result += args[i];
				}else if(args[i] is Object) {
					result += args[i].toString();
				}
				i++;
			}
			var index:int = this._logsHistory.size + 1;
			result += "\n\r";
			this._logsHistory.put(index.toString(), result);
			if(this.isTraceMode) {
				if(result.length >= 1000) {
					trace("this logs is too long...");
				}else {
					trace(result);
				}
			}
			if(isShowText && (text != null)) {
				if(this._isTraceMax) {
					this._appendTextCount = 0;
					this._isTraceMax = false;
					text["text"] = "";
				}
				text["text"] = result + "\r";
				this._appendTextCount++;
				if(this._appendTextCount >= 100) {
					this._isTraceMax = true;
				}
			}
			return result;
		}
		
		public function get logsHIstory():String {
			var result:String = "";
			if(this._logsHistory) {
				var index:int = 0;
				var max:int = this._logsHistory.size;
				while(index < max) {
					var log:String = this._logsHistory.getValue(index.toString()) as String;
					result += log; 
					index++;
				}
			}else {
				result = "ELib ELogsManager-logHistory: no logs...";
			}
			return result;
		}
		
		public function clear():void {
			this._logsHistory.clear();
		}
		
		public function logToServer(... msgs):void
		{
			//var http:HttpRequest = new HttpRequest(null, null, false);
			//http.showLoading = false;
			//http.send(Global.apiURL, "client_log.log", { "type": "error", "user": GameVO.user.uid, "data": msgs.join(" ") } );
		}
	}
}