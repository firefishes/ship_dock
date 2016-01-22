package shipDock.data 
{
	
	/**
	 * 用户数据代理接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IProfileProxy 
	{
		function getToken():String;
		function setToken(value:String):void;
		function getPlatform():String;
		function setPlatform(value:String):void;
		function getDeviceType():String;
		function setDeviceType(value:String):void;
		function getDeviceID():String;
		function setDeviceID(value:String):void;
		function getAppVersion():String;
		function setAppVersion(value:String):void;
		function getUserToken():String;
		function setUserToken(value:String):void;
		function getUserSign():String;
		function setUserSign(value:String):void;
		function getSign():String;
		function setSign(value:String):void;
		function getServerID():String;
		function setServerID(value:String):void;
		function getVersionSign():String;
		function setVersionSign(value:String):void;
	}
	
}