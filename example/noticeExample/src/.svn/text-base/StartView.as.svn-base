package  
{
	import notices.FightNotice;
	import notices.StartViewNotice;
	import shipDock.ui.View;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class StartView extends View 
	{
		
		private var _score:int = 0;
		
		public function StartView() 
		{
			super(null, null);
			this._hasUIConfig = true;//不使用视图界面配置
		}
		
		override protected function setViewConfig():void 
		{
			super.setViewConfig();
			
			this._UIConfigName = "startView";
		}
		
		override protected function disposeView():void 
		{
			super.disposeView();
			
		}
		
		override protected function addEvents():void 
		{
			super.addEvents();
			
			this.addNotice(StartViewNotice.SHOW_SCORE_NOTIcE, this.showScore);
		}
		
		override protected function removeEvents():void 
		{
			super.removeEvents();
			
			this.removeNotice(StartViewNotice.SHOW_SCORE_NOTIcE, this.showScore);
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			var fightView:FightView = new FightView();
			this.addChild(fightView);
			this.childrenRaw.put("fightView", fightView);//加入子对象集合，在开始界面移除后自动销毁
			
			fightView.creationComplete = this.startFight;//设置战斗界面就绪后的回调函数
		}
		
		private function startFight():void {
			this.sendNotice(new FightNotice(FightNotice.START_FIGHT_NOTICE));//触发开始战斗
		}
		
		/**
		 * 显示分数
		 * 
		 * @param	notice
		 */
		private function showScore(n:StartViewNotice):void {
			
			this._score += int(n.data);
			//this._score += int(n.score);//使用简化参数的形式，请打开StartViewNotice的构造函数2 的注释
			
			trace("当前得分:" + this._score);
			
			if (this._score > 100) {//判断分数是否达到结束条件
				this.sendNotice(new FightNotice(FightNotice.FIGHT_END_NOTICE));//通知战斗界面战斗结束
			}
		}
		
	}

}