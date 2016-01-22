package shipDock.framework.core.notice 
{
	import shipDock.framework.core.notice.SDNoticeName;
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class ShareObjectNotice extends Notice 
	{
		
		public function ShareObjectNotice(subCommand:String, shareObjectName:String, dafaField:String, flushData:Object = null) 
		{
			this.subCommand = subCommand;
			super(SDNoticeName.SD_SHARE_OBJECT, {"soName":shareObjectName, "key":dafaField, "flushData":flushData});
			
		}
		
		override protected function setSelfData(args:Array):void 
		{
			this.data["soName"] = args[0];
			this.data["key"] = args[1];
			this.data["flushData"] = args[2];
		}
		
		public function get shareObjectName():String {
			return this.data["soName"];
		}
		
		public function get dafaField():String {
			return this.data["key"];
		}
		
		public function get flushData():Object {
			return this.data["flushData"];
		}
	}

}