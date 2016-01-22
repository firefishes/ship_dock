package action
{
	import command.StartViewCommand;
	import notices.FightViewNotice;
	import notices.NoticeName;
	import command.FightDataCommand;
	import command.FightViewCommand;
	import data.FightDataProxy;
	import notices.fightData.FightDataNotice;
	import notices.StartViewNotice;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.core.action.Action;
	import shipDock.framework.core.interfaces.INotice;
	
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
			
			this.unbindDataProxy(FightDataProxy.PROXY_NAME); //销毁时退订数据代理的变化
		}
		
		/**
		 * 设置逻辑代理感兴趣的命令模块，此方法会在逻辑代理类被实例化的时候自动调用
		 *
		 */
		override protected function setCommand():void
		{
			super.setCommand();
			
			this.registered(NoticeName.FIGHT_VIEW, FightViewCommand);
			
			this.bindDataProxy(FightDataProxy.PROXY_NAME); //订阅数据代理的变化
		}
		
		override public function notify(notice:INotice):*
		{
			if (notice.name == NoticeName.FIGHT_SCORE_UPDATE)
			{
				
				var startViewNotice:StartViewNotice = new StartViewNotice(NoticeName.START_VIEW, notice.data);
				startViewNotice.subCommand = StartViewCommand.SHOW_SCORE_COMMAND;
				this.sendNotice(startViewNotice); //通知开始界面更新显示
				
					//或者这样调用也可以通知开始界面更新显示
					//this.callProxyed(StartViewNotice.SHOW_SCORE_NOTICE, score);
			}
			return null;
		}
		
		/**
		 * 开始战斗
		 *
		 * @param	notice
		 */
		private function startFight(notice:FightViewNotice):void
		{
			
			this.callProxyed(FightViewNotice.SHOW_START_TO_VIEW_NOTICE); //通知界面显示开始战斗
			
			this.fighting();
		}
		
		/**
		 * 战斗中
		 *
		 */
		private function fighting():void
		{
			if (this.isFightOver)
			{
				return;
			}
			SDCore.getInstance().juggler.delayCall(this.fighting, 1);
			
			this.sendNotice(new FightViewNotice(FightViewCommand.FIGHTING_COMMAND));
		}
		
		/**
		 * 战斗结束
		 *
		 * @param	notice
		 */
		private function fightEnd(notice:FightViewNotice):void
		{
			if (this.isFightOver)
			{
				this.callProxyed(FightViewNotice.SHOW_END_TO_VIEW_NOTICE); //通知界面显示开始结束
			}
		}
		
		private function get isFightOver():Boolean
		{
			return this.sendNotice(new FightDataNotice(FightDataCommand.GET_FIGHT_OVER_COMMAND));
		}
	}

}