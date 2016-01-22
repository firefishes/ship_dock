package shipDock.framework.application.events {
	import starling.events.Event;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class EffectEvent extends Event 
	{
		
		public static const EFFECT_FINISH_EVENT:String = "effectFinishEvent";
		
		public function EffectEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
			
		}
		
	}

}