package shipDock.command 
{
	import shipDock.data.QueueLoaderProxy;
	import shipDock.framework.core.command.Command;
	import shipDock.framework.core.observer.DataProxy;
	import shipDock.interfaces.IQueueLoaderProxyNotice;
	
	/**
	 * 素材队列异步加载命令
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class QueueLoaderProxyCommand extends Command 
	{
		
		public static const ADD_ASSET_TO_QUEUE_COMMAND:String = "addAssetToQueueCommand";
		public static const START_ASSET_QUEUE_COMMAND:String = "startAssetQueueCommand";
		
		private var _queueLoaderProxy:QueueLoaderProxy;
		
		public function QueueLoaderProxyCommand() 
		{
			super(true);
			
			this._queueLoaderProxy = DataProxy.getDataProxy(QueueLoaderProxy.NAME);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			this._queueLoaderProxy = null;
		}
		
		public function addAssetToQueueCommand(notice:IQueueLoaderProxyNotice):void {
			this._queueLoaderProxy.addAssetList(notice.loadID, notice.assets, notice.loaderClass, notice.classArgs);
		}
		
		public function startAssetQueueCommand(notice:IQueueLoaderProxyNotice):void {
			this._queueLoaderProxy.startLoad(notice.loadID);
		}
	}

}