package shipDock.framework.application.tileMap.base
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.interfaces.ITileObject;
	import shipDock.framework.application.tileMap.SDTileUtils;
	
	import starling.events.Event;
	
	/**
	 * 镜像物件类
	 *  
	 * @author ch.ji
	 * 
	 */	
	public class SDTileObject extends SDSprite implements ITileObject
	{
		
		/*向量速度*/
		private var _vx:Number = 0;
		private var _vy:Number = 0;
		private var _vz:Number = 0;
		/*是否可通过*/
		private var _walkable:Boolean = false;
		/*3d坐标点*/
		private var _tilePoint:SDTilePoint;
		private var _isApplyCallLater:Boolean;
		/*图块尺寸*/
		protected var _size:Number;
		
		public function SDTileObject(size:Number)
		{
			super();
			this._size = size;
			this._tilePoint = new SDTilePoint(0, 0, 0);
			this._isApplyCallLater = true;
		}
		
		override public function dispose():void {
			super.dispose();
			this._tilePoint = null;
		}
		
		public function setTileParams(value:Object):void {
			for(var key:String in value) {
				if(this.hasOwnProperty(key)) {
					this[key] = value[key];
				}
			}
		}
		
		/**
		 * 修改频繁的属性时调用，用于下一帧统一更新 
		 * 
		 */
		public function invalidate():void {
			if(this._isApplyCallLater)
				this.addEventListener(Event.ENTER_FRAME, invalidateHandler);
			else
				this.redraw();
		}
		
		public function invalidateHandler(event:Event = null):void {
			this.removeEventListener(Event.ENTER_FRAME, invalidateHandler);
			this.redraw();
		}
		
		/**
		 * 更新等角地图物件 
		 * 
		 */
		public function redraw():void {
			this.updateTileObject();
		}
		
		public function updateTileObject():void {
			this.updateScreenPos();
		}
		
		/**
		 * 更新运动 
		 * 
		 */
		public function updateMotion():void {
			if(!this.isStill) {
				this._tilePoint.x += this._vx;
				this._tilePoint.y += this._vy;
				this._tilePoint.z += this._vz;
			}
		}
		
		/**
		 * 更新屏幕坐标 
		 * 
		 */
		public function updateScreenPos():void {
//			var point:Point = SDTileUtils.staggeredISOToScreen(this._size, this._tilePoint.x / this._size, this._tilePoint.z / this._size);
			var point:Point = SDTileUtils.diamondISOToScreen(this._tilePoint);
			super.x = point.x;
			super.y = point.y;
		}
		
		public function toString():String {
			return "【SDTILE WORLD】SDTileObject-toString: x=" + this._tilePoint.x + ",y=" + this._tilePoint.y + ",z=" + this._tilePoint.z;
		}
		
		override public function set x(value:Number):void {
			this._tilePoint.x = value;
			this.invalidate();
		}
		
		override public function get x():Number {
			return this._tilePoint.x;
		}
		
		override public function set y(value:Number):void {
			this._tilePoint.y = value;
			this.invalidate();
		}
		
		override public function get y():Number {
			return this._tilePoint.y;
		}
		
		public function set zv(value:Number):void {
			this._tilePoint.z = value;
			this.invalidate();
		}
		
		public function get zv():Number {
			return this._tilePoint.z;
		}
		
		/**
		 * 设置和获取3d坐标点对象
		 *  
		 * @param value
		 * 
		 */
		public function set tilePoint(value:SDTilePoint):void {
			this._tilePoint = value;
			this.invalidate();
		}
		
		public function get tilePoint():SDTilePoint {
			return this._tilePoint;
		}
		
		/**
		 * 
		 * 返回形变后的层深
		 * 
		*/
		public function get depth():Number {
			return (this._tilePoint.x + this._tilePoint.z) * .866 - this._tilePoint.y * .707;
		}
		
		public function get size():Number {
			return this._size;
		}
		
		/**
		 * 获取矩形
		 *  
		 * @return 
		 * 
		 */
		public function get rect():Rectangle {
			return new Rectangle(this.x - this.size / 2, this._tilePoint.z - this.size / 2, this.size, this.size);
		}
		
		public function set vx(value:Number):void {
			this._vx = value;
			this.invalidate();
		}
		
		public function get vx():Number {
			return this._vx;
		}
		
		public function set vy(value:Number):void {
			this._vy = value;
			this.invalidate();
		}
		
		public function get vy():Number {
			return this._vy;
		}
		
		public function set vz(value:Number):void {
			this._vz = value;
			this.invalidate();
		}
		
		public function get vz():Number {
			return this._vz;
		}
		
		public function get isStill():Boolean {
			return ((this._vx == 0) && (this._vy == 0) && (this._vz == 0));
		}
		
		public function get z():Number {
			return (!!this._tilePoint) ? this._tilePoint.z : 0;
		}
		
		public function set z(value:Number):void {
			this._tilePoint.z = value;
			this.invalidate();
		}

		public function get isApplyCallLater():Boolean
		{
			return _isApplyCallLater;
		}

		public function set isApplyCallLater(value:Boolean):void
		{
			_isApplyCallLater = value;
		}

	}
}