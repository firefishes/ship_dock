package  
{
	import action.MainAction;
	import shipDock.framework.application.Application;
	import view.StartView;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class NewGameStage extends Application 
	{
		
		private var _mainAction:MainAction;
		
		public function NewGameStage() 
		{
			super();
			
		}
		
		override protected function start():void 
		{
			super.start();
			
			this._mainAction = new MainAction();//初始化脚本代理对象
			this._mainAction.setProxyed(this);
			
			var startView:StartView = new StartView();
			this.addChild(startView);
			
		}
	}

}