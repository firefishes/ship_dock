package shipDock.framework.core.utils
{
	import flash.utils.Dictionary;
	
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.manager.ObjectPoolManager;
	
	/**
	 * 自制Hash表
	 *
	 * @author shaoxin.ji
	 *
	 */
	public class HashMap implements IDispose, IPoolObject
	{
		private var _keys:Array;
		private var _weakKeys:Boolean;
		private var _dictionary:Dictionary;
		private var _op:ObjectPoolManager;
		
		public function HashMap(weakKeys:Boolean = false)
		{
			_weakKeys = weakKeys;
			init();
		}
		
		public function reinitPoolObject(args:Array):void
		{
			clear();
		}
		
		public function resetPoolObject():void
		{
			clear();
		}
		
		public function dispose():void
		{
			this.clear();
			if (this.isReleaseInPool)
				return;
			this.purge();
		}
		
		protected function purge():void
		{
			_keys = null;
			_dictionary = null;
			_op = null;
		}
		
		/**
		 * 初始化
		 *
		 */
		protected function init():void
		{
			_keys = [];
			_dictionary = new Dictionary(_weakKeys);
		}
		
		/**
		 * 添加所有
		 *
		 * @param map
		 *
		 */
		public function putAll(map:HashMap):void
		{
			this.clear();
			var len:uint = map.size;
			if (len > 0)
			{
				var list:Array = map.keys;
				for (var i:uint = 0; i < len; i++)
				{
					var key:String = list[i];
					put(key, map.getValue(key));
				}
			}
		}
		
		/**
		 * 检查是否包含某个属性
		 *
		 * @param key
		 * @return
		 *
		 */
		public function isContainsKey(key:*):Boolean
		{
			return (_dictionary[key] != null);
		}
		
		/**
		 * 检查是否包含某个值
		 *
		 * @param value
		 * @return
		 *
		 */
		public function isContainsValue(value:*):Boolean
		{
			var result:Boolean;
			for (var key:* in _dictionary)
			{
				if (_dictionary[key] === value)
				{
					result = true;
					break;
				}
			}
			return result;
		}
		
		/**
		 * 保存数据
		 *
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public function put(key:*, value:*):*
		{
			var result:*;
			if (!!_dictionary[key])
			{
				result = _dictionary[key];
			}
			else
			{
				var i:int = _keys.indexOf(key);
				(i == -1) && _keys.push(key);
			}
			_dictionary[key] = value;
			return result;
		}
		
		/**
		 * 移除数据
		 *
		 * @param key
		 * @return
		 *
		 */
		public function remove(key:*):*
		{
			var result:* = _dictionary[key];
			var index:int = getKeyIndex(key);
			(index != -1) && _keys.splice(index, 1);
			(!!result) && (delete _dictionary[key]);
			return result;
		}
		
		public function clear():void
		{
			var i:int = this._keys.length;
			while (i >= 0)
			{
				this.remove(this._keys[i]);
				i--;
			}
			this._keys.length = 0;
		}
		
		/**
		 * 获取键名索引
		 *
		 * @param key
		 * @return
		 *
		 */
		public function getKeyIndex(key:*):int
		{
			return _keys.indexOf(key);
		}
		
		/**
		 * 通过数据获取键名
		 *
		 * @param value
		 *
		 */
		public function getKey(value:*):*
		{
			var key:*;
			var result:*;
			for (key in _dictionary)
			{
				if ((_dictionary[key] === value) && (_keys.indexOf(key) != -1))
				{
					result = key;
					break;
				}
			}
			return result;
		}
		
		/**
		 * 通过键名获取数据
		 *
		 * @param key
		 * @param isDelete
		 * @return
		 *
		 */
		public function getValue(key:*, isDelete:Boolean = false):*
		{
			if (!isContainsKey(key))
				return null;
			var result:* = _dictionary[key];
			(isDelete) && remove(key);
			return result;
		}
		
		/**
		 * 通过索引获取数据
		 *
		 * @param index
		 * @param isDelete
		 * @return
		 *
		 */
		public function getValueByIndex(index:int, isDelete:Boolean = false):*
		{
			var result:*;
			var key:* = keys[index];
			result = getValue(key, isDelete);
			return result;
		}
		
		public function isEmpty():Boolean
		{
			return (size < 1);
		}
		
		public function getNumber(key:*, isDelete:Boolean = false):Number
		{
			return Number(getValue(key, isDelete));
		}
		
		public function getInt(key:*, isDelete:Boolean = false):int
		{
			return int(getValue(key, isDelete));
		}
		
		public function getList(key:*, isDelete:Boolean = false):Array
		{
			return getValue(key, isDelete) as Array;
		}
		
		public function getText(key:*, isDelete:Boolean = false):String
		{
			return String(getValue(key, isDelete));
		}
		
		public function getXML(key:*, isDelete:Boolean = false):XML
		{
			return getValue(key, isDelete) as XML;
		}
		
		public function getMethod(key:*, isDelete:Boolean = false):Function
		{
			return getValue(key, isDelete) as Function;
		}
		
		public function getValueAsType(key:*, type:Class, isDelete:Boolean = false):*
		{
			return getValue(key, isDelete) as type;
		}
		
		/**
		 * 获取数据总数
		 *
		 * @return
		 *
		 */
		public function get size():int
		{
			return int(keys.length);
		}
		
		/**
		 * 获取所有键名
		 *
		 * @return
		 *
		 */
		public function get keys():Array
		{
			return _keys;
		}
		
		public function get isReleaseInPool():Boolean
		{
			return this.op.isReleaseInPool(this);
		}
		
		protected function get op():ObjectPoolManager 
		{
			(!_op) && (_op = ObjectPoolManager.getInstance());
			return _op;
		}
	}
}