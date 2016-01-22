package action 
{
	import command.MakerViewCommand;
	import data.PlanMakerData;
	import notices.NoticeName;
	import shipDock.framework.core.action.Action;
	import shipDock.framework.core.observer.DataProxy;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class MakerViewAction extends Action 
	{
		
		public function MakerViewAction() 
		{
			super();
			
		}
		
		public function initPlanMakerData(result:Object):void {
			var planMakerData:PlanMakerData = DataProxy.getDataProxy(PlanMakerData.PLAN_MAKER_DATA);
			planMakerData.setPlanData(result);
		}
		
		public function getPlanViewData(planIndex:int):Object {
			return (this.getDataProxy(PlanMakerData.PLAN_MAKER_DATA) as PlanMakerData).getPlanDataForShow(planIndex);
		}
		
		override protected function setCommand():void 
		{
			super.setCommand();
			
			this.registered(NoticeName.MAKER_VIEW_NOTICE, MakerViewCommand);
		}
	}

}