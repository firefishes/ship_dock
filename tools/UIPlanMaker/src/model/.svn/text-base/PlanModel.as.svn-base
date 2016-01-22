package model 
{
	import flash.geom.Rectangle;
	import shipDock.framework.core.model.DataModel;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class PlanModel extends DataModel 
	{
		
		private var _planConfig:Object;
		
		public function PlanModel(data:Object) 
		{
			super();
			this.updateData(data);
		}
		
		override public function updateData(data:Object):void 
		{
			super.updateData(data);
			this._planConfig = data;
		}
		
		public function get plan():Object {
			return this._planConfig["plan"];
		}
		
		public function getPlanView(index:*):Object {
			if (index is Number)
				index = String(index);
			return this.plan[index];
		}
		
		public function getViewConfigName(name:String):String {
			return this.getPlanView(name)["viewConfig"];
		}
		
		public function getViewAsset(name:String):Array {
			return this.getPlanView(name)["assets"];
		}
		
		public function getViewBg(name:String):String {
			return this.getPlanView(name)["bg"];
		}
		
		public function getDecs():Object {
			return this._planConfig["decs"];
		}
		
		public function getDecsByPlanName(index:int):Object {
			return this.getDecs()[index + ""];
		}
		
		public function getViewPlanDecsPath(planName:String, index:int, name:String):String {
			var result:String;
			var decsData:Object = this.getDecsByPlanName(index);
			if (decsData[name] != null) {
				var decsName:String = decsData[name]["decs"];
				result = Setting.FILE_ASSET + Setting.FILE_PLAN + planName + "/" + decsName + ".txt";
			}
			return result;
		}
	}

}