package notices.fightData {
	import command.FightDataCommand;
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightScoreNotice extends FightDataNotice 
	{
		
		public function FightScoreNotice(score:int) 
		{
			super(FightDataCommand.CHANGE_SCORE_COMMAND, {"s":score});
			
		}
		
		public function get score():int {
			return this.data["s"];
		}
		
	}

}