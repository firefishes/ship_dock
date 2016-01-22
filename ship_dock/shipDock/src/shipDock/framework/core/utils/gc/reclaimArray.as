package shipDock.framework.core.utils.gc
{
	public function reclaimArray(target:*, isReclaim:Boolean = false):void
	{
		if(!target)
			return;
		var item:*;
		if(isReclaim) {
			for each(item in target) {
				reclaim(item);
			}
		}
		target.length = 0;
	}
}