package command 
{
	import notices.fightData.FightScoreNotice;
	import notices.FightViewNotice;
	import shipDock.framework.core.command.Command;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightViewCommand extends Command 
	{
		
		public static const START_FIGHT_COMMAND:String = "startFightCommand";
		public static const FIGHTING_COMMAND:String = "fightingCommand";
		public static const FIGHT_END_COMMAND:String = "fightEndCommand";
		
		/**
		 * 默认开启命令的子命令模式，开启此模式后的命令类收到消息会根据消息的子命令名执行对应的方法
		 * 
		 * @param	isAutoExecute
		 */
		public function FightViewCommand(isAutoExecute:Boolean = true) 
		{
			super(isAutoExecute);
			
		}
		
		public function startFightCommand(notice:FightViewNotice):void {
			this.sendNotice(new FightViewNotice(FightViewNotice.START_FIGHT_NOTICE));
		}
		
		public function fightingCommand(notice:FightViewNotice):void {
			var value:int = 30 * Math.random();
			this.sendNotice(new FightScoreNotice(value));//修改数据
		}
		
		public function fightEndCommand(notice:FightViewNotice):void {
			this.sendNotice(new FightViewNotice(FightViewNotice.FIGHT_END_NOTICE));
		}
		
	}

}