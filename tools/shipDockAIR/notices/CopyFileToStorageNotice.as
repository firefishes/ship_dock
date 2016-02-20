package notices
{
	import command.AIRFileOperationCommand;
	
	import shipDock.framework.core.notice.Notice;
	
	public class CopyFileToStorageNotice extends Notice
	{
		public function CopyFileToStorageNotice(sourcePath:String = "", isCover:Boolean = false)
		{
			super(AIRNoticeName.AIR_FILE_OPERATION, {"source":sourcePath, "isCover":isCover});
			this.subCommand = AIRFileOperationCommand.COPY_FILE_TO_STORAGE_COMMAND;
		}
		
		/**
		 * 获取待复制文件所在的目录路径
		 *  
		 * @return 
		 * 
		 */		
		public function get sourcePath():String {
			return this.data["source"];
		}
		
		/**
		 * 获取是否覆盖已复制过的内容
		 *  
		 * @return 
		 * 
		 */		
		public function get isCover():Boolean {
			return this.data["isCover"];
		}
	}
}