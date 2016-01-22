package shipDock.framework.core.utils 
{
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDMath 
	{
		
		/**
		 * 获取百分比结果
		 * 
		 * @param	current
		 * @param	max
		 * @param	isFloat
		 */
		public static function percent(current:Number, max:Number, isFloat:Boolean = false):Number {
			var result:Number = current / max;
			return (isFloat) ?  result : int(current / max * 100) / 100;
		}
		
		public function SDMath() 
		{
			
		}
		
	}

}