package shipDock.framework.application {
	import starling.animation.Juggler;
	
	/**
	 * 框架独立的动画管理器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDJuggler extends Juggler
	{
		private var _playSpeed:Number = 1; //动画倍率
		
		public function SDJuggler()
		{
			super();
		}
		
		override public function advanceTime(time:Number):void
		{
			var newTime:Number = time * this._playSpeed;
			super.advanceTime(newTime);
		}
		
		/**
		 * getter 动画倍率
		 *
		 */
		public function get playSpeed():Number
		{
			return _playSpeed;
		}
		
		/**
		 * setter 动画倍率
		 *
		 */
		public function set playSpeed(value:Number):void
		{
			_playSpeed = value;
		}
	}

}