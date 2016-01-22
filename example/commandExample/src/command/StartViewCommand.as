package command 
{
	import notices.StartViewNotice;
	import shipDock.framework.core.command.Command;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.notice.CallProxyedNotice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class StartViewCommand extends Command 
	{
		
		public static const SHOW_SCORE_COMMAND:String = "showScoreCommand";
		
		public function StartViewCommand() 
		{
			super(false);//传入false, 试试非自动方法模式是什么样的
			
		}
		
		/**
		 * 非子命令模式需要覆盖这个方法，并把这里作为逻辑的中转
		 * 
		 * @param	notice
		 * @return
		 */
		override public function execute(notice:INotice):* 
		{
			var result:* = super.execute(notice);
			
			switch(notice.subCommand) {
				case SHOW_SCORE_COMMAND:
					this.showScore(notice as StartViewNotice);
					break;
			}
			return result;
		}
		
		public function showScore(notice:StartViewNotice):void {
			
			//=================================
			//这里可以加其他的业务逻辑……
			//=================================
			
			//接着将整个消息对象作为参数抛给被代理的对象，即界面，也可以说是消息真正的接收者
			//第一种发送方式
			
			this.sendNotice(new CallProxyedNotice(StartViewNotice.SHOW_SCORE_NOTICE, notice.score));
			
			//第二种发送方式，使用缓存形式，节省创建对象时的性能开销
			//第三个参数传递true则表示新建一个CallProxyedNotice对象，而不使用缓存，即便如此，对象数量也是可控的
			//这里的 action 即使注册了此命令类的逻辑代理对象
			
			//this.action.callProxyed(StartViewNotice.SHOW_SCORE_NOTICE, notice/*, true*/);
		}
	}

}