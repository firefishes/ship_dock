package action 
{
	import shipDock.framework.core.interfaces.IDispose;
	/**
	 * ...
	 * @author ch.ji
	 */
	public class NativeDragParams implements IDispose
	{
		
		public var clipboadData:Array;
		
		public function NativeDragParams(list:Array) 
		{
			this.clipboadData = list;
		}
		
		public function dispose():void {
			this.clipboadData = null;
		}
		
	}

}