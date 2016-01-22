package view
{
	import action.StartViewAction;
	import notices.FightViewNotice;
	import notices.StartViewNotice;
	import shipDock.framework.core.notice.CallProxyedNotice;
	import shipDock.ui.View;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class StartView extends View 
	{
		
		public function StartView() 
		{
			super(null, null);
			this._hasUIConfig = false;//定义视图界面为没有界面配置
		}
		
		override protected function addEvents():void 
		{
			super.addEvents();
			
			this.addNotice(StartViewNotice.SHOW_SCORE_NOTICE, this.showScoreToView);
		}
		
		override protected function removeEvents():void 
		{
			super.removeEvents();
			
			this.removeNotice(StartViewNotice.SHOW_SCORE_NOTICE, this.showScoreToView);
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			this.setAction(new StartViewAction());
			
			var fightView:FightView = new FightView();
			this.addChild(fightView);
			this.childrenRaw.put("fightView", fightView);//加入子对象集合，在开始界面移除后自动销毁
			
			fightView.creationComplete = this.startViewAction.start;//设置战斗界面就绪后的回调函数
		}
		
		/**
		 * 显示分数
		 * 
		 * @param notice 注意：界面接收的参数统一为 CallProxyedNotice 一种类型，减少了界面的在封装逻辑时的参数变化
		 */
		private function showScoreToView(notice:CallProxyedNotice):void {
			trace("当前得分:" + int(notice.data));
		}
		
		private function get startViewAction():StartViewAction {
			return this.action as StartViewAction;
		}
	}

}