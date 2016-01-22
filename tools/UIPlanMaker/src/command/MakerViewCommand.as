package command 
{
	import data.PlanMakerData;
	import notices.NoticeName;
	import notices.ShowPlanViewNotice;
	import shipDock.framework.core.command.Command;
	import shipDock.framework.core.observer.DataProxy;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class MakerViewCommand extends Command 
	{
		
		public static const SHOW_PLAN_VIEW_COMMAND:String = "showPlanViewCommand";
		
		public function MakerViewCommand(isAutoExecute:Boolean=true) 
		{
			super(isAutoExecute);
			
		}
		
		public function showPlanViewCommand(notice:ShowPlanViewNotice):void {
			var result:Object = makerData.getPlanDataForShow(notice.viewIndex);
			notice.bg = result["bg"];
			notice.assets = result["asset"];
			notice.viewConfigName = result["config"];
			this.action.callProxyed(NoticeName.SHOW_PLAN_VIEW_NOTICE, notice);
		}
		
		private function get makerData():PlanMakerData {
			return DataProxy.getDataProxy(PlanMakerData.PLAN_MAKER_DATA);
		}
	}

}