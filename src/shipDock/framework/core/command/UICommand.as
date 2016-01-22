package shipDock.framework.core.command
{
	import shipDock.framework.core.action.ActionController;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.ISDViewAction;
	import shipDock.framework.core.notice.SDUINotice;
	
	/**
	 * 界面命令类
	 *
	 * 归纳与界面相关的逻辑功能
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class UICommand extends Command
	{
		
		public static const OPEN_VIEW_COMMAND:String = "openViewCommand";
		public static const CLOSE_VIEW_COMMAND:String = "closeViewCommand";
		
		public function UICommand(isAutoExecute:Boolean = true)
		{
			super(isAutoExecute);
		}
		
		public function openViewCommand(notice:INotice):void {
			var action:ISDViewAction = this.getViewAction(notice.data);
			(action) && action.openView();
		}
		
		public function closeViewCommand(notice:INotice):void {
			var action:ISDViewAction = this.getViewAction(notice.data);
			(action) && action.closeView();
		}
		
		private function getViewAction(name:String):ISDViewAction {
			var result:ISDViewAction = this.getAction(name) as ISDViewAction;
			return result;
		}
	}
	
}