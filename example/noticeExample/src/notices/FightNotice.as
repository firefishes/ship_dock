package notices {
	import shipDock.framework.core.notice.Notice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightNotice extends Notice 
	{
		
		public static const START_FIGHT_NOTICE:String = "startFightNotice";
		public static const FIGHT_END_NOTICE:String = "fightEndNotice";
		
		public function FightNotice(name:String) 
		{
			super(name);
			
		}
		
	}

}