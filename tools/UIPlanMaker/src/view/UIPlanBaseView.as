package view 
{
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDQuad;
	import shipDock.framework.application.component.SDSprite;
	import shipDock.framework.application.interfaces.IComponent;
	import shipDock.ui.View;
	
	/**
	 * 界面策划视图基类
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class UIPlanBaseView extends View 
	{
		
		public function UIPlanBaseView(bg:String=null, assetList:Array=null, configUIName:String = null) 
		{
			super(bg, assetList);
			this._UIConfigName = configUIName;
			this._hasUIConfig = !!this._UIConfigName;
		}
		
		override protected function createUI():void 
		{
			super.createUI();
		}
	}

}