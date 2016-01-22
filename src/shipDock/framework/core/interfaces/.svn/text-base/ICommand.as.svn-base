package shipDock.framework.core.interfaces
{

	/**
	 * 命令接口
	 * 
	 */
	public interface ICommand extends IDispose,IObserver,INotify
	{
		function execute(notice:INotice):*;
		function setAction(value:IAction):void;
		function get action():IAction;
		function get id():String;
	}
}