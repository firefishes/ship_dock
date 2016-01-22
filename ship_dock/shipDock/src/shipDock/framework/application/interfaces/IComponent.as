package shipDock.framework.application.interfaces
{
	import flash.geom.Point;
	
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IObserver;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author shaoxin.ji
	 */
	public interface IComponent extends IPopup, IData, IObserver, IDispose, ICallLater
	{
		
		function move(point:Point):void;
		function resize():void;
		function setSize(w:Number, h:Number, isLockScale:Boolean = true):void;
		function setAction(value:IAction):void;
		function getChildraw(name:String):DisplayObject;
		
		function get isRender():Boolean;
		function get isComponentInit():Boolean;
		function set enabled(value:Boolean):void;
		function get enabled():Boolean;
		function set label(value:String):void;
		function get label():String;
		function set toolTip(value:Object):void;
		function get toolTip():Object;
		function get isDisposed():Boolean;
		
		function get name():String;
		function set scaleX(value:Number):void;
		function get scaleX():Number;
		function set scaleY(value:Number):void;
		function get scaleY():Number;
		function get parent():DisplayObjectContainer;
		function set width(value:Number):void;
		function get width():Number;
		function set height(value:Number):void;
		function get height():Number;
		function set x(value:Number):void;
		function get x():Number;
		function set y(value:Number):void;
		function get y():Number;
		
		function get isResize():Boolean;
		function get isAutoDispose():Boolean;
		function set isAutoDispose(value:Boolean):void;
		function get isCreation():Boolean;
		function get isDisposeStarlingBase():Boolean;
		function set isDisposeStarlingBase(value:Boolean):void;
		function get creationComplete():Function;
		function set creationComplete(value:Function):void;
		function get isRedawChildren():Boolean;
		function set isRedawChildren(value:Boolean):void;
		function get action():IAction;
	}

}