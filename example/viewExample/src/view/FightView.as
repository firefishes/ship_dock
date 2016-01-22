package view
{
	import action.FightViewAction;
	import notices.FightViewNotice;
	import notices.StartViewNotice;
	import shipDock.framework.core.notice.CallProxyedNotice;
	import shipDock.ui.View;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightView extends View 
	{
		
		public function FightView() 
		{
			super(null, null);
			this._hasUIConfig = false;//定义视图界面为没有界面配置
			
		}
		
		override protected function addEvents():void 
		{
			super.addEvents();
			
			this.addNotice(FightViewNotice.SHOW_START_TO_VIEW_NOTICE, this.showStart);
			this.addNotice(FightViewNotice.SHOW_END_TO_VIEW_NOTICE, this.showEnd);
		}
		
		override protected function removeEvents():void 
		{
			super.removeEvents();
			
			this.removeNotice(FightViewNotice.SHOW_START_TO_VIEW_NOTICE, this.showStart);
			this.removeNotice(FightViewNotice.SHOW_END_TO_VIEW_NOTICE, this.showEnd);
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			this.setAction(new FightViewAction());
		}
		
		private function showStart(notice:CallProxyedNotice):void {
			trace("战斗开始！");
		}
		
		private function showEnd(notice:CallProxyedNotice):void {
			trace("游戏结束!");
		}
		
		private function get fightViewAction():FightViewAction {
			return this.action as FightViewAction;
		}
	}

}