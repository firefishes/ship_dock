package ui 
{
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ch.ji
	 */
	public class AIRButton extends AIRComponent 
	{
		
		public function AIRButton(target:*, click:Function, label:* = "") 
		{
			super(target);
			
			this.callbacks.addCallback("click", click);
			
			this.agented.addEventListener(MouseEvent.CLICK, this.clickHandler);
			
			this.label = label;
		}
		
		override protected function setEnabled():void 
		{
			super.setEnabled();
			this.callbacks.useCallback("buttonEnabled");
		}
		
		private function clickHandler(event:MouseEvent):void {
			this.callbacks.useCallback("click", [event]);
		}
		
		public function set buttonEnabled(value:Function):void {
			this.callbacks.addCallback("buttonEnabled", value);
		}
	}

}