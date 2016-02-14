package shipDock.ui
{
	import shipDock.framework.application.component.SDComponent;
	import shipDock.framework.application.component.SDQuadButton;
	import shipDock.framework.application.interfaces.ISelectable;
	import shipDock.ui.events.ItemClickEvent;
	
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	
	/**
	 * 按钮条控件
	 * 
	 * 默认使用 SDQuadButton 类创建此控件
	 * 
	 * @author shaoxin.ji
	 * 
	 */
	public class ButtonBar extends SDComponent
	{
		
		private var _dataProvider:Array;//按钮条的数据集合
		private var _buttonItemClass:Class;//按钮条单个按钮使用的类，默认使用SDQuadButton类
		private var _buttonList:Array;//按钮列表
		private var _gap:Number = 0;//按钮间隔
		private var _selectedIndex:int = -1;//当前被选中的按钮索引
		private var _selectedItem:Object;//当前被选中的按钮数据
		private var _isTriggerBar:Boolean;//是否为开启按钮条的互斥功能
		private var _buttonWidth:Number = 0;//一个按钮的宽度
		private var _isLayout:Boolean;//是否给按钮条里的按钮布局
		
		public function ButtonBar(buttonWidth:Number = 0)
		{
			this._isLayout = true;
			this._buttonWidth = buttonWidth;
			super();
		}
		
		override public function dispose():void {
			super.dispose();
			this.cleanButtonList();
			this._buttonItemClass = null;
			this._dataProvider = null;
		}
		
		override protected function initComponent():void 
		{
			super.initComponent();
			this._buttonList = [];
		}
		
		/**
		 * 点击按钮条时出发的触摸事件处理函数
		 * 
		 * @param	event
		 */
		private function buttonBarClick(event:TouchEvent):void {
			if (!SDComponent.touchCheck(event)) {
				return;
			}
			var target:DisplayObject = event.currentTarget as DisplayObject;
			var index:int = this._buttonList.indexOf(target);
			var button:ISelectable = target as ISelectable;
			
			if (this.isTriggerBar) {//单一开关互斥模式下
				this._selectedIndex = index;
				this.updateSelectedItem(target);
				
			}else {//多开关模式下
				this._selectedIndex = -1;
				this._selectedItem = null;
			}
			var itemClickEvent:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK_EVENT);//建立事件
			itemClickEvent.itemTarget = target;
			itemClickEvent.selectedIndex = this._selectedIndex;
			itemClickEvent.selectedItem = this._selectedItem;
			
			this.updateTriggerSelected();
			if(this._selectedItem == null) {
				return;
			}
			this.dispatchEvent(itemClickEvent);
		}
		
		/**
		 * 更新被选中的数据项
		 * 
		 * @param	target
		 */
		private function updateSelectedItem(target:DisplayObject):void {
			if(target is ISelectable) {
				this._selectedItem = ((target as ISelectable).selected) ? this._dataProvider[this._selectedIndex]["data"] : null;
			}else {
				this._selectedItem = this._dataProvider[this._selectedIndex]["data"];
			}
		}
		
		/**
		 * 互斥模式下更新各个按钮的开关状态
		 * 
		 */
		private function updateTriggerSelected():void {
			if(this.isTriggerBar) {
				for each(var button:DisplayObject in this._buttonList) {
					var index:int = this._buttonList.indexOf(button);
					if(index != this._selectedIndex) {
						if(button is ISelectable) {
							(button as ISelectable).selected = false;
						}
					}
				}
			}
		}
		
		override public function redraw():void {
			super.redraw();
			this.updateDataProvider();
			this.updateSelectedIndex();
		}
		
		/**
		 * 更新被选中的按钮索引
		 * 
		 */
		private function updateSelectedIndex():void {
			if(this.isPropertySet("selectedIndexSet")) {
				var target:DisplayObject = this._buttonList[this._selectedIndex];
				if(target is ISelectable) {
					(target as ISelectable).selected = true;
				}
				this.updateSelectedItem(target);
				this.updateTriggerSelected();
			}
		}
		
		/**
		 * 根据数据按钮栏里的所有按钮
		 * 
		 * 若按钮列表中的按钮为外部设置的已创建按钮，则不此方法不清空现有的按钮列表
		 * 
		 */
		private function updateDataProvider():void {
			if (this.isPropertySet("dataProviderSet", true)) {
				if (this._buttonItemClass == null) {
					this._buttonItemClass = SDQuadButton;
				}
				if (this.buttonListSet) {//不清空已从外部设置过的按钮列表
					if (this._dataProvider == null) {
						this._dataProvider = new Array(this._buttonList.length);
					}
				}else {
					this.cleanButtonList();//清空现有的按钮列表
				}
				var i:int = 0;
				var max:int = this._dataProvider.length;
				this.changeProperty("layoutX", 0);//初始化布局坐标
				while(i < max) {
					var item:Object = this._dataProvider[i];
					if (item == null) {
						this._dataProvider[i] = { };
						item = this._dataProvider[i];
					}
					
					var buttonItem:DisplayObject = (this.buttonListSet) ? this._buttonList[i] : this.createButton(item);
					
					buttonItem.addEventListener(TouchEvent.TOUCH, this.buttonBarClick);
					if((buttonItem != null) && buttonItem.hasOwnProperty("data")) {
						buttonItem["data"] = item["data"];
					}
					
					if(!this.buttonListSet) {//不覆盖从外部设置过按钮列表
						this._buttonList.push(buttonItem);
					}
					
					this.layout(buttonItem);
					i++;
				}
				this.updateButtonTrigger();
				this.updateSelectedIndex();
			}
		}
		
		/**
		 * 根据数据创建新按钮
		 * 
		 * @param	item
		 * @return
		 */
		protected function createButton(item:Object):DisplayObject {
			var textureName:String = item["texture"];
			var labelTextureName:String = item["label"];
			var buttonItem:* = new this._buttonItemClass(textureName, labelTextureName);
			return buttonItem;
		}
		
		/**
		 * 布局按钮
		 *  
		 * @param buttonItem
		 * 
		 */
		protected function layout(buttonItem:DisplayObject):void {
			if (!this._isLayout) {
				return;
			}
			buttonItem.visible = false;
			this.addChild(buttonItem);
			buttonItem.x = this.getPropertyChanged("layoutX");
			buttonItem.y = 0;
			var nextPos:Number = buttonItem.x + this._buttonWidth + this._gap;
			this.changeProperty("layoutX", nextPos);
			buttonItem.visible = true;
		}
		
		/**
		 * 清空所有按钮 
		 * 
		 */
		private function cleanButtonList():void {
			if(this._buttonList.length == 0) {
				return;
			}
			for each(var item:DisplayObject in this._buttonList) {
				item.removeEventListener(TouchEvent.TOUCH, this.buttonBarClick);
				if(item is SDComponent) {
					(item as SDComponent).dispose();
				}
			}
			this._buttonList = [];
		}
		
		private function updateButtonTrigger():void {
			for each(var button:DisplayObject in this._buttonList) {
				if(button is SDQuadButton) {
					(button as SDQuadButton).isTrigger = this.isTriggerBar;
				}
			}
		}

		/**
		 * 设置和获取按钮列表数据
		 *  
		 * @return 
		 * 
		 */
		public function get dataProvider():Array
		{
			return _dataProvider;
		}

		/**
		 * 设置按钮栏数据
		 * 
		 */
		public function set dataProvider(value:Array):void
		{
			if(value == this._dataProvider) {
				return;
			}
			_dataProvider = value;
			this.changeProperty("dataProviderSet", true);
			this.invalidate();
		}

		/**
		 * 设置按钮类
		 *  
		 * @param value
		 * 
		 */
		public function set buttonItemClass(value:Class):void
		{
			_buttonItemClass = value;
			this.changeProperty("buttonListSet", false);
		}

		/**
		 * 设置和获取按钮间隔
		 *  
		 * @return 
		 * 
		 */
		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
		}

		public function set selecetdIndex(value:int):void
		{
			_selectedIndex = value;
			this.changeProperty("selectedIndexSet", true);
			this.invalidate();
		}

		public function get selecetdIndex():int
		{
			return _selectedIndex;
		}

		/**
		 * 设置和获取按钮栏的互斥模式
		 * 
		 */
		public function get isTriggerBar():Boolean
		{
			return _isTriggerBar;
		}

		public function set isTriggerBar(value:Boolean):void
		{
			_isTriggerBar = value;
			this.updateButtonTrigger();
		}

		public function get buttonList():Array
		{
			return _buttonList;
		}
		
		public function set buttonList(value:Array):void 
		{
			_buttonList = value;
			this.changeProperty("buttonListSet", true);
			this.changeProperty("dataProviderSet", true);
			this.invalidate();
		}

		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		
		/**
		 * 是否从外部设置了按钮列表
		 * 
		 */
		private function get buttonListSet():Boolean {
			return this.getPropertyChanged("buttonListSet");
		}
		
		public function get buttonWidth():Number 
		{
			return _buttonWidth;
		}
		
		public function set buttonWidth(value:Number):void 
		{
			_buttonWidth = value;
		}
		
		/**
		 * 是否对按钮列表做布局
		 * 
		 */
		public function get isLayout():Boolean 
		{
			return _isLayout;
		}
		
		public function set isLayout(value:Boolean):void 
		{
			_isLayout = value;
		}
	}
}