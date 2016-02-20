package command 
{
	import action.AIRMainAction;
	import shipDock.framework.core.interfaces.INotice;
	
	import notices.SDANotice;
	
	import shipDock.framework.core.action.SDAction;
	import shipDock.framework.core.command.Command;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRCommand extends Command 
	{
		
		public static const GET_AIR_CONFIG_COMMAND:String = "getAIRConfigCommand";
		public static const RELOAD_CONFIG_COMMAND:String = "reloadConfigCommand";
		public static const SHOW_TEXT_COMMAND:String = "showTextCommand";
		public static const CLEAN_SDAIR_SCRIPT_COMMAND:String = "cleanSDAIRScriptCommand";
		
		public function AIRCommand() 
		{
			super();
		}
		
		public function getAIRConfigCommand(notice:SDANotice):* {
			var key:String = notice.data;
			return this.AIRAction.getAIRAppConfig(key);
		}
		
		public function reloadConfigCommand(notice:SDANotice):void {
			//this.AIRAction.registered();
			this.AIRAction.restart(false);
		}
		
		public function showTextCommand(message:INotice):void {
			this.AIRAction.callProxyed("showTextContent", message.data, false);
		}
		
		public function cleanSDAIRScriptCommand(message:INotice):void {
			this.AIRAction.callProxyed("cleanSDAIRScript", null, false);
		}
		
		private function get AIRAction():AIRMainAction {
			return this.action as AIRMainAction;
		}
	}

}