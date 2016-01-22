package shipDock.framework.core.interfaces 
{
	import shipDock.ui.IView;
	
	/**
	 * 视图界面逻辑代理接口
	 * 
	 * ...
	 * @author ch.ji
	 */
	public interface ISDViewAction extends IAction 
	{
		function openView():void;
		function closeView():void;
		function get view():IView;
	}
	
}