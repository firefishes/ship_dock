package notices {
	
	import command.CommandName;
	import shipDock.framework.core.notice.Notice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightViewNotice extends Notice 
	{
		
		public static const START_FIGHT_NOTICE:String = "startFightNotice";
		public static const FIGHTING_NOTICE:String = "fightingNotice";
		public static const FIGHT_END_NOTICE:String = "fightEndNotice";
		
		public static const SHOW_START_TO_VIEW_NOTICE:String = "showStartToViewNotice";//引入两个新消息，用于和界面通信
		public static const SHOW_END_TO_VIEW_NOTICE:String = "showEndToViewNotice";
		
		/**
		 * 不同于单纯的消息类，如果消息类需要传递到命令类中，表示此消息为对应命令类的专用消息类，
		 * 就需要将消息名设置为命令名，并在消息被发送后能传递到准确的命令对象里，
		 * 进入命令对象后通过subCommand 属性查找对应的子命令
		 * 
		 * @param
		 */
		public function FightViewNotice(subCommand:String, data:* = null) 
		{
			super(CommandName.FIGHT_VIEW_COMMAND/*将消息名设置为命令名*/, data);
			
			this.subCommand = subCommand;//设置子命令名
			
		}
		
	}

}