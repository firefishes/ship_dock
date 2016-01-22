package shipDock.framework.core.utils
{
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	public class StringUtils
	{
		public function StringUtils()
		{
		}
		
		public static const BITMAPDATA_CLASS_NAME:String = "BitmapData";
		
		/**
		 * 获取对象的类名
		 * 
		 * @param	target 需要获取类名的对象
		 * @param	isFullName 是否获取完全限定名
		 * @param	isGetPackName 是否获取包名
		 * @return
		 */
		public static function qualifiedClassName(target:Object, isFullName:Boolean = false, isGetPackName:Boolean = false):String{
			var result:String = null;
			if(!!target) {
				var className:String = getQualifiedClassName(target);
				 result = (isFullName) ? className : className.split("::")[1];
				(isGetPackName) && (result = className.split("::")[0]);
			}
			return result;
		}
		
		/**
		 * 获取对象的超类类名
		 * 
		 * @param	target 需要获取类名的对象
		 * @param	isFullName 是否获取完全限定名
		 * @param	isGetPackName 是否获取包名
		 *  
		 * @param value
		 * @return 
		 * 
		 */
		public static function qualifiedSuperClassName(target:Object, isFullName:Boolean = false, isGetPackName:Boolean = false):String{
			var result:String = null;
			if(!!target) {
				var className:String = getQualifiedSuperclassName(target);
				result = (isFullName) ? className : className.split("::")[1];
				(isGetPackName) && (result = className.split("::")[0]);
			}
			return result;
		}
		
		/**
		 * 判断对象是否为位图数据
		 *  
		 * @param value
		 * @return 
		 * 
		 */
		public static function isBitmapData(value:Object):Boolean {
			var className:String = qualifiedSuperClassName(value);
			var result:Boolean = false;
			(className == BITMAPDATA_CLASS_NAME) && (result = true);
			return result;
		}
		
		/**
		 * 去掉字符串中两边与特定字符相同的字符
		 *  
		 * @param char
		 * @param character
		 * @return 
		 * 
		 */
		public static function trim(char:String, character:String):String{
            return (trimBack(trimFront(char, character), character));
        }
        
		/**
		 * 去掉字符串中左边与特定字符相同的字符
		 *  
		 * @param char
		 * @param character
		 * @return 
		 * 
		 */
        public static function trimFront(char:String, character:String):String{
            character = stringToCharacter(character);
            (char.charAt(0) == character) && (char = trimFront(char.substring(1), character));
            return char;
        }
        
		/**
		 * 去掉字符串中右边与特定字符相同的字符
		 * 
		 * @param char
		 * @param character
		 * @return 
		 * 
		 */
        public static function trimBack(char:String, character:String):String{
            character = stringToCharacter(character);
            (char.charAt((char.length - 1)) == character) && (char = trimBack(char.substring(0, (char.length - 1)), character));
            return char;
        }
        
        private static function stringToCharacter(char:String):String{
            if (char.length == 1)
                return char;
            return char.slice(0, 1);
        }
        
		/**
		 * 使用参数替代文本中的变量
		 *  
		 * @param str
		 * @param rest
		 * @return 
		 * 
		 */
        public static function substitute(str:String, ... rest):String
	    {
	        // Replace all of the parameters in the msg string.
	        var len:uint = rest.length;
	        var args:Array;
	        if (len == 1 && rest[0] is Array)
	        {
	            args = rest[0] as Array;
	            len = args.length;
	        }
	        else
	            args = rest;

	        for (var i:int = 0; i < len; i++)
	            str = str.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
	
	        return str;
	    }
	    
	    /**
	     * 替换字符的方法
		 * 
	     * @example this is {0} my {1}  
	     * StringUtil.getString("key",["a","test"] 
	     * print this is a my test
	     */ 
	    public static function getString(resource:String,parameters:Array = null):String {
			(parameters) && (resource = StringUtils.substitute(resource, parameters));
	        return resource;
		}
		
		/**
		 * 反转字符串
		 *  
		 * @param value
		 * @return 
		 * 
		 */
		private function reverseString(value:String):String{
            var array:Array = value.split("");
            array.reverse();
            var result:String = array.join("");
            return result;
        }
        
		/**
		 * 首字母大写
		 *  
		 * @param value
		 * @return 
		 * 
		 */
        public static function getFirstUpperCase(value:String):String{
        	return (value.substr(0, 1).toUpperCase() + value.substr(1));
        }
		
		/**
		 * 首字母小写
		 *  
		 * @param value
		 * @return 
		 * 
		 */
		public static function getFirstLowerCase(value:String):String{
			return (value.substr(0, 1).toLowerCase() + value.substr(1));
		}
		
		public static function getRealLines(value:Array):Array {
			var result:Array = [];
			for(var i:int = 0; i < value.length; i++){
				var item:Object = value[i];
				(item) && result.push(item);
			}
			return result;
		}
		
		/**
		 * 英语里的习惯的方式
		 * 
		 */ 
		public static function getFirstName(value:String):String {
			var result:String = value;
			(value && value.indexOf(" ") != -1) && (result = value.substring(0, value.indexOf(" ")));
			return result;
		}
		
		/**
		 * 将带有_符号的变量名转为驼峰命名
		 *  
		 * @param value
		 * @return 
		 * 
		 */
		public static function transToCamelCasing(value:String):String {
			var result:String = value;
			var index:int = result.indexOf("_");
			if(index != -1) {
				var list:Array = result.split("_");
				var tail:String = list[1];
				tail = getFirstUpperCase(tail);
				result = list[0] + tail;
			}
			return result;
		}
		
		public static function getTextureIDByPath(value:String):String {
			var splits:Array = value.split("/");
			value = splits[splits.length - 1];
			return value.split(".")[0];
		}
	}
}