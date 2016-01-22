package view
{
	import flash.utils.getTimer;
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDMovieClip;
	import shipDock.framework.application.component.SDQuadButton;
	import shipDock.framework.application.component.SDQuadText;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.SDCore;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.ui.BatchRender;
	import shipDock.ui.ScrollContainer;
	import shipDock.ui.View;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import ui.MyBatchItemRender;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class StartView extends View 
	{
		
		public function StartView() 
		{
			super(null, null);
			this._hasUIConfig = false;//定义视图界面为没有界面配置
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			//文本控件
			this.testTextField();
			this.testButton();
			this.testImage();
			this.testMovie();
			this.testAtf();
			this.testList();
			this.testObjectPool();
		}
		
		/**
		 * 文本
		 * 
		 */
		private function testTextField():void {
			var textField:SDQuadText = new SDQuadText(200, 50, "", 20, 0x457896);
			textField.text = "大家好，我是文本，初次见面请多多指教";
			this.addChild(textField);
		}
		
		/**
		 * 按钮控件
		 * 
		 */
		private function testButton():void {
			var button:SDQuadButton = new SDQuadButton("close", null, buttonClickHandler);
			button.y = 50;
			this.addChild(button);
		}
		
		private function buttonClickHandler():void {
			trace("关闭按钮被点击了！");
		}
		
		/**
		 * 图片
		 * 
		 */
		private function testImage():void {
			var image:SDImage = SDCore.getInstance().assetManager.getImage("skill_sub_type_1");
			image.y = 100;
			this.addChild(image);
		}
		
		/**
		 * 动画
		 * 
		 */
		private function testMovie():void {
			var movie:SDMovieClip = SDCore.getInstance().assetManager.getMovieClip("troops1", 30);
			movie.y = 200;
			this.addChild(movie);
		}
		
		/**
		 * atf动画
		 * 
		 */
		private function testAtf():void {
			var movie:SDMovieClip = SDCore.getInstance().assetManager.getMovieClip("army1", 60);
			movie.y = 200;
			movie.loop = false;
			this.addChild(movie);
		}
		
		/**
		 * 滚动列表
		 * 
		 */
		private function testList():void {
			var scroll:ScrollContainer = new ScrollContainer(300, 400, true);
			
			var list:Array = [];
			var i:int = 0;
			var max:int = 50;
			while (i < max) {
				list.push({"value":i});
				i++;
			}
			var batchRender:BatchRender = new BatchRender(list, MyBatchItemRender, 300, 50, null, 10);
			scroll.addItem(batchRender);
			scroll.changeContainerSize(300, batchRender.height);
			
			this.addChild(scroll);
		}
		
		/**
		 * 对象池
		 * 
		 */
		private function testObjectPool():void {
			ObjectPoolManager.getInstance().addPool(SDSprite/*, 100*/);//传递第二个参数表示限定对象池的个数
			var i:int = 0;
			var max:int = 100;
			var time:uint = getTimer();
			while(i < max) {
				var sprite:SDSprite = ObjectPoolManager.getInstance().fromPool(SDSprite);
				var image:SDImage = SDCore.getInstance().assetManager.getImage("skill_sub_type_1");
				sprite.addChild(image);
				this.addChild(sprite);
				sprite.addEventListener(TouchEvent.TOUCH, this.toPoolHandler);
				i++;
			}
			LogsManager.getInstance().setLog("【TEST OBJECT POOL】use time: " + (getTimer() - time));
		}
		
		private function toPoolHandler(event:TouchEvent):void {
			var touch:Touch = event.getTouch(event.target as DisplayObject, TouchPhase.ENDED);
			if (touch != null) {
				var sprite:SDSprite = event.currentTarget as SDSprite;
				var reset:Function = function(target:SDSprite):void {
					target.removeChildren();
					target.removeFromParent();
				}
				ObjectPoolManager.getInstance().toPool(sprite, reset, sprite);
			}
		}
	}

}