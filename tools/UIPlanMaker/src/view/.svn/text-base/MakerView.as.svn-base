package view 
{
	import action.MakerViewAction;
	import notices.NoticeName;
	import notices.ShowPlanViewNotice;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.notice.CallProxyedNotice;
	import shipDock.ui.View;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class MakerView extends View 
	{
		private var _currentBg:String;
		private var _currentAssetList:Array;
		private var _currentConfigName:String;
		private var _currentPlanView:UIPlanView;
		
		public function MakerView() 
		{
			super(null, [["makerSkin"]]);
			this._UIConfigName = "makerView";
		}
		
		override protected function addEvents():void 
		{
			super.addEvents();
			
			this.addNotice(NoticeName.SHOW_PLAN_VIEW_NOTICE, this.showPlanView);
		}
		
		override protected function removeEvents():void 
		{
			super.removeEvents();
			
			this.removeNotice(NoticeName.SHOW_PLAN_VIEW_NOTICE, this.showPlanView);
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			this.setAction(new MakerViewAction());
			
			this.changeProperty("planType", 0);
			
			if (this._currentPlanView == null) {
				var dataLoader:DataLoader = ObjectPoolManager.getInstance().fromPool(DataLoader, Setting.FILE_ASSET + "plan/startUp.json");
				dataLoader.complete = this.initPlanView;
				
				this.changeProperty("startUpJSON", dataLoader);
				dataLoader.commit();
			}
			
		}
		
		private function initPlanView(result:Object):void {
			var dataLoader:DataLoader = this.getPropertyChanged("startUpJSON");
			ObjectPoolManager.getInstance().toPool(dataLoader);
			
			this.changeProperty("planName", result["name"]);
			this.changeProperty("planIndex", 0);
			
			this.makerViewAction.initPlanMakerData(result);
			this.sendNotice(new ShowPlanViewNotice(0));
		}
		
		private function showPlanView(notice:CallProxyedNotice):void {
			var params:ShowPlanViewNotice = notice.data;
			this.changeProperty("planType", params.planType);
			
			this._currentBg = params.bg;
			this._currentAssetList = params.assets;
			this._currentConfigName = params.viewConfigName;
			if (this._currentPlanView != null) {
				this._currentPlanView.removeFromParent(true);
			}
			
			this._currentPlanView = new UIPlanView(this._currentAssetList, this._currentConfigName, this._currentBg);
			this._currentPlanView.name = this.planName;
			this._currentPlanView.data = {"planIndex":this.planIndex};
			this.putChildraw(this._currentPlanView, "currentPlanView");
			this.getEmptySpriteUI("makerContainer").addChild(this._currentPlanView as DisplayObject);
			this.getButtonUI("levelBtn").visible = false;
			this.getButtonUI("structBtn").visible = false;
		}
		
		private function get makerViewAction():MakerViewAction {
			return this.action as MakerViewAction;
		}
		
		private function get planName():String {
			return this.getPropertyChanged("planName");
		}
		
		private function get planIndex():int {
			return int(this.getPropertyChanged("planIndex"));
		}
	}

}