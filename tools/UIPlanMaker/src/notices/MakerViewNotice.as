package notices 
{
	import shipDock.framework.core.notice.Notice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class MakerViewNotice extends Notice 
	{
		
		public function MakerViewNotice(subCommand:String, data:*=null) 
		{
			super(NoticeName.MAKER_VIEW_NOTICE, data);
			this.subCommand = subCommand;
			
		}
		
	}

}