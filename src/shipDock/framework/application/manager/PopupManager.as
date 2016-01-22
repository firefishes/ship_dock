package shipDock.framework.application.manager
{
	import shipDock.framework.application.component.SDQuad;
	import shipDock.framework.application.SDConfig;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.application.events.UIEvent;
	import shipDock.framework.application.interfaces.IData;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.application.interfaces.IPopup;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.ui.IView;
	import shipDock.framework.application.utils.DisplayUtils;
	import shipDock.framework.core.utils.HashMap;
	import shipDock.framework.core.singleton.SingletonBase;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.EventDispatcher;
	
	/**
	 * 弹窗管理器（单例）
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class PopupManager extends SingletonBase
	{
		public static const POPUP_MANAGER:String = "popupMgr";
		
		public static function getInstance():PopupManager
		{
			return SingletonManager.singletonManager().getSingleton(POPUP_MANAGER) as PopupManager;
		}
		
		private var _width:Number;
		private var _height:Number;
		private var _popupContainer:DisplayObjectContainer;
		private var _popups:Vector.<DisplayObject>;
		private var _modalMaskers:HashMap;
		
		public function PopupManager()
		{
			super(this, POPUP_MANAGER);
			this._width = SDCore.getInstance().rawStage.stageWidth;
			this._height = SDCore.getInstance().rawStage.stageHeight;
			
			this._popups = new Vector.<DisplayObject>();
			this._modalMaskers = new HashMap();
		}
		
		public function setPopupContainer(target:DisplayObjectContainer):void
		{
			this._popupContainer = target;
		}
		
		/**
		 * 弹出一个弹窗
		 *
		 * @param	popup 弹出对象
		 * @param	data 弹窗数据
		 * @param	modal 是否带屏蔽层
		 */
		public function addPopup(popup:DisplayObject, data:Object = null, modal:Boolean = true):void
		{
			if (this._popupContainer == null)
				return;
			var modalMask:SDQuad;
			if (this._modalMaskers.isContainsKey(popup))
			{
				var index:int = this._popups.indexOf(popup);
				(index != -1) && this._popups.splice(index, 1);
				(this._popupContainer.contains(popup)) && this._popupContainer.removeChild(popup);
				modalMask = this._modalMaskers.getValue(popup, true) as SDQuad;
				(!!modalMask) && this._popupContainer.removeChild(modalMask);
			}
			if (modal)
			{
				modalMask = this.getModalMasker();
				this._modalMaskers.put(popup, modalMask);
				this._popupContainer.addChild(modalMask);
			}
			(popup is IPopup) && (popup as IPopup).setPopup(true);
			var isView:Boolean = popup is IView;
			if (isView)
			{
				var view:IView = popup as IView;
				view.data = data;
				(view as EventDispatcher).addEventListener(UIEvent.CREATION_EVENT, this.viewCreatedComplete);
				view.loadViewTextures(); //启动view类的显示机制
			}
			else
				(popup is IData) && ((popup as IData).data = data);
			this.alignCenter(popup);
			this._popups.push(popup);
			
			(!isView) && this._popupContainer.addChild(popup);
		}
		
		private function viewCreatedComplete(event:UIEvent):void
		{
			var target:EventDispatcher = event.target;
			target.removeEventListener(UIEvent.CREATION_EVENT, this.viewCreatedComplete);
			
			this.alignCenter(target as DisplayObject);
			
			var modalMask:SDQuad = this._modalMaskers.getValue(target) as SDQuad;
			if (!!modalMask)
			{
				if (!!modalMask.parent)
				{
					var index:int = modalMask.parent.getChildIndex(modalMask as DisplayObject);
					this._popupContainer.addChildAt(target as DisplayObject, index + 1);
				}
			}
			else
				this._popupContainer.addChild(target as DisplayObject);
		}
		
		private function alignCenter(target:DisplayObject):void
		{
			if (SDCore.getInstance().rawStage == null)
				return;
			var w:Number = SDCore.getInstance().rawStage.stageWidth;
			var h:Number = SDCore.getInstance().rawStage.stageHeight;
			DisplayUtils.alignCenter(target, w, h);
		}
		
		/**
		 * 获取一个弹出窗口
		 *
		 * @param	index
		 * @return
		 */
		public function getPopup(index:int = int.MAX_VALUE):DisplayObject
		{
			if (this._popups.length == 0)
				return null;
			
			if (index < 0)
				index = 0;
			else if (index >= this._popups.length)
				index = this._popups.length - 1;
			return this._popups[index] as DisplayObject;
		}
		
		/**
		 * 移除一个弹窗
		 *
		 * @param	popup
		 */
		public function removePopup(popup:DisplayObject):void
		{
			if (this._popupContainer == null)
				return;
			if (popup is IPopup)
				(popup as IPopup).setPopup(false);
			if (this._modalMaskers.isContainsKey(popup))
			{ //带有屏蔽层
				var modalMask:SDQuad = this._modalMaskers.getValue(popup, true) as SDQuad;
				(!!modalMask) && this._popupContainer.removeChild(modalMask);
				this.closePopup(popup);
				
			}
			else
				this.closePopup(popup); //不带屏蔽层
			this.checkClear();
		}
		
		/**
		 * 关闭弹窗并销毁的基本方法
		 *
		 * @param	popup
		 */
		private function closePopup(popup:DisplayObject):void
		{
			var index:int = this._popups.indexOf(popup);
			(index != -1) && this._popups.splice(index, 1);
			(this._popupContainer.contains(popup)) && this._popupContainer.removeChild(popup);
			(popup is IDispose) && (popup as IDispose).dispose();
		}
		
		public function setPopupVisible(popup:DisplayObject, visible:Boolean):void
		{
			if (this._modalMaskers.isContainsKey(popup))
			{
				popup.visible = visible;
				var modalMask:SDQuad = this._modalMaskers.getValue(popup, true) as SDQuad;
				(!!modalMask) && (modalMask.visible = visible);
			}
		}
		
		public function removeAllPopups():void
		{
			if (this._popupContainer == null)
				return;
			this._popupContainer.removeChildren();
		}
		
		private function checkClear():void
		{
			(this._popups.length == 0) && this._popupContainer.removeChildren();
		}
		
		private function getModalMasker(color:uint = 0x000000):SDQuad
		{
			var modalMasker:SDQuad = new SDQuad(SDConfig.stageWidth, SDConfig.stageHeight, color);
			modalMasker.alpha = 0.7;
			return modalMasker;
		}
		
		public function hasPopup(popup:*):Boolean
		{
			if (popup is Class)
			{
				var popupCls:Class = popup as Class;
				for (var i:int = 0; i < _popups.length; i++)
				{
					if (_popups[i] is popupCls)
						return true;
				}
			}
			else
				return _popups.indexOf(popup) != -1;
			
			return false;
		}
	
	}

}