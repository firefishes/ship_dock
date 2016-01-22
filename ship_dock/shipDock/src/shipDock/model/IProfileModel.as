package shipDock.model 
{
	
	/**
	 * 用户数据模型对象接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IProfileModel 
	{
		
		function get token():String;
		function set token(value:String):void;
		function get platform():String;
		function set platform(value:String):void;
		function get deviceType():String;
		function set deviceType(value:String):void;
		function get deviceID():String;
		function set deviceID(value:String):void;
		function get appVersion():String;
		function set appVersion(value:String):void;
		function get userToken():String;
		function set userToken(value:String):void;
		function get userSign():String;
		function set userSign(value:String):void;
		function get sign():String;
		function set sign(value:String):void;
		function get serverID():String;
		function set serverID(value:String):void;
		function get versionSign():String;
		function set versionSign(value:String):void;
	}
	
}