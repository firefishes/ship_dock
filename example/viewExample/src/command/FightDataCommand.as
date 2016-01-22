package command 
{
	import notices.fightData.FightDataNotice;
	import notices.fightData.FightScoreNotice;
	import notices.FightViewNotice;
	import shipDock.framework.core.command.Command;
	
	/**
	 * 数据操作命令类
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightDataCommand extends Command 
	{
		
		public static const RESET_DATA_COMMAND:String = "resetDataCommand";
		public static const GET_SCORE_COMMAND:String = "getScoreCommand";
		public static const CHANGE_SCORE_COMMAND:String = "changeScoreCommand";
		public static const SET_FIGHT_OVER_COMMAND:String = "setFightOverCommand";
		public static const GET_FIGHT_OVER_COMMAND:String = "getFightOverCommand";
		
		private var _score:int;//战斗数据
		private var _isFightOver:Boolean;//战斗是否结束
		
		public function FightDataCommand(isAutoExecute:Boolean=true) 
		{
			super(isAutoExecute);//自动方法模式
			
		}
		
		/**
		 * 重置战斗数据
		 * 
		 * @param	notice
		 */
		public function resetDataCommand(notice:FightDataNotice):void {
			this._score = 0;
		}
		
		/**
		 * 获取战斗数据
		 * 
		 * @param	notice
		 * @return
		 */
		public function getScoreCommand(notice:FightDataNotice):int {
			return this._score;
		}
		
		/**
		 * 修改战斗数据
		 * 
		 * @param	notice
		 */
		public function changeScoreCommand(notice:FightScoreNotice):void {
			this._score += notice.score;
			this.checkEnd();
		}
		
		/**
		 * 判断战斗是否结束
		 * 
		 */
		private function checkEnd():void {
			if (this._score > 100) {//判断分数是否达到结束条件
				this._isFightOver = true;
				this.sendNotice(new FightViewNotice(FightViewCommand.FIGHT_END_COMMAND));//通知战斗界面战斗结束
			}
		}
		
		/**
		 * 设置是否战斗结束属性
		 * 
		 * @param	notice
		 */
		public function setFightOverCommand(notice:FightDataNotice):void {
			this._isFightOver = notice.data;
		}
		
		/**
		 * 获取是否战斗结束属性
		 * 
		 * @param	notice
		 * @return
		 */
		public function getFightOverCommand(notice:FightDataNotice):Boolean {
			return this._isFightOver;
		}
		
	}

}