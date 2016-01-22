package view 
{
	import action.UIPlanViewAction;
	import data.PlanMakerData;
	import flash.geom.Rectangle;
	import shipDock.framework.application.component.SDComponent;
	import shipDock.framework.application.loader.DataLoader;
	import shipDock.framework.application.manager.PopupManager;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.queueExecuter.QueueExecuter;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.TouchEvent;
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class UIPlanView extends UIPlanBaseView 
	{
		
		public function UIPlanView(assetList:Array=null, configUIName:String = null, bg:String = null) 
		{
			super(bg, assetList, configUIName);
			
		}
		
		override protected function removeEvents():void 
		{
			super.removeEvents();
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			this.setAction(new UIPlanViewAction());
			
			var queue:QueueExecuter = new QueueExecuter();
			this.changeProperty("loaderQueue", queue);
			for each(var k:* in this.childrenRaw.keys) {
				if (this.getChildraw(k) is Image) {
					var dataLoader:DataLoader = this.uiPlanViewAction.getUIDecs(this.name, this.data["planIndex"], k, this.initUIPlanDecs);
					if (dataLoader != null) {
						queue.add(dataLoader);
					}
				}
			}
			queue.add(this.loadFinish);
			queue.commit();
			
			this.setStaticTextValue("txt11", "multiLine", true);
			this.setStaticTextValue("txt12", "multiLine", true);
			this.commitStaticTextsChanged();
		}
		
		private function loadFinish():void {
			var queue:QueueExecuter = this.getPropertyChanged("loaderQueue");
			queue.dispose();
		}
		
		private function initUIPlanDecs(result:Object, dataLoader:DataLoader, name:String):void {
			
			this.changeProperty(name + "UIDecs", result);
			
			var child:EventDispatcher = this.getChildraw(name) as EventDispatcher;
			child.addEventListener(TouchEvent.TOUCH, this.showUIDecs);
			
			ObjectPoolManager.getInstance().toPool(dataLoader);
			
		}
		
		private function showUIDecs(event:TouchEvent):void {
			if (SDComponent.touchCheck(event)) {
				var name:String = (event.target as DisplayObject).name;
				var content:String = this.getPropertyChanged(name + "UIDecs");
				
				var rect:Rectangle = this.uiPlanViewAction.getUIDecsSize(this.planIndex, name);
				
				var uiDecs:UIDecsView = new UIDecsView();
				PopupManager.getInstance().addPopup(uiDecs, {"decsText":content, "decsTextWidth":rect.width, "decsTextHeight":rect.height});
				
				this.changePropertySet("popupDecs", true);
				this.updateUI();
			}
		}
		
		private function get uiPlanViewAction():UIPlanViewAction {
			return this.action as UIPlanViewAction;
		}
		
		private function get planIndex():int {
			return this.data["planIndex"];
		}
		
	}

}