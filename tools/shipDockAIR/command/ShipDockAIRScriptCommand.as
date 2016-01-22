package command
{
	import notices.SDANotice;
	import notices.SDAScriptNotice;
	
	import shipDock.framework.core.command.Command;
	
	public class ShipDockAIRScriptCommand extends Command
	{
		
		public static const SDA_SCRIPT_NORMAL_COMMAND:String = "SDAScriptNormalCommand";
		
		public function ShipDockAIRScriptCommand(isAutoExecute:Boolean=true)
		{
			super(isAutoExecute);
		}
		
		public function SDAScriptNormalCommand(notice:SDAScriptNotice):void {
			var script:String = notice.script;
			script = script.replace("\r", "");
			if(!script)
				return;
			var config:Object = this.sendNotice(new SDANotice(AIRCommand.GET_AIR_CONFIG_COMMAND, "scrips"));
			if(config[script]) {
				var subCommand:String;
				if(config[script] is Array) {
					var list:Array = config[script];
					while(list.length > 0) {
						subCommand = list.shift();
						this.sendNotice(new SDANotice(subCommand, null));
					}
				}else if(config[script] is String) {
					this.sendNotice(new SDANotice(config[script], null));
				}
			}
		}
	}
}