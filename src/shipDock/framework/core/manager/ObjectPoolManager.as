package shipDock.framework.core.manager
{
	import flash.utils.getDefinitionByName;
	
	import shipDock.framework.core.interfaces.IObjectPoolElement;
	import shipDock.framework.core.manager.objectPool.ObjectPoolElement;
	import shipDock.framework.core.singleton.SingletonBase;
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.utils.StringUtils;
	
	/**
	 * 对象池管理器（单例）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class ObjectPoolManager extends SingletonBase
	{
		
		public static var isShowLog:Boolean = false;
		public static var maxDefault:int = 5;
		
		public static function getInstance():ObjectPoolManager
		{
			return SingletonManager.singletonManager().getSingleton("objectPoolMgr") as ObjectPoolManager;
		}
		
		/*对象池的对象集合和某个类型的对象池的数量上限*/
		private var _pools:HashMap;
		/*已使用的对象集合*/
		private var _used:HashMap;
		/*所有对象池的对象集合*/
		private var _record:HashMap;
		/*正在放回池子的对象集合*/
		private var _reseting:HashMap;
		/*概览日志*/
		private var _log:HashMap;
		/*未使用的池对象*/
		private var _elements:Vector.<ObjectPoolElement>;
		
		public function ObjectPoolManager(singletonName:String = "objectPoolMgr")
		{
			super(this, singletonName);
			
			this._used = new HashMap();
			this._pools = new HashMap();
			this._record = new HashMap();
			this._reseting = new HashMap();
			
			this._elements = new Vector.<ObjectPoolElement>();
		}
		
		/**
		 * 是否已创建有特定对象池
		 *
		 * @param	cls
		 * @return
		 */
		public function hasPool(cls:Class):Boolean
		{
			return _pools.isContainsKey(cls);
		}
		
		/**
		 * 是否属于某个对象池
		 *
		 * @param	target
		 * @return
		 */
		public function isOwnPools(target:*):Boolean
		{
			return _record.isContainsKey(target);
		}
		
		/**
		 * 销毁特定对象池
		 *
		 * @param	cls
		 * @param	isDisposeTargets
		 * @return
		 */
		public function disposePool(cls:Class, isDisposeTargets:Boolean = true):void
		{
			if (!hasPool(cls))
				throw new Error("【X_X】The object pool is not exsit."); //不存在指定类型的对象池
			var list:Vector.<IObjectPoolElement> = this._pools.getValue(cls) as Vector.<IObjectPoolElement>;
			var max:uint = list.length;
			while (max >= 0)
			{
				var op:IObjectPoolElement = list[max];
				this._used.remove(op.target);
				this.deleteRecord(op.target);
				op.dispose();
				this._elements.unshift(op); //池元素再利用
				max--;
			}
			list.length = 0;
			list = null;
			(list.length > 0) && this._pools.remove(getMaxKey(op.className)); //清除对象池实例数量记录
		}
		
		/**
		 * 添加对象池
		 *
		 * @param	cls
		 * @param	maxSize
		 */
		public function addPool(cls:Class, max:uint = 0, ... args:Array):void
		{
			if (cls == null)
				return;
			if (hasPool(cls))
				throw new Error("【X_X】The object pool is exsit."); //已存在指定的对象池
			var m:uint = (max > 0) ? max : maxDefault;
			var list:Vector.<IObjectPoolElement> = new Vector.<IObjectPoolElement>(m);
			var i:int = (max > 0) ? int(max - 1) : (maxDefault - 1);
			while (i >= 0)
			{ //初始化池中对象数量
				var op:ObjectPoolElement = (this._elements.length == 0) ? new ObjectPoolElement(cls) : this._elements.shift(); //只传递类，在需要时才新建对象
				(!op.objectClass) && op.clear(cls);
				list[i] = op;
				updateRecordMap(op); //制作池元素备案
				i--;
			}
			_pools.put(cls, list);
			_pools.put(getMaxKey(op.className), max); //记录数量上限
			poolLog("【NEW OBJECT POOL】An object pool created, class is " + cls + " pool size is " + list.length);
		}
		
		/**
		 * 从对象池获取对象
		 *
		 * @param	cls
		 * @param	...args 新建对象所需的构造参数
		 *
		 * @return
		 */
		public function fromPool(cls:Class, ... args:Array):*
		{
			if (cls == null)
				return null;
			if (!hasPool(cls))
			{
				var params:Array = [cls, 0];
				(args.length > 0) && (params = params.concat(args)); //组织添加对象池方法所需的参数
				addPool.apply(this, params); //不存在指定类型的对象池时创建一个新的对象池
			}
			var op:IObjectPoolElement;
			var clsName:String = StringUtils.qualifiedClassName(cls, true);
			var max:int = _pools.getNumber(getMaxKey(clsName));
			var list:Vector.<IObjectPoolElement> = _pools.getValue(cls) as Vector.<IObjectPoolElement>;
			var isEmpty:Boolean = (list.length == 0);
			if (int(max) > 0)
			{ //对象池有对象个数限制
				if (isEmpty) //当对象池有对象个数限制时检测对象是否已用尽
				{
					poolLog("【0_-】The object pool's object is not enough."); //对象池已用尽
					return null;
				}
				op = list.shift();
			}
			else
			{ //当对象池无对象个数限制时新建对象
				if (isEmpty)
				{
					op = (this._elements.length == 0) ? new ObjectPoolElement(cls) : this._elements.shift(); //只传递类，在需要时才新建对象
					(!op.objectClass) && op.clear(cls);
					updateRecordMap(op); //制作池元素备案
					poolLog("【POOL OBJECT EMPTY】An pool is dry up, new object created. class is " + cls);
				}
				else
				{
					op = list.shift();
				}
			}
			op.reinitPoolObject(args); //重初始化
			_used.put(op.target, op); //增加已用对象
			poolLog("【POOL OBJECT USED】An object is used, class is " + cls + ", pool size is " + list.length + ", used object total " + _used.size);
			return op.target;
		}
		
		/**
		 * 向对象池归还对象
		 *
		 * TODO 需要检测是否存在既从对象池取出，但使用后又私自销毁的对象
		 *
		 * @param	target
		 */
		public function toPool(target:*, onReset:Function = null, ... onResetParams:Array):void
		{
			if (target == null)
				return;
			var className:String = StringUtils.qualifiedClassName(target, true);
			var cls:Class = getDefinitionByName(className) as Class;
			
			if (!hasPool(cls))
			{
				poolLog("【X_X】The object pool is not exsit."); //不存在指定类型的对象池
				return;
			}
			var op:IObjectPoolElement = _used.getValue(target, true) as IObjectPoolElement;
			if (op == null) //对象不属于此对象池
			{
				poolLog("【0_-】Back to pool failed, object don't owned the pool, object is " + target);
				return;
			}
			var max:int = int(_pools.getNumber(getMaxKey(op.className)));
			var list:Vector.<IObjectPoolElement> = _pools.getValue(op.objectClass) as Vector.<IObjectPoolElement>;
			if ((max > 0) && (list.length >= max)) //当对象池限制对象个数时检测对象池是否已满
			{
				poolLog("【0_-】The object pool is full."); //对象池已满
				deleteRecord(op.target);
				op.dispose(); //私自销毁多余的池元素
				this._elements.unshift(op); //池元素再利用
				return;
			}
			_reseting.put(target, op); //标记为正在回收
			op.resetPoolObject();
			(onReset != null) && onReset.apply(null, onResetParams);
			list.unshift(op); //放到第一个元素，防止下次从对象池取对象时获取到一个全新的池元素
			_reseting.remove(target); //清除出正在重置的集合
			poolLog("【POOL OBJECT RESET】An object is reset, class is " + cls + " pool size is " + list.length + ", used object total " + _used.size);
		}
		
		/**
		 * 获取代表对象池最大个数的键名
		 *
		 * @param	clsName
		 * @return
		 */
		private function getMaxKey(clsName:String):String
		{
			return clsName + "Max";
		}
		
		/**
		 * 检测对象是否已被使用
		 *
		 * @param	target
		 */
		public function isTargetUsed(target:*):Boolean
		{
			var op:ObjectPoolElement = _used.getValue(target) as ObjectPoolElement;
			var result:Boolean = ((op != null) && hasPool(op.objectClass));
			return result;
		}
		
		/**
		 * 检测需要回收的对象是否属于某对象池，默认做回收操作
		 *
		 * 注意：所有需要出现在对象池中的对象在被主动销毁时都要先调用此方法检测是否能被手动销毁
		 *
		 * @param	target
		 */
		public function isReleaseInPool(target:*, isToPool:Boolean = true):Boolean
		{
			var isOwnSomePool:Boolean = isOwnPools(target); //对象是否属于某个对象池
			if (!isOwnSomePool)
				return false;
			var isUsed:Boolean = isTargetUsed(target); //对象是否正在被使用
			var isResting:Boolean = isTargetReseting(target); //对象是否正在被重置
			(isUsed && isToPool) && toPool(target); //回收正在被使用到对象池中
			var result:Boolean = (isUsed || isOwnSomePool); //是否由对象池负责回收
			(result && isResting) && poolLog("【0_-】Pool object is reset in pool. object is " + target);
			return result;
		}
		
		/**
		 * 更新对象池的对象备案，在此备案中的对象都归对象池管理
		 *
		 * @param	element 需要备案的池元素
		 *
		 */
		private function updateRecordMap(element:IObjectPoolElement):void
		{
			(!_record.isContainsKey(element.target)) && _record.put(element.target, element);
		}
		
		/**
		 * 从对象备案中删除对象备案，从此备案中删除的对象不再由对象池管理
		 *
		 * @param key
		 *
		 */
		private function deleteRecord(key:*):void
		{
			_record.remove(key);
		}
		
		/**
		 * 判断对象是否正在被放回对象池
		 *
		 * @return
		 */
		public function isTargetReseting(target:*):Boolean
		{
			return _reseting.isContainsKey(target);
		}
		
		/**
		 * 判断指定类的对象是否有可能在对象池管理器中创建
		 *
		 * @param cls
		 * @return
		 *
		 */
		public function isPoolClass(cls:Class):Boolean
		{
			return (!!_pools) && _pools.isContainsKey(cls);
		}
		
		/**
		 * 输出对象池日志
		 *
		 * @param args
		 *
		 */
		private function poolLog(... args):void
		{
			(isShowLog) && LogsManager.getInstance().setLog.apply(LogsManager.getInstance(), args);
		}
		
		/**
		 * 查看对象池中管理的对象概览
		 *
		 */
		public function overView():void
		{
			var canLog:Boolean = isShowLog;
			(!isShowLog) && (isShowLog = true);
			poolLog("【POOL OBJECT OVERVIEW】overview start...");
			var i:int = 0;
			var list:Array = _used.keys;
			var max:int = list.length
			var content:String = "";
			var op:IObjectPoolElement;
			(_log == null) && (_log = new HashMap());
			while (i < max)
			{
				op = _used.getValue(list[i]) as IObjectPoolElement;
				var temp:int = _log.getInt(op.className);
				(isNaN(temp)) && (temp = 0);
				temp++;
				_log.put(op.className, temp);
				i++;
			}
			i = 0;
			list = _log.keys;
			max = list.length;
			while (i < max)
			{
				var clsName:String = list[i];
				var n:int = _log.getInt(clsName);
				(isNaN(n)) && (n = 0);
				var m:int = _pools.getValue(getMaxKey(clsName));
				var u:String = (m > 0) ? (n + "/" + m) : (n + "/x");
				content += " - " + clsName + " used " + u + "\r";
				i++;
			}
			_log.clear();
			poolLog(content);
			poolLog("【POOL OBJECT ELEMENTS】Not use is " + this._elements.length);
			poolLog("【POOL OBJECT OVERVIEW】overview end...");
			isShowLog = canLog;
		}
	}

}