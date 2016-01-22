package shipDock.framework.application.component
{
	import shipDock.framework.application.SDCore;
	import starling.animation.IAnimatable;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 影片剪辑类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SDMovieClip extends SDSprite implements IAnimatable
	{
		
		public static const CURRENT_FRAME_EVENT:String = "currentFrameEvent";
		
		private static var instanceCount:uint = 0;
		
		public static function getInstanceCount():uint
		{
			return instanceCount;
		}
		
		private var _fps:int;
		private var _endFrame:int = 0;
		private var _startFrame:int = 0;
		private var _frameIndex:int = 0;
		private var _currentFrame:int = 0;
		private var _rendTime:Number = 0;
		private var _renderDelay:Number = 24;
		private var _textureName:String;
		private var _loop:Boolean = true;
		private var _pause:Boolean = true;
		private var _image:SDImage;
		private var _frameEvent:Object = { };
		private var _movieFrames:Vector.<Texture>;
		
		public function SDMovieClip(textureName:String, fps:int = 10)
		{
			super();
			this._pause = false;
			
			this._frameIndex = 0;
			this._textureName = textureName;
			this.setTotalFrames();
			this._image = new SDImage(this.movieFrames[0]);
			this.addChild(this._image);
			
			this._fps = fps;
			this._startFrame = 0;
			this._endFrame = this._movieFrames.length - 1;
			this._renderDelay = 1 / this._fps;
			
			SDCore.getInstance().juggler.add(this);
			
			instanceCount++;
		}
		
		private function getInitFrame(frameName:String):Texture {
			return this._movieFrames[int(this._currentFrame)];
		}
		
		public function refresh():void
		{
			this._startFrame = 0;
			this._endFrame = this._movieFrames.length - 1;
			this.play();
		}
		
		protected function setTotalFrames():void
		{
			this._movieFrames = SDCore.getInstance().assetManager.getTextures(this._textureName);
			if (this._movieFrames.length <= 0)
			{
				SDCore.getInstance().debug("Error SDMovieClip-constuctor: Movie textures " + textureName + " not found.");
			}
		}
		
		public function needRend(time:Number):Boolean
		{
			this._rendTime += time;
			if (this._rendTime >= this._renderDelay)
			{
				this._rendTime = 0;
				return true;
			}
			return false;
		}
		
		public function advanceTime(time:Number):void
		{
			
			if (!this._pause)
			{
				if (this.needRend(time))
				{
					if (!!this.frameEvent[this._currentFrame])
					{
						this.dispatchEvent(new Event(this.frameEvent[this._currentFrame]));
					}
					this.dispatchEvent(new Event(CURRENT_FRAME_EVENT));
					this._currentFrame++;
					if (this._currentFrame > this._endFrame)
					{
						
						if (!this._loop)
						{
							this._currentFrame = this._endFrame;
							this.pause = true;
						}
						else
						{
							this._currentFrame = this._startFrame;
						}
						this.dispatchEvent(new Event(Event.COMPLETE));
					}
					this.draw();
				}
			}
		}
		
		private function draw():void
		{
			this._image.texture = this.movieFrames[int(this._currentFrame)];
		}
		
		public function play():void
		{
			SDCore.getInstance().juggler.add(this);
			this._currentFrame = this._startFrame;
			this._pause = false;
			this.loop = true;
			this._rendTime = 0;
		}
		
		public function stop():void
		{
			SDCore.getInstance().juggler.remove(this);
			this._currentFrame = 0;
			this._pause = true;
		}
		
		public function goAndPlay(start:int, end:int):void
		{
			this.loop = true;
			this.pause = true;
			this._startFrame = ((start >= 0) && (start <= this.totalFrames)) ? start : 0;
			this._endFrame = ((end >= 0) && (start < this.totalFrames)) ? end : (this.totalFrames - 1);
			this._currentFrame = this._startFrame;
			this.pause = false;
		}
		
		public function goAndStop(start:int, end:int):void
		{
			this.loop = false;
			this.pause = true;
			this._startFrame = ((start >= 0) && (start <= this.totalFrames)) ? start : 0;
			this._endFrame = ((end >= 0) && (start < totalFrames)) ? end : (this.totalFrames - 1);
			this._currentFrame = this._startFrame;
			this.pause = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
			SDCore.getInstance().juggler.remove(this);
			this._movieFrames.length = 0;
		}
		
		public function get curFrame():int
		{
			return _currentFrame;
		}
		
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		public function get fps():int
		{
			return _fps;
		}
		
		public function set fps(value:int):void
		{
			_fps = value;
		}
		
		public function get pause():Boolean
		{
			return _pause;
		}
		
		public function set pause(value:Boolean):void
		{
			_pause = value;
		}
		
		public function get renderDelay():int
		{
			return _renderDelay;
		}
		
		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
			this.draw();
		}
		
		public function get textureName():String
		{
			return _textureName;
		}
		
		public function get movieFrames():Vector.<Texture>
		{
			return _movieFrames;
		}
		
		public function get totalFrames():int
		{
			return (!!this._movieFrames) ? this._movieFrames.length : 0;
		}
		
		public function get frameEvent():Object 
		{
			return _frameEvent;
		}
	}
}