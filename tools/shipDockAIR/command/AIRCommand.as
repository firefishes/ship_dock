package command 
{
	import action.AIRMainAction;
	
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
		public static const CREATE_MAP_COMMAND:String = "createMapCommand";
		
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
		}
		
		public function createMapCommand(notice:SDANotice):void {
			
		}
		
		private function get AIRAction():AIRMainAction {
			return this.action as AIRMainAction;
		}
	}

}