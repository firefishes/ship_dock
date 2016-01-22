package data 
{
	import flash.geom.Rectangle;
	import model.PlanModel;
	import shipDock.framework.core.observer.DataProxy;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class PlanMakerData extends DataProxy 
	{
		
		public static const PLAN_MAKER_DATA:String = "planMakerData";
		
		private var _planModel:PlanModel;
		
		public function PlanMakerData() 
		{
			super(PLAN_MAKER_DATA);
			
		}
		
		public function setPlanData(value:Object):void {
			this._planModel = new PlanModel(value);
		}
		
		public function getPlanData(planIndex:int):Object {
			return this._planModel.getPlanView(planIndex);
		}
		
		public function getPlanDataForShow(index:int):Object {
			var name:String = index + "";
			var bg:String = this._planModel.getViewBg(name);
			var asset:Array = this._planModel.getViewAsset(name);
			var configName:String = this._planModel.getViewConfigName(name);
			return {"config":configName, "asset":asset, "bg":bg};
		}
		
		public function getPlanDecsSize(planIndex:int, name:String):Rectangle {
			var decsData:Object = this._planModel.getDecsByPlanName(planIndex);
			var decs:Object = decsData[name];
			var result:Rectangle;
			if (decs != null) {
				var w:Number, h:Number;
				if (decs.hasOwnProperty("w"))
					w = decs["w"];
				else 
					w = 700;
				if (decs.hasOwnProperty("h"))
					h = decs["h"];
				else
					h = 640;
				
				result = new Rectangle(0, 0, w, h);
			}
			return result;
		}
		
		public function getViewPlanDecsPath(planName:String, index:int, name:String):String {
			return this._planModel.getViewPlanDecsPath(planName, index, name);
		}
	}

}