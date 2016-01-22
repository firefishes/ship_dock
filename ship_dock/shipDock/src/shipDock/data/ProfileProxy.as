package shipDock.data
{
	import shipDock.model.IProfileModel;
	import shipDock.model.ProfileModel;
	import shipDock.framework.core.observer.DataProxy;
	
	/**
	 * 用户数据代理类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class ProfileProxy extends DataProxy implements IProfileProxy
	{
		
		public static const PROXY_NAME:String = "ProfileProxy";
		
		protected var _profileModel:IProfileModel;
		
		public function ProfileProxy()
		{
			super(PROXY_NAME);
			
			this.setProfileModel();
		}
		
		/**
		 * 覆盖此方法修改用户数据模型对象
		 *
		 */
		protected function setProfileModel():void
		{
			this._profileModel = new ProfileModel();
		}
		
		public function getToken():String
		{
			return this._profileModel.token;
		}
		
		public function setToken(value:String):void
		{
			this._profileModel.token = value;
		}
		
		public function getPlatform():String
		{
			return this._profileModel.platform;
		}
		
		public function setPlatform(value:String):void
		{
			this._profileModel.platform = value;
		}
		
		public function getDeviceType():String
		{
			return this._profileModel.deviceType;
		}
		
		public function setDeviceType(value:String):void
		{
			this._profileModel.deviceType = value;
		}
		
		public function getDeviceID():String
		{
			return this._profileModel.deviceID;
		}
		
		public function setDeviceID(value:String):void
		{
			this._profileModel.deviceID = value;
		}
		
		public function getAppVersion():String
		{
			return this._profileModel.appVersion;
		}
		
		public function setAppVersion(value:String):void
		{
			this._profileModel.appVersion = value;
		}
		
		public function getUserToken():String
		{
			return this._profileModel.userToken;
		}
		
		public function setUserToken(value:String):void
		{
			this._profileModel.userToken = value;
		}
		
		public function getUserSign():String
		{
			return this._profileModel.userSign;
		}
		
		public function setUserSign(value:String):void
		{
			this._profileModel.userSign = value;
		}
		
		public function getSign():String
		{
			return this._profileModel.sign;
		}
		
		public function setSign(value:String):void
		{
			this._profileModel.sign = value;
		}
		
		public function getServerID():String
		{
			return this._profileModel.serverID;
		}
		
		public function setServerID(value:String):void
		{
			this._profileModel.serverID = value;
		}
		
		public function getVersionSign():String
		{
			return this._profileModel.versionSign;
		}
		
		public function setVersionSign(value:String):void
		{
			this._profileModel.versionSign = value;
		}
	
	}

}