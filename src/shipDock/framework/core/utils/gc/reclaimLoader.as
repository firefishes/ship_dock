package shipDock.framework.core.utils.gc 
{
	import flash.display.Loader;
	
	/**
	 * 销毁原生加载器
	 * 
	 * ...
	 * @author ch.ji
	 */
	public function reclaimLoader(target:Loader):void
	{
		(!!target) && target.unloadAndStop();
	}

}