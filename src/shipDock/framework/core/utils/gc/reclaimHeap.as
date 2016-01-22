package shipDock.framework.core.utils.gc 
{
	/**
	 * 调用指定的销毁方法统一销毁普通对象
	 * 
	 * ch.ji
	 * 
	 */	
	public function reclaimHeap(o:Object):void
	{
		if (!o)
			return
		var k:*;
		for (k in o) {
			(o[k]) && (delete o[k]);
		}
	}

}