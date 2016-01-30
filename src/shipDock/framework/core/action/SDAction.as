package shipDock.framework.core.action {
	
	import shipDock.framework.core.command.CoreCommand;
	import shipDock.framework.core.command.HTTPCommand;
	import shipDock.framework.core.command.ShareObjectCommand;
	import shipDock.framework.core.command.UICommand;
	import shipDock.framework.core.notice.Notice;
	import shipDock.framework.core.notice.SDNoticeName;
	
	/**
	 * 全局逻辑代理
	 * 
	 * 通用的逻辑脚本调用
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDAction extends Action 
	{
		
		public static const SHIP_DOCK_ACTION:String = "stageAction";
		
		private var _startUpCommandCls:Class;
		
		public function SDAction(startUpClass:Class = null) 
		{
			super();
			defaultAction = this;
			this._startUpCommandCls = startUpClass;
			(this._startUpCommandCls) && this.registered(SDNoticeName.SD_START_UP, this._startUpCommandCls);
			this.startUp();
		}
		
		override protected function setCommand():void 
		{
			super.setCommand();
			this.registered(SDNoticeName.SD_UI, this.UICommandClass);
			this.registered(SDNoticeName.SD_CORE, this.coreCommandClass);
			this.registered(SDNoticeName.SD_HTTP, this.HTTPCommandClass);
			this.registered(SDNoticeName.SD_SHARE_OBJECT, this.shareObjectCommandClass);
			
		}
		
		protected function startUp():void {
			this.sendNotice(new Notice(SDNoticeName.SD_START_UP));
		}
		
		override public function get actionName():String 
		{
			return SHIP_DOCK_ACTION;
		}
		
		/**
		 * 覆盖此方法修改项目中用到的具体核心命令类，默认为CoreCommand类
		 * 
		 */
		protected function get coreCommandClass():Class {
			return CoreCommand;
		}
		
		/**
		 * 覆盖此方法获取项目中用到的具体HTTP请求功能命令类，默认为HTTPCommand类
		 * 
		 */
		protected function get HTTPCommandClass():Class {
			return HTTPCommand;
		}
		
		/**
		 * 覆盖此方法获取项目中用到的具体ShareObject本地数据共享命令类，默认为ShareObjectCommand类
		 * 
		 */
		protected function get shareObjectCommandClass():Class {
			return ShareObjectCommand;
		}
		
		/**
		 * 覆盖此方法获取项目中用到的具体界面命令类，默认为UICommand类
		 * 
		 */
		protected function get UICommandClass():Class {
			return UICommand;
		}
		
	}

}