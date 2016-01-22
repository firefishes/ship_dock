package notices
{
	import flash.net.FileReferenceList;
	
	import notices.AIRNoticeName;
	
	import shipDock.framework.core.notice.Notice;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class AIRFileOperationNotice extends Notice
	{
		
		public function AIRFileOperationNotice(fileFilters:Array, browseComplete:Function = null, fileRefList:FileReferenceList = null)
		{
			super(AIRNoticeName.AIR_FILE_OPERATION, {"fileFilters": fileFilters, "browseComplete": browseComplete, "fileRefList": fileRefList});
		}
		
		override protected function setSelfData(args:Array):void
		{
			this.data["fileFilters"] = args[0];
			this.data["browseComplete"] = args[1];
			this.data["fileRefList"] = args[2];
		}
		
		public function get browserComplete():Function
		{
			return this.data["browseComplete"];
		}
		
		public function get fileFilters():Array
		{
			return this.data["fileFilters"];
		}
		
		public function get fileRefList():FileReferenceList
		{
			return this.data["fileRefList"];
		}
	}

}