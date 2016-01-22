package action 
{
	import data.PlanMakerData;
	import flash.geom.Rectangle;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.loader.LoadType;
	import shipDock.framework.core.action.Action;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.methodExecuter.MethodCenter;
	import shipDock.framework.core.observer.DataProxy;
	
	/**
	 * ...
	 * @author ch.ji
	 */
	public class UIPlanViewAction extends Action 
	{
		
		private var _callbacks:MethodCenter;
		
		public function UIPlanViewAction(name:String=null) 
		{
			super(name);
			this._callbacks = new MethodCenter();
		}
		
		public function getUIDecsSize(planIndex:int, name:String):Rectangle {
			var planMakerData:PlanMakerData = this.getDataProxy(PlanMakerData.PLAN_MAKER_DATA) as PlanMakerData;
			return planMakerData.getPlanDecsSize(planIndex, name);
		}
		
		public function getUIDecs(planName:String, index:int, name:String, callback:Function):DataLoader {
			var dataLoader:DataLoader;
			var planMakerData:PlanMakerData = DataProxy.getDataProxy(PlanMakerData.PLAN_MAKER_DATA);
			var path:String = planMakerData.getViewPlanDecsPath(planName, index, name);
			if (path != null) {
				dataLoader = ObjectPoolManager.getInstance().fromPool(DataLoader, path, callback);
				dataLoader.isAutoQueueNext = true;
				dataLoader.completeParams = [dataLoader, name];
				dataLoader.loadType = LoadType.LOAD_TYPE_TEXT;
			}
			return dataLoader;
		}
	}

}