package notices {
	
	import command.CommandName;
	import shipDock.framework.core.notice.Notice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class StartViewNotice extends Notice 
	{
		
		public static const SHOW_SCORE_NOTICE:String = "showScoreNotice";//这里的常量仍然归消息接收者使用
		
		/**
		 * 因为此消息并非专为命令对象设计，所以不需要指定命令名作为消息名
		 * 且不用设置 subCommand 属性
		 * 
		 * @param	name
		 * @param	score
		 */
		public function StartViewNotice(name:String, score:int = 0) 
		{
			super(name, { "s":score } );
		}
		
		public function get score():int {
			return this.data["s"];
		}
	}

}