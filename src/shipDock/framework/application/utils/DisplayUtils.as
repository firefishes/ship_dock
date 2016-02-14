package shipDock.framework.application.utils
{
	import flash.display.DisplayObjectContainer;
	import starling.events.Event;
	
	import shipDock.framework.application.SDConfig;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * 显示对象操作工具类，支持starling和原生显示对象
	 * 
	 * ...
	 * @author ch.ji
	 */
	public class DisplayUtils
	{
		
		/**
		 * 设置注册点位置
		 * 
		 * @param	target
		 * @param	x
		 * @param	y
		 */
		public static function setPovit(target:starling.display.DisplayObject, x:Number, y:Number):void
		{
			target.pivotX = x;
			target.pivotY = y;
		}
		
		/**
		 * 重置注册点位置
		 * 
		 * @param	target
		 */
		public static function rePivot(target:starling.display.DisplayObject):void
		{
			target.pivotX = target.width >> 1;
			target.pivotY = target.height >> 1;
		}
		
		/**
		 * 居中
		 *
		 * @param	target
		 * @param	w 相对此宽度居中
		 * @param	h 相对此高度居中
		 */
		public static function alignCenter(target:*, w:Number = 0, h:Number = 0):void
		{
			alignH(target, w);
			alignV(target, h);
		}
		
		/**
		 * 横向居中
		 * 
		 * @param	target
		 * @param	w
		 */
		public static function alignH(target:*, w:Number = 0):void
		{
			if (target == null)
				return;
			if (w != 0)
			{
				var ratio:Number = (target is SDConfig.displayCls) ? SDConfig.globalScale : 1;
				var offset:Number = (target is SDConfig.displayCls) ? SDConfig.mainOffsetX : 0;
				target.x = (w - int(target.width * ratio)) / 2 - offset;
			}
		}
		
		/**
		 * 垂直居中
		 * 
		 * @param	target
		 * @param	h
		 */
		public static function alignV(target:*, h:Number = 0):void
		{
			if (target == null)
				return;
			if (h != 0)
			{
				var ratio:Number = (target is SDConfig.displayCls) ? SDConfig.globalScale : 1;
				var offset:Number = (target is SDConfig.displayCls) ? SDConfig.mainOffsetX : 0;
				target.y = (h - int(target.height * ratio)) / 2 - offset;
			}
		}
		
		/**
		 * 根据path获取子对象
		 * 
		 * @param	container
		 * @param	path 例如 "a/b/c/d"
		 * @return
		 */
		public static function getChildByPath(container:*, path:String = ""):*
		{
			var result:*;
			if ((container is SDConfig.containerCls) || (container is SDConfig.containerRawCls))
			{
				var list:Array = path.split("/");
				while (list.length > 0)
				{
					var name:String = list.shift();
					result = container.getChildByName(name);
				}
			}
			return result;
		}
		
		/**
		 * 从显示列表移除显示对象
		 * 
		 * @param	child
		 * @param	isDispose
		 */
		public static function removeFromDisplay(child:*, isDispose:Boolean = false):void
		{
			if(child == null)
				return;
			if (child is SDConfig.displayCls)
				child.removeFromParent(isDispose);
			else if (child is SDConfig.displayRawCls)
				(child.parent) && child.parent.removeChild(child);
		}
		
		/**
		 * 移除显示对象的所有子显示对象
		 * 
		 * @param	container
		 */
		public static function removeChildren(container:*):void {
			if (!container)
				return;
			if (container is SDConfig.containerCls)
				container.removeChildren();
			else if (container is SDConfig.containerRawCls) {
				while (container.numChildren > 0) {
					container.removeChildAt(0);
				}
			}
		}
		
		public function DisplayUtils()
		{
		
		}
	
	}

}