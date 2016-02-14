package shipDock.framework.core.model
{
	import shipDock.framework.core.interfaces.IModel;
	
	/**
	 * 数据模型基类
	 *
	 * ...
	 * @author ch.ji
	 */
	public class DataModel implements IModel
	{
		
		private var _id:String; //数据id
		private var _type:int; //数据模型的类型
		private var _name:String;
		
		public function DataModel()
		{
		}
		
		public function dispose():void
		{
			this._id = null;
			this._type = -1;
			this._name = null;
		}
		
		public function clone():IModel
		{
			var result:DataModel = new DataModel();
			result.id = this._id;
			return result;
		}
		
		protected function setName(value:String):void
		{
			this._name = value;
		}
		
		/*
		 * 先检测数据源source是否存在keyField 字段，再将字段keyField 对应的数据存入 Model 的属性 property
		 *
		 * @params keyField 数据源source的字段名
		 * @params property Model的属性名，此属性必须存在定义才能成功存入数据
		 * @params source 数据源
		 *
		 */
		public function checkAndSet(keyField:String, property:String, source:Object):Boolean
		{
			var result:Boolean;
			if (keyField == null)
				return false;
			(property == null) && (property = keyField);
			if (source.hasOwnProperty(keyField) && this.hasOwnProperty(property))
			{
				result = true;
				this[property] = source[keyField];
			}
			return result;
		}
		
		public function updateData(data:Object):void
		{
		}
		
		public function getList(name:String):Array
		{
			return this[name] as Array;
		}
		
		public function getNumber(name:String):Number
		{
			return Number(this[name]);
		}
		
		public function getInt(name:String):int
		{
			return int(this[name]);
		}
		
		public function getText(name:String):String
		{
			return String(this[name]);
		}
		
		public function set id(value:String):void
		{
			this._id = value;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get modelType():int
		{
			return this._type;
		}
		
		public function get name():String
		{
			return this._name;
		}
		
		public function get modelData():Object
		{
			return null;
		}
	}

}