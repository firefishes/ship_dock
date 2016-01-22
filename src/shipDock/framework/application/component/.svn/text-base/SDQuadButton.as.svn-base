package shipDock.framework.application.component
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import shipDock.framework.application.interfaces.ISelectable;
	import shipDock.framework.application.manager.SDAssetManager;
	import shipDock.framework.application.utils.DisplayUtils;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 静态矩形图按钮
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDQuadButton extends SDQuadBatch implements ISelectable
	{
		
		public static const BUTTON_STATE_UP:int = 0;
		public static const BUTTON_STATE_DOWN:int = 1;
		public static const BUTTON_STATE_DISABLED:int = 2;
		
		private var _click:Function;
		private var _triggerPhase:String;
		private var _resetButtonTimer:Timer;
		
		private var _needProvit:Boolean;
		private var _pi:Number;
		
		private var _textureName:String;
		private var _selected:Boolean;
		private var _isTrigger:Boolean;
		private var _buttonStates:Array;
		private var _buttonImages:Array;
		private var _buttonLabels:Array;
		
		public function SDQuadButton(textureName:String, labelTextureName:String = null, onClick:Function = null, triggerPhase:String = TouchPhase.ENDED, needProvit:Boolean = false, pi:Number = 0)
		{
			super();
			
			this._pi = pi;
			this._needProvit = needProvit;
			
			this._textureName = textureName;
			
			this.initButtonStates();
			this.setButtonStates();
			
			this._click = onClick;
			this._triggerPhase = (triggerPhase == null) ? TouchPhase.BEGAN : triggerPhase;
			
			this._resetButtonTimer = new Timer(100);
			this._resetButtonTimer.addEventListener(TimerEvent.TIMER, this.onTimeout);
			
			this.addEventListener(TouchEvent.TOUCH, this.onSDQuadButtonTouch);
			
			this.changeToUp();
		
		}
		
		override public function dispose():void
		{
			super.dispose();
			this._resetButtonTimer.stop();
			this._resetButtonTimer.removeEventListener(TimerEvent.TIMER, onTimeout);
			this.removeEventListener(TouchEvent.TOUCH, this.onSDQuadButtonTouch);
		}
		
		protected function initButtonStates():void
		{
			this._buttonStates = ["Up", "Down", "Disabled"];
		}
		
		protected function setButtonStates():void
		{
			this._buttonImages = new Array(this._buttonStates.length);
			this._buttonLabels = new Array(this._buttonStates.length);
			
			var assetManager:SDAssetManager = SDAssetManager.getInstance();
			var i:int = 0;
			var max:int = this._buttonStates.length;
			var textureName:String;
			while (i < max)
			{
				textureName = this._textureName + this._buttonStates[i];
				this._buttonImages[i] = assetManager.getImage(textureName);
				if (!!this._buttonImages[i])
				{
					(this._buttonImages[i] as SDImage).rotation = this._pi;
				}
				
				textureName = this._textureName + this._buttonStates[i] + "Label";
				this._buttonLabels[i] = assetManager.getImage(textureName, false, true);
				if (!!this._buttonLabels[i])
				{
					(this._buttonLabels[i] as SDImage).rotation = this._pi;
				}
				
				if (this._needProvit)
				{
					DisplayUtils.setPovit(this, -(this._buttonLabels[i] as SDImage).width / 2, -(this._buttonLabels[i] as SDImage).height / 2);
				}
				i++;
			}
		}
		
		public function changeTexture(button:String):void
		{
			this._textureName = button;
			this.setButtonStates();
			this.changeToUp();
		}
		
		public function changeToUp():void
		{
			this.reset();
			if (!!this.buttonUp)
			{
				this.addImage(this.buttonUp);
			}
			if (!!this.labelUpImage)
			{
				this.addImage(this.labelUpImage);
			}
		}
		
		public function changeToDown():void
		{
			this.reset();
			if (!!this.buttonDown)
			{
				this.addImage(this.buttonDown);
			}
			else
			{
				this.addImage(this.buttonUp);
			}
			if (!!this.labelDownImage)
			{
				this.addImage(this.labelDownImage);
			}
		}
		
		public function changeToDisabled():void
		{
			this.reset();
			if (!!this.buttonDisabled)
			{
				this.addImage(this.buttonDisabled);
			}
			if (!!this.labelDisabledImage)
			{
				this.addImage(this.labelDisabledImage);
			}
		}
		
		private function onSDQuadButtonTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (!!touch)
			{
				switch (touch.phase)
				{
					case TouchPhase.BEGAN: 
						onBegin();
						break;
					case TouchPhase.MOVED: 
						onMove();
						break;
					case TouchPhase.ENDED: 
						onEnded();
						break;
				}
			}
		}
		
		public function onMove():void
		{
		
		}
		
		public function onEnded():void
		{
			if (!this._isTrigger)
			{
				this.changeToUp();
			}
			else
			{
				if (this._selected)
				{
					this.changeToUp();
				}
				this.selectedChanged();
			}
			if (this._triggerPhase == TouchPhase.ENDED)
			{
				if (!!this._click)
				{
					this._click();
				}
			}
		}
		
		public function onBegin():void
		{
			this.changeToDown();
			if (this._triggerPhase == TouchPhase.BEGAN)
			{
				if (!!this._click)
				{
					this._click();
				}
				if (!this.isTrigger)
				{
					this._resetButtonTimer.reset();
					this._resetButtonTimer.start();
				}
				else
				{
					this.selectedChanged();
				}
			}
		}
		
		private function selectedChanged():void
		{
			this._selected = !this._selected;
		}
		
		public function onTimeout(e:TimerEvent):void
		{
			this.changeToUp();
		
		}
		
		public function get buttonUp():SDImage
		{
			return this._buttonImages[BUTTON_STATE_UP];
		}
		
		public function get buttonDown():SDImage
		{
			return this._buttonImages[BUTTON_STATE_DOWN];
		}
		
		public function get labelUpImage():SDImage
		{
			return this._buttonLabels[BUTTON_STATE_UP];
		}
		
		public function get labelDownImage():SDImage
		{
			return this._buttonLabels[BUTTON_STATE_DOWN];
		}
		
		public function get buttonDisabled():SDImage
		{
			return this._buttonImages[BUTTON_STATE_DISABLED];
		}
		
		public function get labelDisabledImage():SDImage
		{
			return this._buttonLabels[BUTTON_STATE_DISABLED];
		}
		
		public function get isTrigger():Boolean
		{
			return _isTrigger;
		}
		
		public function set isTrigger(value:Boolean):void
		{
			_isTrigger = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value == this._selected)
			{
				return;
			}
			if (!this.touchable)
			{
				return;
			}
			if (this._selected)
			{
				this.changeToUp();
			}
			else
			{
				this.changeToDown();
			}
			_selected = value;
		}
		
		override public function get touchable():Boolean
		{
			return super.touchable;
		}
		
		override public function set touchable(value:Boolean):void
		{
			super.touchable = value;
			if (value)
			{
				this.changeToUp();
			}
			else
			{
				this.changeToDisabled();
			}
		}
	
	}

}