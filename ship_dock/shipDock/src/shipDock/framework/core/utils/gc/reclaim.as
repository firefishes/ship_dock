package shipDock.framework.core.utils.gc
{
	/**
	 * 调用指定的销毁方法统一销毁自定义对象
	 * 
	 * @author ch.ji
	 *  
	 */	
	public function reclaim(o:*, method:String = "dispose"):void
	{
		(!!o && o.hasOwnProperty(method)) && o[method]();
	}
}