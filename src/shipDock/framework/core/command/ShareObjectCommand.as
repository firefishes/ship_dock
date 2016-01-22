package shipDock.framework.core.command
{
	import shipDock.framework.core.manager.ShareObjectManager;
	import shipDock.framework.core.notice.ShareObjectNotice;
	
	/**
	 * 本地数据共享命令类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class ShareObjectCommand extends Command
	{
		
		//--------------------------子命令--------------------------------------
		/*写入本地共享数据对象的数据*/
		public static const FLUSH_SO_COMMAND:String = "flushSOCommand";
		/*获取并检测文件版本号*/
		public static const GET_FILE_VERSION_CHECKER_SO_COMMAND:String = "getFileVersionCheckerSOCommand";
		/*获取本地共享数据对象*/
		public static const GET_SO_COMMAND:String = "getSOCommand";
		
		private var _soManager:ShareObjectManager;
		
		public function ShareObjectCommand()
		{
			super();
			this._soManager = ShareObjectManager.getInstance();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			this._soManager = null;
		}
		
		/**
		 * 获取一个本地数据共享对象中的数据 子命令的具体逻辑
		 *
		 * @param	notice
		 * @return
		 */
		public function getFileVersionCheckerSOCommand(notice:ShareObjectNotice):*
		{
			var data:Object = this._soManager.getShareObject(notice.shareObjectName);
			if (data == null)
			{
				data = {};
				this._soManager.addShareObject(notice.shareObjectName, data);
			}
			if (data[notice.dafaField] == null)
			{
				data[notice.dafaField] = {};
			}
			
			var result:* = data[notice.dafaField];
			return result;
		}
		
		/**
		 * 获取本地共享数据对象
		 * 
		 * @param	notice
		 * @return
		 */
		public function getSOCommand(notice:ShareObjectNotice):Object {
			var result:Object = this._soManager.getShareObject(notice.shareObjectName);
			if (result == null)
			{
				result = { };
				this._soManager.addShareObject(notice.shareObjectName, result);
			}
			return result;
		}
		
		/**
		 * 写入一个数据到本地共享数据对象 子命令的具体逻辑
		 *
		 * @param	notice
		 */
		public function flushSOCommand(notice:ShareObjectNotice):void
		{
			var data:Object = this.getSOCommand(notice);
			data[notice.dafaField] = notice.flushData;
			this._soManager.addShareObject(notice.shareObjectName, data);
		}
	}

}