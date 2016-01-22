package data 
{
	import command.FightViewCommand;
	import notices.NoticeName;
	import model.FightModel;
	import notices.FightViewNotice;
	import shipDock.framework.core.notice.Notice;
	import shipDock.framework.core.observer.DataProxy;
	
	/**
	 * 战斗数据代理
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightDataProxy extends DataProxy 
	{
		
		public static const PROXY_NAME:String = "FightDataProxy";
		
		private var _fightDataModel:FightModel;
		
		public function FightDataProxy(name:String=null) 
		{
			super(PROXY_NAME);
			
			this._fightDataModel = new FightModel();
		}
		
		public function resetFightData():void {
			this.updateScore(0);
			this._fightDataModel.isFightOver = false;
		}
		
		public function updateScore(add:int):void {
			this._fightDataModel.score += add;
			this.checkEnd();
			if (!this._fightDataModel.isFightOver) {
				var updateScoreNotice:Notice = new Notice(NoticeName.FIGHT_SCORE_UPDATE, this._fightDataModel.score);
				this.notify(updateScoreNotice);
			}
		}
		
		/**
		 * 判断战斗是否结束
		 * 
		 */
		private function checkEnd():void {
			if (this.getScore() > 100) {//判断分数是否达到结束条件
				this._fightDataModel.isFightOver = true;
				
				var notice:FightViewNotice = new FightViewNotice(null);
				notice.sendSelf(this, FightViewCommand.FIGHT_END_COMMAND);//通知战斗界面战斗结束
				
				var fightEndNotice:Notice = new Notice(NoticeName.FIGHT_END);
				this.notify(fightEndNotice);//通知所有感兴趣的对象战斗结束
			}
		}
		
		public function getScore():int {
			return this._fightDataModel.score;
		}
		
		public function isFightOver():Boolean {
			return this._fightDataModel.isFightOver;
		}
		
	}

}