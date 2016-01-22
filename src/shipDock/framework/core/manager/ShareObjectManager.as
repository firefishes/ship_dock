package shipDock.framework.core.manager
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import shipDock.framework.core.singleton.SingletonBase;
	
	/**
	 * 本地共享数据管理器（单例）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class ShareObjectManager extends SingletonBase
	{
		
		public static function getInstance():ShareObjectManager
		{
			return SingletonManager.singletonManager().getSingleton("SOMgr") as ShareObjectManager;
		}
		
		private var so:SharedObject;
		private var _SOName:String = "SDGame";
		
		public function ShareObjectManager(name:String = "SOMgr")
		{
			super(this, name);
		}
		
		/**
		 * 获取一个本地共享数据对象
		 *
		 * @param	name
		 * @return
		 */
		public function getShareObject(name:String):*
		{
			if (so == null)
			{
				//SharedObject.preventBackup = true;
				so = SharedObject.getLocal(this._SOName);
			}
			if (so.data[name] != null)
			{
				return so.data[name];
			}
			return null;
		}
		
		/**
		 * 添加一个本地共享数据对象
		 *
		 * @param	name
		 * @param	data
		 */
		public function addShareObject(name:String, data:*):void
		{
			if (!so)
			{
				so = SharedObject.getLocal(this._SOName);
			}
			so.data[name] = data;
			try
			{
				var state:String = so.flush();
				var onFlushStatus:Function = function(event:NetStatusEvent):void
				{
					so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
					
				};
				switch (state)
				{
					case SharedObjectFlushStatus.PENDING: 
						so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED: 
						break;
				}
			}
			catch (err:Error)
			{
				trace(err);
			}
		}
		
		/**
		 * 清理一个本地共享数据对象
		 *
		 */
		public function clearShareObject():void
		{
			if (!so)
			{
				so = SharedObject.getLocal(this._SOName);
			}
			so.clear();
			so = null;
		}
		
		/**
		 * 获取具体项目的本地共享数据名
		 *
		 * @return
		 */
		public function get SOName():String
		{
			return this._SOName;
		}
		
		/**
		 * 设置具体项目的本地共享数据名
		 *
		 * @return
		 */
		public function set SOName(value:String):void
		{
			_SOName = value;
		}
	}
}