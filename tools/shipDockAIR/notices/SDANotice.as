package notices
{
	import shipDock.framework.core.notice.Notice;
	
	public class SDANotice extends Notice
	{
		public function SDANotice(subCommand:String, data:*)
		{
			super(AIRNoticeName.SHIP_DOCK_AIR, data);
			this.subCommand = subCommand;
		}
	}
}