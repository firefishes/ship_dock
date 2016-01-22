package shipDock.framework.core.utils
{
	
	/**
	 * 框架工具类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDUtils
	{
		
		/**
		 * 简易 while 循环
		 *
		 * @param	i
		 * @param	max
		 * @param	options
		 */
		public static function wLoop(i:int, max:int, options:Function):void
		{
			if (options == null)
				return;
			var index:int = i;
			while (index < max)
			{
				options(index);
				index++;
			}
		}
		
		/**
		 * 简易 for in 循环
		 *
		 * @param	target
		 * @param	options
		 */
		public static function forIn(target:Object, options:Function):void
		{
			if(options == null)
				return;
			var k:*;
			for (k in target)
			{
				options(k, target);
			}
		}
		
		public static function forEach(target:*, options:Function):void {
			if(options == null)
				return;
			var v:*;
			for each(v in target)
			{
				options(v);
			}
		}
		
		/**
		 * 获取文本宽度
		 *
		 * @param	text
		 * @param	fontSize
		 * @return
		 */
		public static function getTextWidth(text:String, fontSize:int):int
		{
			return text.length * fontSize;
		}
		
		/**
		 * 根据参数创建实例
		 *
		 * @param	cls 需要实例化的类
		 * @param	args 要传递的构造函数参数数组
		 * @return
		 */
		public static function createInstance(cls:Class, args:Array = null):*
		{
			var result:*;
			if (cls == null)
				return;
			if ((args == null) || (args.length == 0))
				result = new cls();
			else
			{
				switch (args.length)
				{
					case 1: 
						result = new cls(args[0]);
						break;
					case 2: 
						result = new cls(args[0], args[1]);
						break;
					case 3: 
						result = new cls(args[0], args[1], args[2]);
						break;
					case 4: 
						result = new cls(args[0], args[1], args[2], args[3]);
						break;
					case 5: 
						result = new cls(args[0], args[1], args[2], args[3], args[4]);
						break;
					case 6: 
						result = new cls(args[0], args[1], args[2], args[3], args[4], args[5]);
						break;
					case 7: 
						result = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
						break;
					case 8: 
						result = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
						break;
					case 9: 
						result = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
						break;
					case 10: 
						result = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
						break;
				}
			}
			return result;
		}
		
		public function SDUtils()
		{
		
		}
	
	}

}