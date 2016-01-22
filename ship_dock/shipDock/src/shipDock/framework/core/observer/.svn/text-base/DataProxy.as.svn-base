package shipDock.framework.core.observer
{
	import shipDock.framework.core.interfaces.IDataProxy;
	import shipDock.framework.core.manager.SubjectManager;
	
	/**
	 * 数据代理器基类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class DataProxy extends Subject implements IDataProxy
	{
		
		/**
		 * 获取数据代理对象
		 *
		 * @param	proxyName
		 * @return
		 */
		public static function getDataProxy(proxyName:String):*
		{
			return SubjectManager.getSubject(proxyName);
		}
		
		public function DataProxy(name:String = null)
		{
			super(name);
		}
		
		final public function get proxyName():String
		{
			return this.subjectName;
		}
	}

}