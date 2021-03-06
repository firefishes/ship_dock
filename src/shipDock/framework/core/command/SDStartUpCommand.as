package shipDock.framework.core.command 
{
	import shipDock.framework.core.action.ActionController;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.notice.CoreNotice;
	import shipDock.framework.core.observer.UIAgentSubject;
	/**
	 * ...
	 * @author ch.ji
	 */
	public class SDStartUpCommand extends Command 
	{
		
		public function SDStartUpCommand() 
		{
			super(false);
			
		}
		
		override public function execute(notice:INotice):* 
		{
			this.initActions();
			this.initCommands();
			this.initProxies();
		}
		
		private function initCommands():void {
			
			var list:Array = this.commandList;
			var i:int = 0, item:Array;
			var max:int = list.length;
			var actionController:ActionController = ActionController.getInstance();
			while (i < max) {
				item = list[i];
				actionController.preregisteredCommand(item[0], item[1]);
				i++;
			}
		}
		
		private function initProxies():void {
			var list:Array = this.proxyList.concat(UIAgentSubject);
			var notice:CoreNotice = new CoreNotice(CoreCommand.REGISTERED_PROXYIES_COMMAND, list);
			this.sendNotice(notice);
		}
		
		private function initActions():void {
			var notice:CoreNotice = new CoreNotice(CoreCommand.REGISTERED_ACTION_COMMAND, this.actionList);
			this.sendNotice(notice);
		}
		
		protected function get proxyList():Array {
			return [];
		}
		
		protected function get actionList():Array {
			return [];
		}
		
		protected function get commandList():Array {
			return [];
		}
	}

}