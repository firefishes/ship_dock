package shipDock.framework.core.command
{
	
	import shipDock.framework.core.action.ActionController;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.ICommand;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.notice.NoticeController;
	import shipDock.framework.core.singleton.SingletonBase;
	import shipDock.framework.core.utils.HashMap;
	
	/**
	 * 命令控制器（单例）
	 *
	 * @author shaoxin.ji
	 *
	 */
	final public class CommandController extends SingletonBase
	{
		
		public static const COMMAND_CONTROLLER:String = "commandController";
		
		public static function getInstance():CommandController
		{
			return SingletonManager.singletonManager().getSingleton(COMMAND_CONTROLLER) as CommandController;
		}
		
		/*所有命令集合*/
		private var _commands:HashMap;
		/*对象池管理器引用*/
		private var _objectPoolManager:ObjectPoolManager;
		/*逻辑脚本控制器引用*/
		private var _actionController:ActionController;
		/*消息控制器引用*/
		private var _noticeController:NoticeController;
		
		public function CommandController()
		{
			super(this, COMMAND_CONTROLLER);
			this._commands = new HashMap();
			this._objectPoolManager = ObjectPoolManager.getInstance();
			this._actionController = ActionController.getInstance();
			this._noticeController = NoticeController.getInstance();
		}
		
		/**
		 * 添加命令
		 *
		 * @param subject
		 * @param command
		 *
		 */
		public function addCommand(action:IAction, noticeName:String, commandClass:Class):void
		{
			var key:String = action.actionName;
			
			var commandPool:Object = this._commands.getValue(key);
			(commandPool == null) && (commandPool = {});
			
			if (commandPool.hasOwnProperty(noticeName))
			{
				LogsManager.getInstance().setLog("Caution CommandController-addCommand: 逻辑代理 " + key + " 中存在重复的命令 " + noticeName + ", 原命令将被替换.");
				return;
			}
			commandPool[noticeName] = commandClass;
			this._noticeController.addNotice(noticeName, action, this.executeCommand);
			this._commands.put(key, commandPool);
		}
		
		/**
		 * 命令对象被执行时统一的消息处理器
		 *
		 * @param	notice
		 * @return
		 */
		private function executeCommand(notice:INotice, actionName:String = null):*
		{
			var result:*;
			(!actionName) && (actionName = notice.actionName);
			var command:ICommand = this.getCommand(actionName, notice.name);
			if (command != null)
			{
				result = command.execute(notice);
				command.dispose();
				(notice.isAutoDispose) && notice.dispose();//销毁消息对象，减少内存占用
			}
			return result;
		}
		
		/**
		 * 移除单个命令对象
		 *
		 * @param	action
		 * @param	commandTarget
		 */
		public function removeCommand(action:IAction, noticeName:String):void
		{
			var key:String = action.actionName;
			if (this._actionController.getAction(key) != action)
				return;
			var commandPool:Object = this._commands.getValue(key);
			if (commandPool != null)
			{
				var commandClass:Class = commandPool[noticeName];
				if (commandClass != null)
				{
					this._noticeController.removeNotice(noticeName, action, this.executeCommand);
					delete commandPool[noticeName];
				}
			}
			this._commands.put(key, commandPool); //保存修改后的命令池
		}
		
		/**
		 * 移除界面逻辑代理
		 *
		 * @param	action
		 * @param	commandTarget
		 */
		public function removeAction(action:IAction):void
		{
			var key:String = action.actionName;
			if (this._commands.isContainsKey(key))
			{ //移除与此界面代理相关的所有命令，并销毁与此逻辑代理对象所有命令对象
				var commandPool:Object = this._commands.getValue(key);
				for (var k:*in commandPool)
				{
					this.removeCommand(action, k);
				}
				this._commands.remove(key);
			}
			this._actionController.removeAction(key);
		}
		
		private function hasCommand(actionName:String, noticeName:String):Boolean
		{
			var commandPool:Object = this._commands.getValue(actionName);
			var result:Boolean = (commandPool != null) && commandPool.hasOwnProperty(noticeName);
			return result;
		}
		
		/**
		 * 通过命令名获取命令对象
		 *
		 * @param subject
		 * @param commandName
		 * @return
		 *
		 */
		private function getCommand(target:*, noticeName:String):ICommand
		{
			var result:ICommand;
			var actionName:String = this._actionController.getActionName(target);
			if (actionName != null)
			{
				if (this.hasCommand(actionName, noticeName))
				{
					var commandPool:Object = this._commands.getValue(actionName);
					var commandClass:Class = commandPool[noticeName];
					result = this._objectPoolManager.fromPool(commandClass); //从对象池获取命令对象
					var action:IAction = this._actionController.getAction(actionName);
					(result != null) && (result.setAction(action)); //设置逻辑代理对象
				}
				else
					LogsManager.getInstance().setLog("Caution CommandController-getCommand: 在逻辑代理 " + actionName + "中试图执行不存在的命令 " + noticeName);
			}
			else
				LogsManager.getInstance().setLog("Caution CommandController-getCommand: 逻辑代理 " + actionName + " 没有被注册！");
			return result;
		}
	}
}