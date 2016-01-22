package shipDock.framework.core.action {
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.singleton.SingletonBase;
	import shipDock.framework.core.utils.HashMap;
	
	/**
	 * 逻辑脚本对象控制器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	final public class ActionController extends SingletonBase
	{
		
		public static const ACTION_CONTROLLER:String = "actionController";
		
		public static function getInstance():ActionController
		{
			return SingletonManager.singletonManager().getSingleton(ACTION_CONTROLLER) as ActionController;
		}
		
		/*所有动作集合*/
		private var _actions:HashMap;
		/*所有预注册的命令类集合*/
		private var _commandPreregistered:Object;
		
		public function ActionController()
		{
			super(this, ACTION_CONTROLLER);
			this._actions = new HashMap();
			this._commandPreregistered = {};
		}
		
		/**
		 * 获取一个逻辑代理对象
		 *
		 * @param	value
		 * @return
		 */
		public function getAction(value:*):IAction
		{
			var key:String = this.getActionName(value);
			return this._actions.getValue(key) as IAction;
		}
		
		/**
		 * 添加一个逻辑代理对象
		 *  
		 * @param key
		 * @param action
		 * 
		 */		
		public function addAction(key:String, action:IAction):void
		{
			var flag:Boolean = this.hasAction(key);
			(!flag) && this._actions.put(key, action);
		}
		
		/**
		 * 移除一个逻辑代理对象
		 *  
		 * @param value
		 * @return 
		 * 
		 */		
		public function removeAction(value:String):IAction
		{
			var result:IAction = this._actions.getValue(value, true);
			(result != null) && LogsManager.getInstance().setLog("【ACTION REMOVED】: 逻辑代理 " + value + " 被成功移除.");
			return result;
		}
		
		/**
		 * 获取逻辑代理对象的名称
		 *  
		 * @param value
		 * @return 
		 * 
		 */		
		public function getActionName(value:*):String
		{
			var result:String;
			if (value == null)
				return null;
			if (value is IAction)
				result = (value as IAction).actionName;
			else if (value is String)
				result = value;
			return result;
		}
		
		/**
		 * 添加需要预注册的命令类
		 *  
		 * @param name
		 * @param commandCls
		 * 
		 */		
		public function preregisteredCommand(name:String, commandCls:Class):void {
			if(this._commandPreregistered.hasOwnProperty(name))
				return;
			this._commandPreregistered[name] = commandCls;
		}
		
		/**
		 * 获取预注册的命令类
		 *  
		 * @param name
		 * @return 
		 * 
		 */		
		public function getPreregisteredCommand(name:String):Class {
			return this._commandPreregistered[name];
		}
		
		/**
		 * 移除预注册命令类
		 *  
		 * @param name
		 * 
		 */		
		public function removePreregisteredCommand(name:String):void {
			delete this._commandPreregistered[name];
		}
		
		/**
		 * 是否存在某个逻辑代理对象
		 *  
		 * @param value
		 * @return 
		 * 
		 */		
		public function hasAction(value:*):Boolean
		{
			var key:String = this.getActionName(value);
			return this._actions.isContainsKey(key);
		}
	}
}