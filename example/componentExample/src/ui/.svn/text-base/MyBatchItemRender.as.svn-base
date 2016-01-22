package ui 
{
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDQuadText;
	import shipDock.framework.application.SDCore;
	import shipDock.ui.BatchRender;
	import shipDock.ui.ListItemRender;
	import starling.display.Image;
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public class MyBatchItemRender extends ListItemRender
	{
		
		public function MyBatchItemRender(data:Object, index:int, itemWidth:Number, itemHeight:Number, batchRender:BatchRender) 
		{
			super(data, index, itemWidth, itemHeight, batchRender);
		}
		
		override protected function initPos():void 
		{
			super.initPos();
			
			this.posY = this.index * (this.itemHeight + 5);
		}
		
		override protected function initItemRender():void 
		{
			super.initItemRender();
			
			var image:SDImage = SDCore.getInstance().assetManager.getImage("skill_sub_type_1");
			image.y = this.posY;
			this.pushToLayer(image);
			
			var pos:Number = image.width;
			
			image = SDCore.getInstance().assetManager.getImage("skill_sub_type_2");
			image.x = pos;
			this.addToLayer(image);
			image.y = this.posY;
			
			var text:SDQuadText = new SDQuadText(100, 40, String(this.data["value"]), 22, 0x545878);
			this.pushToLayer(text);
			text.y = this.posY;
		}
		
	}

}