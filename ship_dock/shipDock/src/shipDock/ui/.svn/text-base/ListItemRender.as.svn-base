package shipDock.ui 
{
	import shipDock.framework.application.component.SDSprite;
	import shipDock.ui.events.ItemRenderEvent;
	
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.events.TouchPhase;
	
	/**
	 * 
	 * 控件基类
	 * 
	 * ...
	 * @author HongSama
	 * 
	 */
	public class ListItemRender extends SDSprite
	{
		protected var posX:Number = 0;
		protected var posY:Number = 0;
		
		public var index:int;//索引，在列表类控件中使用
		public var layers:Array = [];//显示层次，用于方便画家算法实现渲染
		public var batchRender:BatchRender;//项选择器
		
		protected var data:Object;//控件所需的数据或配置
		protected var itemHeight:Number;//项高
		protected var itemWidth:Number;//项宽
		
		private var _layerCount:int = 0;//渲染层次数量，层次数量与渲染批次相同
		private var checkItem:DisplayObject;
		
		public function ListItemRender(data:Object, index:int, itemWidth:Number, itemHeight:Number, batchRender:BatchRender)
		{
			super();
			this.itemWidth = itemWidth;
			this.itemHeight = itemHeight;
			this.batchRender = batchRender;
			this.data = data;
			this.index = index;
			initPos();
			initItemRender();
		}
		
		protected function initItemRender():void 
		{
			layers = [];
		}
		
		protected function initPos():void
		{
			
		}
		
		/*
		 * 添加一个显示对象到最顶的层中
		 * 
		*/
		protected function addToLayer(display:DisplayObject):void
		{
			layers[layers.length - 1].push(display);
			if (display)
			{
				addChild(display);
			}
		}
		
		/*
		 * 添加一个显示对象到新层中
		 * 
		*/
		protected function pushToLayer(display:DisplayObject):void
		{
			layers.push([]);
			if (display)
			{
				addToLayer(display);
			}
			_layerCount++;
		}
		
		/*
		 * 触屏碰撞检测
		 * 
		 * @params phase 触屏状态，取值范围为 TouchPhase 中的静态值
		 * @params p 坐标点对象
		 * 
		*/
		public function checkhitTest(phase:String,p:Point):ListItemRender
		{
			if (layers.length == 0)
			{
				p = globalToLocal(p);
			}
			checkItem = hitTest(p);
			var res:Boolean;
			if (checkItem != null)
			{
				switch (phase)
				{
					case TouchPhase.BEGAN:
						res = beginEffect(p);
						break;
					case TouchPhase.MOVED:
						res = moveEffect(p);
						break;
					case TouchPhase.ENDED:
						res = endEffect(p);
						break;
					default:
						break;
				}
			}
			if (res)
			{
				return this;
			}
			return null;
		}
		
		/*
		 * 释放内存的占用
		 * 
		*/
		public function release():void 
		{
			removeChildren();
			this.dispose();
		}
		
		/*
		 * 触屏开始时的效果
		 * 
		*/
		protected function beginEffect(p:Point):Boolean 
		{
			return true;
		}
		
		/*
		 * 在屏幕上滑动时的效果
		 * 
		*/
		protected function moveEffect(p:Point):Boolean
		{
			return true;
		}
		
		/*
		 * 在屏幕上滑动结束时的效果
		 * 
		*/
		protected function endEffect(p:Point):Boolean 
		{
			return true;
		}
		
		/*
		 * 派发触屏点击事件
		 * 
		*/
		protected function dispatchClickEvent(type:int = 0):void
		{
			var e:ItemRenderEvent = new ItemRenderEvent(ItemRenderEvent.CHOOSER_EVENT, index, type);
			dispatchEvent(e);
		}
		
		/*
		 * 派发控件更新事件
		 * 
		*/
		protected function dispatchRefreshEvent(type:int = -1):void
		{
			var e:ItemRenderEvent = new ItemRenderEvent(ItemRenderEvent.REFRESH_EVENT, index, type);
			dispatchEvent(e);
		}
		
		public function get layerCount():int 
		{
			return _layerCount;
		}
	}
}