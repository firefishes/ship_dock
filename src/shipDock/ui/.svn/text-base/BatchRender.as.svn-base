package shipDock.ui
{
	import flash.geom.Point;
	import shipDock.framework.application.component.SDQuadBatch;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.ui.events.ItemRenderEvent;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.QuadBatch;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 项选择器
	 * 
	 * ...
	 * @author HongSama
	 */
	public class BatchRender extends SDSprite
	{
		
		public var itemWidth:Number;//项宽
		public var itemHeight:Number;//项高
		public var dataProvider:Array;//所有项的数据
		public var renderItems:Array = [];//条目项集合
		public var currentPage:int = 0;//当前页索引
		public var totalPage:int = 0;//总页数
		public var pageCount:int;//每页容纳的项数量
		public var pageIndex:int;
		
		protected var itemRenderClass:Class;//条目渲染类，一个项选择器中容纳的条目渲染对象的渲染层次都是一致的
		protected var layerCount:int = 0;//需要渲染的层次数量
		
		private var _quads:Array = [];//四边形渲染批次列表，便于利用画家算法增强渲染性能
		private var _itemTouchable:Boolean = true;//渲染的项是否可被点击
		private var _bg:DisplayObjectContainer;//控件背景
		private var _touchalbeSwitch:Boolean = false;//上一次设置的渲染项是否可被点击开关值
		
		public function BatchRender(batchData:Array, itemRenderCls:Class, itemWidth:Number, itemHeight:Number, bg:DisplayObjectContainer = null, pageCount:int = 0)
		{
			super();
			this.pageCount = pageCount;
			if (pageCount <= 0)
			{
				totalPage = 1;
			}
			else
			{
				totalPage = Math.ceil(batchData.length / pageCount);
			}
			if (bg)
			{
				_bg = bg;
				addChild(bg);
			}
			this.dataProvider = batchData;
			this.itemRenderClass = itemRenderCls;
			this.itemHeight = itemHeight;
			this.itemWidth = itemWidth;
			initBatchRender();
			updateBatchRender();
			addEventListener(TouchEvent.TOUCH, onTouch);//添加屏幕触摸事件
		}
		
		/*
		 * 检测是否为第一页
		 * 
		*/
		public function firstPage():Boolean
		{
			return (currentPage == 0);
		}
		
		/*
		 * 检测是否为最后一页
		 * 
		*/
		public function finalPage():Boolean
		{
			return (currentPage >= (totalPage - 1));
		}
		
		/*
		 * 触屏事件处理函数
		 * 
		*/
		protected function onTouch(e:TouchEvent):void
		{
			if (itemTouchable)
			{
				var touch:Touch = e.touches[0];
				checkHitTest(touch);
				
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						break;
					case TouchPhase.MOVED:
						break;
					case TouchPhase.ENDED:
						onChooserTouchEnd(e);
						break;
				}
			}
		}
		
		/*
		 * 触屏完成事件的回调函数
		 * 
		*/
		protected function onChooserTouchEnd(e:TouchEvent):void 
		{
			
		}
		
		/*
		 * 触屏碰撞检测
		 * 
		*/
		private function checkHitTest(touch:Touch):void
		{
			var p:Point = new Point(touch.globalX, touch.globalY);
			if (layerCount > 0)
			{
				p = globalToLocal(p);
			}
			var length:int = renderItems.length;
			var view:ListItemRender;
			for (var i:int = 0; i < length; i++)
			{
				view = renderItems[i];
				if (view != null)
				{
					var res:ListItemRender = view.checkhitTest(touch.phase, p);
					if (res != null)
					{
						break;
					}
				}
			}
		}
		
		/*
		 * 初始化
		 * 
		*/
		protected function initBatchRender():void
		{
			var length:int = dataProvider.length;//生成所有项
			var view:ListItemRender;
			var i:int = 0;
			for (i; i < length; i++)
			{
				if (pageCount > 0)
				{
					view = new itemRenderClass(dataProvider[i], i % pageCount , itemWidth, itemHeight, this);
				}
				else
				{
					view = new itemRenderClass(dataProvider[i], i , itemWidth, itemHeight, this);
				}
				view.addEventListener(ItemRenderEvent.CHOOSER_EVENT, onItemClick);//给渲染项添加点击事件
				view.addEventListener(ItemRenderEvent.REFRESH_EVENT, onSetPage);//给渲染项添加更新事件
				renderItems.push(view);
				view.batchRender = this;
			}
			if (renderItems.length > 0)//根据层次初始化四边形渲染批次
			{
				view = renderItems[0] as ListItemRender;
				layerCount = view.layerCount;
			}
			else
			{
				layerCount = 0;
			}
			_quads = [];
			var quad:QuadBatch;
			for (i = 0; i < layerCount; i++)
			{
				quad = new SDQuadBatch();
				_quads.push(quad);
				addChild(quad);
			}
		}
		
		/*
		 * 更新事件处理函数
		 * 
		*/
		private function onSetPage(e:ItemRenderEvent):void 
		{
			if (e.eventType < 0)
			{
				updateBatchRender();//更新整页
			}
			else
			{
				setPageAt(e.eventType);//更新页中一个渲染层次的内容
			}
		}
		
		/*
		 * 一个渲染项被点击的事件处理函数
		 * 
		*/
		private function onItemClick(e:ItemRenderEvent):void 
		{
			dispatchEvent(e);
		}
		
		/*
		 * 设置要显示的页
		 * 
		*/
		public function updateBatchRender():void
		{
			if (layerCount == 0)
			{
				for (var k:int = 0; k < renderItems.length; k++)
				{
					addChild(renderItems[k]);
				}
				return;
			}
			
			var item:DisplayObject;
			for (var s:int = 0; s < layerCount; s++)
			{
				setPageAt(s);
			}
			//dispatchEvent(new Event("setPageOk"));//setPageOk 事件已改为 SDItemRenderEvent.SET_PAGE_OK_EVENT 事件
			dispatchEvent(new Event(ItemRenderEvent.SET_PAGE_OK_EVENT));
		}
		
		/*
		 * 设置显示页上一个渲染层次上的内容
		 * 
		 * 将项对象中同一个层次中的所有内容添加到一个渲染批次对象中显示
		 * 
		*/
		public function setPageAt(layerCount:int):void
		{
			var s:int = layerCount;
			var quad:SDQuadBatch = _quads[s];
			quad.reset();
			quad.visible = false;
			
			var view:ListItemRender;
			var quadLength:int;
			var viewLength:int = renderItems.length;
			if (pageCount > 0)
			{
				viewLength = Math.min(viewLength, (1 + currentPage) * pageCount);
			}
			for (var i:int = currentPage * pageCount; i < viewLength; i++)
			{
				view = renderItems[i];
				if (view.layers[s] != null)
				{
					quadLength = view.layers[s].length;
					for (var j:int = 0; j < quadLength; j++)
					{
						if (view.layers[s][j])
						{
							quad.addChild(view.layers[s][j]);
							quad.visible = true;
						}
					}
				}
			}
		}
		
		/*
		 * 更新选择器
		 * 
		 * 整页更新
		 * 
		*/
		public function refresh():void
		{
			release();
			if (_bg)
			{
				addChild(_bg);
			}
			initBatchRender();
			updateBatchRender();
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/*
		 * 释放内存占用
		 * 
		*/
		public function release():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			var length:int = _quads.length;
			for (var i:int = 0; i < length; i++)
			{
				QuadBatch(_quads[i]).dispose();
			}
			var view:ListItemRender;
			for (var j:int = 0; j < renderItems.length; j++)
			{
				if (renderItems[j])
				{
					view = renderItems[j];
					view.removeEventListeners();
					ListItemRender(renderItems[j]).release();
				}
			}
			this._quads = [];
			this.renderItems = [];
			removeChildren();
		}
		
		/*
		 * 设置和获取渲染项是否可被点击
		 * 
		*/
		public function get itemTouchable():Boolean 
		{
			return _itemTouchable;
		}
		
		public function set itemTouchable(value:Boolean):void 
		{
			_touchalbeSwitch = _itemTouchable;
			_itemTouchable = value;
			if (!itemTouchable && _touchalbeSwitch)
			{
				var len:int = renderItems.length;
				for (var i:int = 0; i < len; i++ )
				{
					//所有按钮弹起
					//if (views[i] as ActiveView) views[i].allBtnUp();
				}
				updateBatchRender();
			}
		}
	}

}