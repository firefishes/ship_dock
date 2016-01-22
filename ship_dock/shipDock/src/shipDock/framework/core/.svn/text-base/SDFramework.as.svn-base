package shipDock.framework.core
{
	import shipDock.framework.core.action.ActionController;
	import shipDock.framework.core.command.CommandController;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.NoticeManager;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.manager.ShareObjectManager;
	import shipDock.framework.core.manager.SubjectManager;
	import shipDock.framework.core.notice.NoticeController;
	import shipDock.framework.core.observer.SubjectController;
	
	/**
	 * 框架入口类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDFramework
	{
		
		public function SDFramework(onStarted:Function = null, applyNotice:Boolean = true, applyCommand:Boolean = true, applySOManager:Boolean = true)
		{
			this.startUp(applyNotice, applyCommand, applySOManager);
			
			if (!!onStarted)
			{
				onStarted();
			}
		}
		
		protected function startUp(applyNotice:Boolean = true, applyCommand:Boolean = true, applySOManager:Boolean = true):void
		{
			
			new ObjectPoolManager(); //对象池管理器
			new LogsManager(); //调试信息输出管理器
			
			if (applyNotice)
			{
				new NoticeController(); //消息控制器
				new NoticeManager(); //消息管理器
				new SubjectManager(); //观察者管理器
			}
			if (applyCommand)
			{
				new ActionController(); //逻辑脚本控制器
				new CommandController(); //命令控制器
				new SubjectController(); //观察者主题控制器
			}
			(applySOManager) && new ShareObjectManager(); //本地共享对象管理器
		}
	
	}

}