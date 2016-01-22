package shipDock.framework.core.command 
{
	import shipDock.framework.core.action.ActionController;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.notice.CoreNotice;
	import shipDock.framework.core.notice.SDUINotice;
	
	/**
	 * 核心命令类
	 * 
	 * 顶部的逻辑基类
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class CoreCommand extends Command
	{
		//--------------------------子命令--------------------------------------
		/*显示数据加载进度*/
		public static const SHOW_LOADING_COMMAND:String = "showLoadingCommand";
		/*隐藏数据加载进度*/
		public static const HIDE_LOADING_COMMAND:String = "hideLoadingCommand";
		/*注册数据代理*/
		public static const REGISTERED_PROXYIES_COMMAND:String = "registeredProxiesCommand";
		/*注册逻辑代理*/
		public static const REGISTERED_ACTION_COMMAND:String = "registeredActionCommand";
		
		public function CoreCommand(isAutoExecute:Boolean=true) 
		{
			super(isAutoExecute);
			
		}
		
		/**
		 * 显示数据加载进度子命令的具体逻辑
		 * 
		 * @param	notice
		 */
		public function showLoadingCommand(notice:CoreNotice):void {
			
		}
		
		/**
		 * 隐藏数据加载进度子命令的具体逻辑
		 * 
		 * @param	notice
		 */
		public function hideLoadingCommand(notice:CoreNotice):void {
			
		}
		
		/**
		 * 注册数据代理
		 * 
		 * @param	notice
		 */
		public function registeredProxiesCommand(notice:CoreNotice):void {
			var list:Array = (notice.data is Array) ? notice.data : [notice.data];
			var i:int = 0, max:int = list.length, cls:Class;
			while (i < max) {
				cls = list[i] as Class;
				if (cls)
					new cls();
				i++;
			}
		}
		
		/**
		 * 注册逻辑代理
		 * 
		 * 
		 * @param notice
		 * 
		 */		
		public function registeredActionCommand(notice:CoreNotice):void
		{
			var controller:ActionController = ActionController.getInstance();
			var list:Array, i:int, max:int, cls:Class, ac:IAction;
			if (notice.data is Array)
				list = notice.data;
			else
				list = [notice.data];
			i = 0;
			max = list.length;
			while (i < max)
			{
				cls = list[i];
				if (cls)
				{
					ac = new cls() as IAction;
					if (ac)
					{
						if (controller.hasAction(ac.actionName))
							ac.dispose();
						else
							controller.addAction(ac.actionName, ac);
					}
				}
				i++;
			}
		}
	}

}