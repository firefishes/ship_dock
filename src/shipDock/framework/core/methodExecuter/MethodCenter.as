package shipDock.framework.core.methodExecuter 
{
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.utils.gc.reclaim;
	import shipDock.framework.core.utils.HashMap;
	
	/**
	 * 回调函数中心
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class MethodCenter implements IDispose
	{
		
		/*函数执行器集合*/
		private var _methodMap:HashMap;
		
		public function MethodCenter() 
		{
			this._methodMap = new HashMap();
		}
		
		/**
		 * 销毁这个函数中心对象
		 * 
		 */
		public function dispose():void {
			this.clear();
			this.purge();
		}
		
		protected function purge():void {
			reclaim(this._methodMap);
			this._methodMap = null;
		}
		
		/**
		 * 向函数中心添加函数执行器
		 * 
		 * @param	id 与函数执行器对应的id名
		 * @param	method 函数执行器包含的函数
		 * @param	args 函数执行器执行函数所需的参数
		 * @param	owner 函数执行器执行函数时的作用域
		 * @param	isCover 是否覆盖函数执行器的所有信息
		 */
		public function addCallback(id:String, method:Function, args:Array = null, owner:* = null, isCover:Boolean = false):void {
			var element:MethodElement = this.methodMap.getValue(id);
			if (element != null) {
				if (isCover) {//如果覆盖函数执行器的所有信息，不覆盖则根据各参数是否为空分别替换
					element.reset(method, args, owner);
				}else {
					(args != null) && (element.args = args);//替换参数
					(method != null) && (element.setMethod(method));//替换函数
				}
			}else {//新建函数执行器
				element = new MethodElement(method, args, owner);
				this.methodMap.put(id, element);
			}
		}
		
		/**
		 * 移除添加过的函数执行器
		 * 
		 * @param	id
		 */
		public function removeCallback(id:String):void {
			var element:MethodElement = this.methodMap.remove(id);
			reclaim(element);
		}
		
		/**
		 * 获取一个函数执行器中的函数
		 * 
		 * @param	id
		 * @return
		 */
		public function getCallback(id:String):Function {
			var result:Function;
			var element:MethodElement = this.methodMap.getValue(id);
			(element != null) && (result = element.method);	
			return result;
		}
		
		/**
		 * 执行一个函数执行器里的函数
		 * 
		 * @param	id
		 * @param	args
		 * @param	thisArgs
		 * @return
		 */
		public function useCallback(id:String, args:Array = null, thisArgs:* = null, isRemove:Boolean = false):* {
			var result:*;
			var element:MethodElement = this.methodMap.getValue(id);
			(element) && (result = element.apply(thisArgs, args));
			(isRemove) && this.removeCallback(id);
			return result;
		}
		
		/**
		 * 获取一个函数执行器中的参数列表
		 * 
		 * @param	id
		 * @return
		 */
		public function getMethodArgs(id:String):Array {
			return (this.methodMap.isContainsKey(id)) ? (this.methodMap.getValue(id) as MethodElement).args : [];
		}
		
		/**
		 * 设置一个函数执行器里的参数列表
		 * 
		 * @param	id
		 * @param	args
		 */
		public function setMehodArgs(id:String, args:Array = null):void {
			if (this.methodMap.isContainsKey(id))
				this.addCallback(id, null, args);//修改原有函数执行器的参数
			else
				this.addCallback(id, null, args, null, true);//设置新的函数执行器
		}
		
		/**
		 * 清除函数中心的所有函数执行器
		 * 
		 */
		public function clear():void {
			var keys:Array = this.methodMap.keys;
			for each(var k:* in keys) {
				this.removeCallback(k);
			}
			this.methodMap.clear();
		}
		
		private function get methodMap():HashMap {
			(!this._methodMap) && (this._methodMap = new HashMap());
			return this._methodMap;
		}
	}

}