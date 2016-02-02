package shipDock.framework.core.observer 
{
	/**
	 * 控件代理观察者
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class UIAgentSubject extends Subject 
	{
		
		public static const DEFAULT_NAME:String = "UIAgentSubject";
		
		public function UIAgentSubject(name:String=null) 
		{
			(!name) && (name = DEFAULT_NAME);
			super(name);
			
		}
		
	}

}