package shipDock.framework.application.tileMap
{
	
	import flash.geom.Point;
	
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.SDJuggler;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.interfaces.ICallLater;
	import shipDock.framework.application.interfaces.ITileObject;
	import shipDock.framework.application.tileMap.base.SDTileObject;
	import shipDock.framework.application.tileMap.base.SDTilePoint;
	import shipDock.framework.application.tileMap.tile.SDTile;
	import shipDock.framework.application.tileMap.tileFactory.SDTileObjectFactory;
	import shipDock.framework.core.interfaces.IDispose;
	
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 平角地图容器类
	 * 
	 * @author ch.ji
	 * 
	 */	
	public class SDTileWorld extends SDSprite implements IDispose, ICallLater, IAnimatable
	{
		/*单个图块的尺寸*/
		private var _worldFPS:uint;
		private var _tileRow:uint;
		private var _tileColumn:uint;
		private var _tileSize:Number;
		private var _renderTime:Number;
		private var _renderDelay:Number;
		
		private var _isRedraw:Boolean;
		private var _isApplyCallLater:Boolean;
		private var _isWorldItemChange:Boolean;
		
		private var _juggler:SDJuggler;
		private var _itemsList:Array;
		private var _tileLayer:Sprite;
		private var _itemsLayer:Sprite;
		private var _propertyChanged:Object;
		
		public function SDTileWorld(tileSize:Number, row:uint, column:uint, juggler:SDJuggler = null)
		{
			super();
			this._worldFPS = 60;
			this._renderTime = 0;
			this._renderDelay = 1 / this._worldFPS;
			this._tileSize = tileSize * SDConfig.globalScale;
			this._tileRow = row;
			this._tileColumn = column;
			this._propertyChanged = {};
			if(juggler == null)
				this._isApplyCallLater = false;
			this._juggler = juggler;
			this.initWorld();
		}
		
		override public function dispose():void {
			super.dispose();
			this._itemsLayer.removeChildren();
			this._tileLayer.removeChildren();
			
			this.stop();
			this.removeEvents();
			this.cleanItemsLayer();
			this._propertyChanged = null;
			this._juggler = null;
		}
		
		private function cleanItemsLayer():void {
			var i:int = 0;
			var max:int = this._itemsList.length;
			while(i < max) {
				var item:ITileObject = this._itemsList[i];
				(!!item) && (item.dispose());
				i++;
			}
			this._itemsList = null;
		}
		
		public function advanceTime(time:Number):void {
			if(this.isNeedRender(time))
				this.renderWorld();
		}
		
		protected function isNeedRender(time:Number):Boolean {
			var result:Boolean;
			this._renderTime += time;
			if(this._renderTime >= this._renderDelay) {
				this._renderTime = 0;
				result = true;
			}
			return result;
		}
		
		/**
		 * 渲染操作，进行一些非暂停状态下的常规操作 
		 * 
		 */		
		protected function renderWorld():void {
			(this._isRedraw) && this.redraw();
			this._isRedraw = false;
		}
		
		/**
		 * 重绘操作，进行一些个别的操作 
		 * 
		 */		
		public function redraw():void
		{
			
		}
		
		public function invalidate():void
		{
			if(this._isApplyCallLater)
				this.addEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			else
				this._isRedraw = true;
		}
		
		public function invalidateHandler(event:*=null):void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.invalidateHandler);
			this.redraw();
		}
		
		/**
		 * 更新等角世界 
		 * 
		 */
		public function updateWorld():void {
			if(this.isWorldItemChange) {
				this.sortItems();
				this.isWorldItemChange = false;
			}
		}
		
		/**
		 * 添加一个物件到等角世界中
		 *  
		 * @param item
		 * @param point
		 * 
		 */
		public function addItemToWorld(item:SDTileObject, point:*):void {
			item.tilePoint = this.transItemPoint(point);
			this._itemsLayer.addChild(item as DisplayObject);
			this.addItemToList(item);
		}
		
		/**
		 * 添加一个物件到等角世界的地面
		 *  
		 * @param item
		 * @param point
		 * 
		 */
		public function addItemToFloor(item:SDTileObject, point:*):void {
			item.tilePoint = this.transItemPoint(point);
			this._tileLayer.addChild(item as DisplayObject);
		}
		
		/**
		 * 添加物件阴影
		 *  
		 * @param shadowOwner
		 * @param shadowItem
		 * 
		 */
		public function addItemShadow(shadowOwner:SDTileObject, shadowItem:SDTileObject):void {
			shadowItem.name = shadowOwner.name + "_Shadow";
			var ownerPoint:SDTilePoint = shadowOwner.tilePoint;
			var point:SDTilePoint = new SDTilePoint(ownerPoint.x, 0, ownerPoint.z);
			this.addItemToFloor(shadowItem, point);
		}
		
		/**
		 * 添加新物件到清单里，维护物件清单
		 *  
		 * @param item
		 * 
		 */
		private function addItemToList(item:ITileObject):void {
			this.isWorldItemChange = true;
			this._itemsList.push(item);
			this.invalidate();
		}
		
		/**
		 * 从物件清单里移除一个物件，维护物件清单
		 *  
		 * @param item
		 * @return 
		 * 
		 */
		private function removeItemFromList(item:ITileObject):ITileObject {
			var result:ITileObject;
			this.isWorldItemChange = true;
			var index:uint = this._itemsList.indexOf(item);
			if(index != -1) {
				this._itemsList.splice(index, 1);
				result = item;
			}
			this.invalidate();
			return result;
		}
		
		private function transItemPoint(point:*):SDTilePoint {
			var result:SDTilePoint;
			if(point is Point) {
				result = SDTileUtils.diamondScreenToISO(point);
				result.x = Math.round(result.x / this._tileSize) * this._tileSize;
				result.y = Math.round(result.y / this._tileSize) * this._tileSize;
				result.z = Math.round(result.z / this._tileSize) * this._tileSize;
			}else if(point is SDTilePoint) {
				result = point;
			}
			return result;
		}
		
		private function sortItems():void {
			this._itemsList.sortOn("depth", Array.NUMERIC);
			var i:uint = 0;
			while(i < this._itemsList.length) {
				var item:DisplayObject = this._itemsList[i] as DisplayObject;
				this._itemsLayer.setChildIndex(item, i);
				i++;
			}
		}
		
		protected function initWorld():void {
			this.addEvents();
			this._itemsList = [];
			this._tileLayer = new Sprite();
			this._itemsLayer = new Sprite();
			this.createTiles();
		}
		
		protected function addEvents():void {
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		protected function removeEvents():void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		override protected function addedToStageHandler(event:Event = null):void {
			super.addedToStageHandler(event);
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.initView();
			this.start();
		}
		
		/**
		 * 初始化界面 
		 * 
		 */
		protected function initView():void {
			this.addChild(this._tileLayer);
			this.addChild(this._itemsLayer);
		}
		
		public function start():void {
			(!!this._juggler) && (this._juggler.add(this));
		}
		
		public function stop():void {
			(!!this._juggler) && (this._juggler.remove(this));	
		}
		
		protected function createTiles():void {
			var total:uint = this._tileRow * this._tileColumn;
			var i:uint, j:uint, params:Object, tile:ITileObject, cls:Class;
			while(total > 0) {
				params = this.getTileParams(total);
				cls = this.getTileClass(total);
				tile = SDTileObjectFactory.createInstance(cls, this._tileSize, params);
				i = total % this._tileRow;
				j = Math.ceil(total / this._tileColumn);
				tile.tilePoint = new SDTilePoint(i * this._tileSize*0.5, 0, j * this._tileSize*0.5);
				tile.redraw();
				this._tileLayer.addChild(tile as DisplayObject);
				total--;
			}
		}
		
		protected function getTileClass(index:int):Class {
			return SDTile;
		}
		
		protected function getTileParams(index:int):Object {
			return null;
		}
		
		protected function updateItemsMotion():void {
			for each(var item:ITileObject in this._itemsList) {
				item.updateMotion();
//				if(item is IPhysicalTileObject) {
//					if(item.x > 380)
//					{
//						item.x = 380;
//						(item as SDPhysicalTileObject).bounceMotion();
//					}
//					else if(item.x < 0)
//					{
//						item.x = 0;
//						(item as SDPhysicalTileObject).bounceMotion();
//					}
//					if(item.z > 380)
//					{
//						item.z = 380;
//						(item as SDPhysicalTileObject).bounceMotion();
//					}
//					else 
//					if(item.z < 0)
//					{
//						item.z = 0;
//						(item as SDPhysicalTileObject).bounceMotion();
//					}
//					if(item.y > 0)
//					{
//						item.y = 0;
//						(item as SDPhysicalTileObject).bounceMotion();
//					}
//					(item as SDPhysicalTileObject).frictionMotion();
//				}
			}
		}

		public function get isApplyCallLater():Boolean
		{
			return this._isApplyCallLater;
		}
		
		public function set isApplyCallLater(value:Boolean):void
		{
			this._isApplyCallLater = value;
		}

		public function get worldFPS():uint
		{
			return _worldFPS;
		}

		public function set worldFPS(value:uint):void
		{
			_worldFPS = value;
		}

		public function get isWorldItemChange():Boolean
		{
			return _isWorldItemChange;
		}

		public function set isWorldItemChange(value:Boolean):void
		{
			_isWorldItemChange = value;
		}

//		override public function set x(value:Number):void {
//			
//		}
	}
}