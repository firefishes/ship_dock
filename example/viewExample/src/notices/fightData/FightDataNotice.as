package notices.fightData {
	
	import command.CommandName;
	import shipDock.framework.core.notice.Notice;
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightDataNotice extends Notice 
	{
		
		public function FightDataNotice(subCommand:String, data:* = null) 
		{
			super(CommandName.FIGHT_DATA_COMMAND, data);
			this.subCommand = subCommand;
		}
		
	}

}