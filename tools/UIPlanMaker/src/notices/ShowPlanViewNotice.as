package notices 
{
	import command.MakerViewCommand;
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class ShowPlanViewNotice extends MakerViewNotice 
	{
		
		public function ShowPlanViewNotice(viewIndex:int, viewConfigName:String = null, assets:Array = null, bg:String = null) 
		{
			super(MakerViewCommand.SHOW_PLAN_VIEW_COMMAND, {"i":viewIndex, "v":viewConfigName, "a":assets, "b":bg});
			
		}
		
		override protected function setSelfData(args:Array):void 
		{
			super.setSelfData(args);
			this.data["i"] = args[0];
			this.data["v"] = args[1];
			this.data["a"] = args[2];
		}
		
		public function set viewConfigName(value:String):void {
			this.data["v"] = value;
		}
		
		public function get viewConfigName():String {
			return this.data["v"];
		}
		
		public function set assets(value:Array):void {
			this.data["a"] = value;
		}
		
		public function get assets():Array {
			return this.data["a"];
		}
		
		public function get viewIndex():int {
			return this.data["i"];
		}
		
		public function get bg():String {
			return this.data["b"];
		}
		
		public function set bg(value:String):void {
			this.data["b"] = value;
		}
		
		public function set planType(value:int):void {
			this.data["t"] = value;
		}
		
		public function get planType():int {
			return this.data["t"];
		}
	}

}