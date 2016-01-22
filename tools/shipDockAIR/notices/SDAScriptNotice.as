package notices
{
	import shipDock.framework.core.notice.Notice;
	
	public class SDAScriptNotice extends Notice
	{
		public function SDAScriptNotice(data:*=null)
		{
			super(AIRNoticeName.SDA_SCRIPT, data);
		}
		
		public function get script():String {
			return this.getNoticeParams("s");
		}
	}
}