package shipDock.ui
{
	import flash.geom.Point;
	import shipDock.ui.events.ScrollContainerEvent;
	
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.component.SDClipped;
	import shipDock.framework.application.component.SDQuad;
	import shipDock.framework.application.component.SDSprite;
	
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 滚动容器类
	 *
	 * ...
	 * @modify shaoxin.ji
	 */
	public class ScrollContainer extends SDClipped implements IAnimatable
	{
		
		/*是否正在滚动*/
		private var _isScrolling:Boolean = false;
		/*停止时是否重定位*/
		private var _isPos:Boolean;
		/*水平方向的滚动速度*/
		private var _speedX:Number = 0;
		/*垂直方向的滚动速度*/
		private var _speedY:Number = 0;
		/*可滚动区域的最大宽度*/
		private var _maxWidth:Number;
		/*可滚动区域的最大高度*/
		private var _maxHeight:Number;
		/*滚动可视区域的宽度*/
		private var _scrollWidth:Number;
		/*滚动可视区域的高度*/
		private var _scrollHeight:Number;
		/*滚动容器的宽度*/
		private var _containerWidth:Number;
		/*滚动容器的高度*/
		private var _containerHeight:Number;
		/*是否启用回弹效果*/
		private var _springback:Boolean;
		/*回弹的弹性系数*/
		private var _springbackRate:Number = 0.2;
		/*触屏坐标*/
		private var _touchPos:Point;
		/*是否开始滚动*/
		private var _touchStart:Boolean;
		/*滚动容器*/
		private var _container:SDSprite;
		/*滚动完成后的回调函数*/
		private var _touchFun:Function;
		
		/**
		 *
		 * @param	scroll_width	显示宽度
		 * @param	scroll_Height	显示长度
		 * @param	isClip			是否需要遮罩
		 * @param	springback		是否回弹
		 * @param	position		停止时是否定位
		 */
		public function ScrollContainer(scrollW:Number, scrollH:Number, springback:Boolean = true, position:Boolean = false)
		{
			super(scrollW, scrollH, 0, 0);
			
			this._maxWidth = 0;
			this._maxHeight = 0;
			this._isPos = position;
			this._springback = springback;
			this._scrollHeight = scrollH;
			this._scrollWidth = scrollW;
			this._containerHeight = scrollH;
			this._containerWidth = scrollW;
			
			var quad:SDQuad = new SDQuad(scrollW, scrollH);
			quad.alpha = 0;
			super.addChild(quad);
			
			this._container = new SDSprite();
			this.addChild(_container);
			this.addEventListener(TouchEvent.TOUCH, this.scrollContainerTouch);
			//testMode = true; //打开这个注释查看剪辑区域
		}
		
		/**
		 * 设置容器可滚动内容的尺寸
		 *
		 * @param	width
		 * @param	height
		 */
		public function changeContainerSize(width:Number, height:Number):void
		{
			this._containerWidth = width;
			this._containerHeight = height;
			(_containerWidth > _scrollWidth) && (_maxWidth = _containerWidth - _scrollWidth);
			(_containerHeight > _scrollHeight) && (_maxHeight = _containerHeight - _scrollHeight);
			_container.x = Math.max(_container.x, -_maxWidth);
			_container.y = Math.max(_container.y, -_maxHeight);
		}
		
		public function addItem(child:DisplayObject):DisplayObject
		{
			return _container.addChild(child);
		}
		
		public function removeItem(child:DisplayObject):DisplayObject
		{
			return _container.removeChild(child);
		}
		
		/**
		 * 检查目标点
		 * @param	targetX
		 * @param	targetY
		 * @param	back 是否为回弹状态
		 * @return
		 */
		private function checkTargetPos(targetX:Number, targetY:Number, back:Boolean = false):Point
		{
			
			if (_springback && !back)
			{
			}
			else
			{
				targetX = Math.max(targetX, -_maxWidth);
				targetX = Math.min(targetX, 0);
				targetY = Math.max(targetY, -_maxHeight);
				targetY = Math.min(targetY, 0);
			}
			return new Point(targetX, targetY);
		}
		
		private function scrollContainerTouch(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			var pos:Point = touch.getLocation(SDCore.getInstance().starling.stage);
			if (!!touch)
			{
				switch (touch.phase)
				{
					case TouchPhase.BEGAN: 
						scrollBegin(pos);
						break;
					case TouchPhase.MOVED: 
						scrolling(pos);
						break;
					case TouchPhase.ENDED: 
						scrollEnd(pos);
						break;
				}
			}
		}
		
		/**
		 * 点击开始
		 * @param	pos
		 */
		private function scrollBegin(pos:Point):void
		{
			_touchStart = true;
			_touchPos = pos;
			moveEnd();
		}
		
		/**
		 * 移动
		 * @param	pos
		 */
		private function scrolling(pos:Point):void
		{
			if (!_touchStart)
				return;
			_isScrolling = true;
			var distance:Number = Point.distance(pos, _touchPos);
			var disX:Number = pos.x - _touchPos.x;
			var disY:Number = pos.y - _touchPos.y;
			(_scrollHeight >= _containerHeight) && (disY = 0);
			(_scrollWidth >= _containerWidth) && (disX = 0);
			(_container.x > 0 || _container.x < -_maxWidth) && (disX *= _springbackRate);
			(_container.y > 0 || _container.x < -_maxHeight) && (disY *= _springbackRate);
			(disX != 0) && (_speedX = disX);
			(disY != 0) && (_speedY = disY);
			var targetX:Number = _container.x + disX;
			var targetY:Number = _container.y + disY;
			var targetPos:Point = checkTargetPos(targetX, targetY);
			scrollTo(targetPos.x, targetPos.y);
			_touchPos = pos;
		}
		
		/**
		 * 点击结束
		 * @param	pos
		 */
		private function scrollEnd(pos:Point):void
		{
			//container.touchable = true;
			_touchStart = false;
			var distance:Number = Point.distance(pos, _touchPos);
			pos = checkTargetPos(_container.x, _container.y, true);
			
			if (_speedX != 0 || _speedY != 0)
				SDCore.getInstance().juggler.add(this);
			else
				scrollTo(pos.x, pos.y, 0.1, scrollComplete);
		}
		
		/**
		 * 移动到某点
		 * @param	targetX		目标x
		 * @param	targetY		目标y
		 * @param	tween		是否需要缓动
		 * @param	complete	移动后回调
		 */
		public function scrollTo(targetX:Number, targetY:Number, time:Number = 0, complete:Function = null):void
		{
			if (time)
			{
				var obj:Object = {};
				obj.x = targetX;
				obj.y = targetY;
				(!!_touchFun) && (obj.onUpdate = _touchFun);
				(!!complete) && (obj.onComplete = complete);
				SDCore.getInstance().juggler.tween(_container, 0.1, obj);
			}
			else
			{
				_container.x = targetX;
				_container.y = targetY;
				(!!_touchFun) && (_touchFun());
			}
		}
		
		private function scrollComplete():void
		{
			_isScrolling = true;
			dispatchEvent(new ScrollContainerEvent(ScrollContainerEvent.SCROLL_COMPLETE_EVENT));
		}
		
		/**
		 * 停止移动
		 */
		private function moveEnd():void
		{
			SDCore.getInstance().juggler.removeTweens(_container);
			SDCore.getInstance().juggler.remove(this);
		}
		
		public function release():void
		{
			removeEventListeners();
			moveEnd();
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		public function advanceTime(time:Number):void
		{
			var pos:Point;
			if (_speedX != 0 || _speedY != 0)
			{
				var point:Point = new Point(_speedX, _speedY);
				
				if ((_container.x >= 0 || _container.x <= -_maxWidth) && (_container.y >= 0 || _container.y <= -_maxHeight))
					point.normalize(point.length * _springbackRate);
				else
					point.normalize(point.length * 0.9);
				(point.length < 10) && (point = new Point());
				_speedX = point.x;
				_speedY = point.y;
				pos = checkTargetPos(_container.x + _speedX, _container.y + _speedY);
				scrollTo(pos.x, pos.y);
			}
			else
			{
				moveEnd();
				if (!_isPos)
				{
					pos = checkTargetPos(_container.x, _container.y, true);
					scrollTo(pos.x, pos.y, 0.1);
				}
				else
				{
					var index_x:int = Math.round(_container.x / _scrollWidth);
					var index_y:int = Math.round(_container.y / _scrollHeight);
					var targetX:Number = index_x * _scrollWidth;
					var targetY:Number = index_y * _scrollHeight;
					pos = checkTargetPos(targetX, targetY, true);
					scrollTo(pos.x, pos.y, 0.1, scrollComplete);
				}
			}
		}
		
		public function get container():SDSprite 
		{
			return _container;
		}
	}

}