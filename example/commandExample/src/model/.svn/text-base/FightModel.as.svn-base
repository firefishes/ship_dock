package model 
{
	import shipDock.framework.core.model.DataModel;
	
	/**
	 * 战斗数据
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class FightModel extends DataModel 
	{
		
		private var _score:int;//战斗数据
		private var _isFightOver:Boolean;//战斗是否结束
		
		public function FightModel() 
		{
			super();
			
		}
		
		override public function updateData(data:Object):void 
		{
			super.updateData(data);
			
			this.checkAndSet("score", "score", data);
			this.checkAndSet("isFightOver", "isFightOver", data);
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function set score(value:int):void 
		{
			_score = value;
		}
		
		public function get isFightOver():Boolean 
		{
			return _isFightOver;
		}
		
		public function set isFightOver(value:Boolean):void 
		{
			_isFightOver = value;
		}
		
		
	}

}