package ui 
{
	import flash.text.TextField;
	import shipDock.framework.application.component.UIAgent;
	
	/**
	 * ...
	 * @author ch.ji
	 */
	public class AIRComponent extends UIAgent 
	{
		
		private var _label:*;
		
		private var _enabled:Boolean;
		
		public function AIRComponent(target:*) 
		{
			super(target);
			
			this.enabled = true;
		}
		
		override public function redraw():void 
		{
			super.redraw();
			
			if (this.isPropertySet("label")) {
				this._label = this.getProperty("label");
				this.setLabel();
			}
			if (this.isPropertySet("enabled")) {
				this._enabled = this.getProperty("enabled");
				this.setEnabled();
			}
			
		}
		
		protected function setEnabled():void {
			if (this.agented.hasOwnProperty("mouseEnabled")) {
				this.agented["mouseEnabled"] = this._enabled;
			}
		}
		
		protected function setLabel():void {
			if (this.agented["label"]) {
				if (this.agented["label"] is TextField)
					this.agented["label"].text = this._label;
				else
					this.agented["label"] = this._label;
			}
		}
		
		public function set label(value:*):void {
			this.setProperty("label", value);
		}
		
		public function get label():Boolean {
			return this._label;
		}
		
		public function set enabled(value:Boolean):void {
			this.setProperty("enabled", value);
		}
		
		public function get enabled():Boolean {
			return this._enabled;
		}
		
	}

}