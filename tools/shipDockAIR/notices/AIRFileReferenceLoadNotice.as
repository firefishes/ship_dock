package notices
{
	import command.AIRFileOperationCommand;
	
	import shipDock.framework.core.notice.Notice;
	
	public class AIRFileReferenceLoadNotice extends Notice
	{
		public function AIRFileReferenceLoadNotice(fileReferences:Array, callback:Function, isApplyData:Boolean = true)
		{
			super(AIRNoticeName.AIR_FILE_OPERATION, {"list":fileReferences, "callback":callback, "isAppData":isApplyData});
			this.subCommand = AIRFileOperationCommand.FILEREFERENCE_LOAD_COMMAND;
		}
		
		override protected function setResetSubCommand():void {
			this._resetSubCommand = false;
		}
		
		override protected function setSelfData(args:Array):void {
			this.data["list"] = args[0];
			this.data["callback"] = args[1];
			this.data["isAppData"] = args[2];
		}
		
		public function get fileReferences():Array {
			return this.data["list"];
		}
		
		public function get callback():Function {
			return this.data["callback"];
		}
		
		public function get isApplyData():Boolean {
			return this.data["isApplyData"];
		}
	}
}