package shipDock.model 
{
	import shipDock.framework.core.net.http.ServerConfig;
	import shipDock.framework.core.model.DataModel;
	
	/**
	 * 账户数据模型
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class ProfileModel extends DataModel implements IProfileModel
	{
		
		private var _token:String;//平台token（IOS or AND）
		private var _sign:String;//服务端返回的用户签名
		private var _platform:String;//应用平台
		private var _deviceType:String;//设备型号
		private var _deviceID:String;//设备id
		private var _appVersion:String;//应用版本号
		
		private var _userToken:String;//发送给服务端的用户token
		private var _userSign:String;//发送给服务端的用户sign
		
		private var _versionSign:String;//初始化游戏数据时服务端返回版本标识
		
		private var _serverID:String;//服务器id，用于选服登录
		
		public function ProfileModel() 
		{
			super();
			
		}
		
		/**
		 * 平台token（IOS or AND）
		 * 
		 */
		public function get token():String 
		{
			return _token;
		}
		
		public function set token(value:String):void 
		{
			_token = value;
			ServerConfig.HTTPTokenParams["token"] = this._token;
		}
		
		/**
		 * 应用平台
		 * 
		 */
		public function get platform():String 
		{
			return _platform;
		}
		
		public function set platform(value:String):void 
		{
			_platform = value;
			ServerConfig.HTTPTokenParams["p"] = this._platform;
		}
		
		/**
		 * 设备型号
		 * 
		 */
		public function get deviceType():String 
		{
			return _deviceType;
		}
		
		public function set deviceType(value:String):void 
		{
			_deviceType = value;
			ServerConfig.HTTPTokenParams["device"] = this._deviceType;
		}
		
		/**
		 * 设备id
		 * 
		 */
		public function get deviceID():String 
		{
			return _deviceID;
		}
		
		public function set deviceID(value:String):void 
		{
			_deviceID = value;
			ServerConfig.HTTPTokenParams["did"] = this._deviceID;
		}
		
		/**
		 * 应用版本号
		 * 
		 */
		public function get appVersion():String 
		{
			return _appVersion;
		}
		
		public function set appVersion(value:String):void 
		{
			_appVersion = value;
			ServerConfig.HTTPTokenParams["ver"] = this._appVersion;
		}
		
		/**
		 * 发送给服务端的用户token
		 * 
		 */
		public function get userToken():String 
		{
			return _userToken;
		}
		
		public function set userToken(value:String):void 
		{
			_userToken = value;
			ServerConfig.HTTPTokenParams["user_token"] = this._userToken;
		}
		
		/**
		 * 发送给服务端的用户sign
		 * 
		 */
		public function get userSign():String 
		{
			return _userSign;
		}
		
		public function set userSign(value:String):void 
		{
			_userSign = value;
			ServerConfig.HTTPTokenParams["user_sign"] = this._userSign;
		}
		
		/**
		 * 服务端返回的用户签名
		 * 
		 */
		public function get sign():String 
		{
			return _sign;
		}
		
		public function set sign(value:String):void 
		{
			_sign = value;
			ServerConfig.HTTPTokenParams["sign"] = this._sign;
		}
		
		/**
		 * 服务器id，用于选服登录
		 * 
		 */
		public function get serverID():String 
		{
			return _serverID;
		}
		
		public function set serverID(value:String):void 
		{
			_serverID = value;
			ServerConfig.HTTPTokenParams["server_id"] = _serverID;
		}
		
		/**
		 * 初始化游戏数据时服务端返回版本标识
		 * 
		 */
		public function get versionSign():String 
		{
			return _versionSign;
		}
		
		public function set versionSign(value:String):void 
		{
			_versionSign = value;
			ServerConfig.HTTPTokenParams["ver_sign"] = this._versionSign;
		}
		
	}

}