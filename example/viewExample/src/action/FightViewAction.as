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
	import shipDock.framework.application.SDCore;
	import shipDock.framework.core.action.Action;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightViewAction extends Action 
	{
		
		public function FightViewAction() 
		{
			super();
			
			this.addNotice(FightViewNotice.START_FIGHT_NOTICE, startFight);
			this.addNotice(FightViewNotice.FIGHT_END_NOTICE, fightEnd);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			this.removeNotice(FightViewNotice.START_FIGHT_NOTICE, startFight);
			this.removeNotice(FightViewNotice.FIGHT_END_NOTICE, fightEnd);
		}
		
		/**
		 * 设置逻辑代理感兴趣的命令模块，此方法会在逻辑代理类被实例化的时候自动调用
		 * 
		 */
		override protected function setCommand():void 
		{
			super.setCommand();
			
			this.registered(CommandName.FIGHT_VIEW_COMMAND, FightViewCommand);
		}
		
		/**
		 * 开始战斗
		 * 
		 * @param	notice
		 */
		private function startFight(notice:FightViewNotice):void {
			
			this.callProxyed(FightViewNotice.SHOW_START_TO_VIEW_NOTICE);//通知界面显示开始战斗
			
			this.fighting();
		}
		
		/**
		 * 战斗中
		 * 
		 */
		private function fighting():void {
			if (this.isFightOver) {
				return;
			}
			SDCore.getInstance().juggler.delayCall(this.fighting, 1);
			
			this.sendNotice(new FightViewNotice(FightViewCommand.FIGHTING_COMMAND));
			
			var score:int = this.sendNotice(new FightDataNotice(FightDataCommand.GET_SCORE_COMMAND));//获取最新数据
			if (!this.isFightOver) {
				
				var startViewNotice:StartViewNotice = new StartViewNotice(CommandName.START_VIEW_COMMAND, score);
				startViewNotice.subCommand = StartViewCommand.SHOW_SCORE_COMMAND;
				this.sendNotice(startViewNotice);//通知开始界面更新显示
				
				//或者这样调用也可以通知开始界面更新显示
				//this.callProxyed(StartViewNotice.SHOW_SCORE_NOTICE, score);
			}
		}
		
		/**
		 * 战斗结束
		 * 
		 * @param	notice
		 */
		private function fightEnd(notice:FightViewNotice):void {
			if (this.isFightOver) {
				this.callProxyed(FightViewNotice.SHOW_END_TO_VIEW_NOTICE);//通知界面显示开始结束
			}
		}
		
		private function get isFightOver():Boolean {
			return this.sendNotice(new FightDataNotice(FightDataCommand.GET_FIGHT_OVER_COMMAND));
		}
	}

}