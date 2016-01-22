package shipDock.ui 
{
	import shipDock.framework.application.component.SDImage;
	import shipDock.framework.application.component.SDMovieClip;
	import shipDock.framework.application.component.SDQuadBatch;
	import shipDock.framework.application.component.SDQuadButton;
	import shipDock.framework.application.component.SDQuadText;
	import shipDock.framework.application.events.AssetQueueEvent;
	import shipDock.framework.application.interfaces.IComponent;
	import shipDock.framework.application.interfaces.IViewTransformEffect;
	
	/**
	 * 界面视图接口
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IView extends IComponent
	{
		function getLayout(layoutType:int):Array;
		function loadViewTextures():void;
		function assetLoadComplete(event:AssetQueueEvent = null):void;
		function getTextUI(name:String):SDQuadText;
		function getButtonUI(name:String):SDQuadButton;
		function getImageUI(name:String):SDImage;
		function getMovieUI(name:String):SDMovieClip;
		function getQuadBatchUI(name:String):SDQuadBatch;
		function get UIConfigName():String;
		function get hasUIConfig():Boolean;
		function set isAutoRenderText(value:Boolean):void;
		function get isAutoRenderText():Boolean;
		function get showTransformEffect():IViewTransformEffect;
		function get hideTransformEffect():IViewTransformEffect;
	}
	
}