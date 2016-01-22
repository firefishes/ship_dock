package command 
{
	import data.DataProxyName;
	import data.FightDataProxy;
	import notices.fightData.FightDataNotice;
	import notices.fightData.FightScoreNotice;
	import notices.FightViewNotice;
	import shipDock.framework.core.command.Command;
	import shipDock.framework.core.observer.DataProxy;
	
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
		public static const GET_FIGHT_OVER_COMMAND:String = "getFightOverCommand";
		
		private var _fightDataProxy:FightDataProxy;
		
		public function FightDataCommand(isAutoExecute:Boolean=true) 
		{
			super(isAutoExecute);//自动方法模式
			this._fightDataProxy = DataProxy.getDataProxy(FightDataProxy.PROXY_NAME);
		}
		
		override public function resetPoolObject():void 
		{
			super.resetPoolObject();
		}
		
		/**
		 * 重置战斗数据
		 * 
		 * @param	notice
		 */
		public function resetDataCommand(notice:FightDataNotice):void {
			this._fightDataProxy.resetFightData();
		}
		
		/**
		 * 获取战斗数据
		 * 
		 * @param	notice
		 * @return
		 */
		public function getScoreCommand(notice:FightDataNotice):int {
			return this._fightDataProxy.getScore();
		}
		
		/**
		 * 修改战斗数据
		 * 
		 * @param	notice
		 */
		public function changeScoreCommand(notice:FightScoreNotice):void {
			this._fightDataProxy.updateScore(notice.score);
		}
		
		/**
		 * 获取是否战斗结束属性
		 * 
		 * @param	notice
		 * @return
		 */
		public function getFightOverCommand(notice:FightDataNotice):Boolean {
			return this._fightDataProxy.isFightOver();
		}
		
	}

}