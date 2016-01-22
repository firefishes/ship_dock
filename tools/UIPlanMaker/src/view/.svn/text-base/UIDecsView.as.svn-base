package view 
{
	import shipDock.framework.application.component.SDComponent;
	import shipDock.framework.application.component.SDQuad;
	import shipDock.framework.application.component.SDQuadText;
	import shipDock.framework.application.SDCore;
	import shipDock.ui.ScrollContainer;
	import shipDock.ui.View;
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	
	/**
	 * ...
	 * @author ch.ji
	 */
	public class UIDecsView extends View 
	{
		
		public function UIDecsView() 
		{
			super();
			this._hasUIConfig = false;
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			var bg:SDQuad = new SDQuad(800, 640, 0x222222);
			this.addChild(bg);
			
			var scrollContent:ScrollContainer = new ScrollContainer(700, 640);
			scrollContent.x = 50;
			this.putChildraw(scrollContent, "textContainer");
				
			var contentText:SDQuadText = new SDQuadText(700, 640, "", 30);
			this.changeProperty("contentText", contentText);
			
			this.decsText = "";
			this.decsTextWidth = 700;
			this.decsTextHeight = 600;
			
			scrollContent.changeClipPos(0, 50);
			scrollContent.changeClipSize(this.decsTextWidth, this.decsTextHeight);
			scrollContent.changeContainerSize(this.decsTextWidth / 2, this.decsTextHeight);
			scrollContent.addItem(contentText);
			
			this.addChild(scrollContent);
			
			this.changePropertySet("addRemovePopupEvent", true);
		}
		
		private function removeUIDecsView(event:TouchEvent):void {
			if (SDComponent.touchCheck(event)) {
				var scrollContent:ScrollContainer = this.getChildraw("textContainer") as ScrollContainer;
				if (scrollContent != null && !scrollContent.contains(event.target as DisplayObject)) {
					this.close();
				}
			}
		}
		
		override protected function removeEvents():void 
		{
			super.removeEvents();
			SDCore.getInstance().starling.stage.removeEventListener(TouchEvent.TOUCH, this.removeUIDecsView);
		}
		
		override public function redraw():void 
		{
			super.redraw();
			if (this.isPropertySet("updateDecs", true)) {
				var w:Number = this.getPropertyChanged("decsTextW");
				var h:Number = this.getPropertyChanged("decsTextH");
				var text:String = this.getPropertyChanged("decsText");
				
				var scrollContent:ScrollContainer = this.getChildraw("textContainer") as ScrollContainer;
				scrollContent.container.removeChildren();
				
				var contentText:SDQuadText = this.getPropertyChanged("contentText") as SDQuadText;
				contentText = new SDQuadText(w, h, text, 30, 0xffffff, "left");
				contentText.text = text;
				scrollContent.changeContainerSize(this.decsTextWidth / 2, this.decsTextHeight);
				scrollContent.addItem(contentText);
			}
			if (this.isPropertySet("addRemovePopupEvent", true)) {
				var delay:Function = function():void {
					SDCore.getInstance().starling.stage.addEventListener(TouchEvent.TOUCH, removeUIDecsView);
				};
				SDCore.getInstance().juggler.delayCall(delay, 0.3);
			}
		}
		
		override protected function applyData():void 
		{
			this.applyAllData();
		}
		
		public function set decsTextWidth(value:Number):void {
			this.changeProperty("decsTextW", value);
			this.changePropertySet("updateDecs", true);
			this.updateUI();
		}
		
		public function get decsTextWidth():Number {
			return this.getPropertyChanged("decsTextW");
		}
		
		public function set decsTextHeight(value:Number):void {
			this.changeProperty("decsTextH", value);
			this.changePropertySet("updateDecs", true);
			this.updateUI();
		}
		
		public function get decsTextHeight():Number {
			return this.getPropertyChanged("decsTextH");
		}
		
		public function set decsText(value:String):void {
			this.changeProperty("decsText", value);
			this.changeProperty("updateDecs", true);
			this.updateUI();
		}
		
		public function get decsText():String {
			return this.getPropertyChanged("decsText");
		}
	}

}