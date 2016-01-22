package  
{
	import notices.FightNotice;
	import notices.StartViewNotice;
	import shipDock.framework.application.SDCore;
	import shipDock.ui.View;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightView extends View 
	{
		
		private var _isFightOver:Boolean;
		
		public function FightView() 
		{
			super(null, null);
			this._hasUIConfig = false;//定义视图界面为没有界面配置
			
		}
		
		override protected function addEvents():void 
		{
			super.addEvents();
			
			this.addNotice(FightNotice.START_FIGHT_NOTICE, startFight);
			this.addNotice(FightNotice.FIGHT_END_NOTICE, fightEnd);
		}
		
		override protected function removeEvents():void 
		{
			super.removeEvents();
			
			this.removeNotice(FightNotice.START_FIGHT_NOTICE, startFight);
			this.removeNotice(FightNotice.FIGHT_END_NOTICE, fightEnd);
		}
		
		override protected function createUI():void 
		{
			super.createUI();
		}
		
		private function startFight(notice:FightNotice):void {
			trace("战斗开始！");
			
			this.fighting();
		}
		
		private function fighting():void {
			if (this._isFightOver) {
				return;
			}
			SDCore.getInstance().juggler.delayCall(this.fighting, 1);
			
			var notice:StartViewNotice = new StartViewNotice(StartViewNotice.SHOW_SCORE_NOTIcE, 30 * Math.random());
			this.sendNotice(notice);
		}
		
		private function fightEnd(notice:FightNotice):void {
			this._isFightOver = true;
			if (this._isFightOver) {
				trace("游戏结束!");
			}
		}
	}

}