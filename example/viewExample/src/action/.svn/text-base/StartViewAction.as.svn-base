package action 
{
	import command.CommandName;
	import command.FightDataCommand;
	import command.FightViewCommand;
	import command.StartViewCommand;
	import notices.fightData.FightDataNotice;
	import notices.fightData.FightScoreNotice;
	import notices.FightViewNotice;
	import notices.StartViewNotice;
	import shipDock.framework.core.action.Action;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class StartViewAction extends Action 
	{
		
		public function StartViewAction() 
		{
			super();
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		/**
		 * 设置逻辑代理感兴趣的命令模块，此方法会在逻辑代理类被实例化的时候自动调用
		 * 
		 */
		override protected function setCommand():void 
		{
			super.setCommand();
			
			//注册命令模块的时候，需要使用字符串、或字符串常量和他们一一对应
			this.registered(CommandName.START_VIEW_COMMAND, StartViewCommand);
			this.registered(CommandName.FIGHT_DATA_COMMAND, FightDataCommand);
			
		}
		
		/**
		 * 将功能放入逻辑代理类中
		 * 
		 */
		public function start():void {
			this.sendNotice(new FightDataNotice(FightDataCommand.RESET_DATA_COMMAND));//重置数据
			this.sendNotice(new FightViewNotice(FightViewCommand.START_FIGHT_COMMAND));//触发开始战斗
		}
		
	}

}