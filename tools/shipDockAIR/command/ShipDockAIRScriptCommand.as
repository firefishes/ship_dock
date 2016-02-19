package command
{
	import notices.SDANotice;
	import notices.SDAScriptNotice;
	
	import shipDock.framework.core.command.Command;
	
	public class ShipDockAIRScriptCommand extends Command
	{
		
		public static const SDA_SCRIPT_NORMAL_COMMAND:String = "SDAScriptNormalCommand";
		
		public function ShipDockAIRScriptCommand(isAutoExecute:Boolean = true)
		{
			super(isAutoExecute);
		}
		
		public function SDAScriptNormalCommand(notice:SDAScriptNotice):void
		{
			var script:String = notice.script;
			script = script.replace("\r", "");
			if (!script)
				return;
			var config:Object = this.sendNotice(new SDANotice(AIRCommand.GET_AIR_CONFIG_COMMAND, "scripts"));
			script = script.replace(/\s*/g, "");
			var args:Object;
			var splits:Array = script.split("-");
			script = splits.shift();
			if (splits.length > 0) {
				args = { };
				var k:String, o:Array;
				for each(k in splits) {
					o = k.split("=");
					args[o[0]] = o[1];
				}
			}
			var item:* = config[script];
			if (item)
			{
				var subCommand:String;
				if (item is String)
				{
					subCommand = item;
					this.sendNotice(new SDANotice(subCommand, args));
				}
				else
				{
					if (item is Object)
						this.runNotice(item, args);
					else if (item is Array)
					{
						var list:Array = item as Array, itemEach:Object;
						while (list.length > 0)
						{
							itemEach = list.shift();
							(args) && (itemEach["args"] = args);
							this.runNotice(itemEach);
						}
					}
				}
			}
		}
		
		private function runNotice(item:Object, userArgs:Object = null):void
		{
			var args:Object = item["args"];
			var notice:String = item["notice"];
			var subCommand:String = item["subCommand"];
			(userArgs) && (args = userArgs);
			this.sendNotice(notice, args, subCommand);
		}
	}
}