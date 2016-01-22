package shipDock.framework.application.utils
{
	//import base.core.SCGame;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author HongSama
	 */
	public class GameSound
	{
		private var _soundType:int = 1;
		private var _bgVolom:Number;
		private var _seVolom:Number;
		private var bgTransform:SoundTransform;
		private var seTransform:SoundTransform;
		private var skTransform:SoundTransform;
		private var bgm:Sound;
		private var bgChannel:SoundChannel;
		
		private var seChannels:Object = {};
		private var soundStates:Object = {};
		
		private static var lastPlayBGM:String = '';
		private static var soundContext:SoundLoaderContext;
		
		public function GameSound()
		{
			soundContext = new SoundLoaderContext(40000);
			bgChannel = new SoundChannel();
			initVolom();
			bgChannel.soundTransform = bgTransform;
		}
		
		private function initVolom():void
		{
			bgTransform = new SoundTransform();
			seTransform = new SoundTransform();
			skTransform = new SoundTransform();
			bgVolom = 1;
			seVolom = 1;
			return;
			var soundInit:Boolean // = SCutils.getShareObject("soundInit");
			if (!soundInit)
			{
				bgVolom = 0.8;
				seVolom = 0.8;
				save();
			}
			else
			{
				var bgv:Number // = SCutils.getShareObject("_bgVolom");
				var sev:Number // = SCutils.getShareObject("_seVolom");
				bgVolom = bgv;
				seVolom = sev;
			}
		}
		
		public function loadSound(soundName:String):void
		{
			var sound:Sound // = SCGame.assetManager.getSound(soundName);
			var url:String;
			if (!sound)
			{
				url = "assets/mp3/" + soundName + ".mp3";
				if (1 /*SCutils.checkFileSourse(soundName + ".mp3")*/)
				{
					var file:File = File.applicationStorageDirectory.resolvePath(soundName + ".mp3");
					url = file.url;
				}
				sound = new Sound(new URLRequest(url), soundContext);
					//SCGame.assetManager.addSound(soundName, sound);
			}
		}
		
		public function playBGM(soundName:String = "bgm"):void
		{
			//trace(lastPlayBGM,soundName);
			try
			{
				if (lastPlayBGM != soundName)
				{
					stopBGM();
					lastPlayBGM = soundName;
					loadSound(soundName);
					bgChannel // = SCGame.assetManager.playSound(soundName, 0, 9999, bgTransform);
				}
			}
			catch (e:*)
			{
			}
		}
		
		public function stopBGM():void
		{
			bgChannel.stop();
			lastPlayBGM = "";
		}
		
		public function playSE(soundName:String, playNum:Number = 0):SoundChannel
		{
			try
			{
				loadSound(soundName);
				var channel:SoundChannel // = SCGame.assetManager.playSound(soundName, 0, playNum, seTransform);
			}
			catch (e:*)
			{
				return null;
			}
			return channel;
		}
		
		/*
		   public function playDropSE(soundName:String, playNum:Number = 0):void
		   {
		   var channel:SoundChannel;
		   if (!seChannels[soundName])
		   {
		   channel = new SoundChannel();
		   seChannels[soundName] = channel;
		   }
		   else
		   {
		   channel = seChannels[soundName];
		   }
		   if (soundStates[soundName])
		   {
		   return;
		   }
		   soundStates[soundName] = 1;
		   var sound:Sound = getSound(soundName);
		   channel = sound.play(0, playNum,seTransform);
		   setTimeout(function():void { soundStates[soundName] = 0}, 250);
		   }
		
		   public function playSkillSE(soundName:String, playNum:Number = 0,lifeSpan:int=50):void
		   {
		   var channel:SoundChannel;
		   if (!seChannels[soundName])
		   {
		   channel = new SoundChannel();
		   seChannels[soundName] = channel;
		   }
		   else
		   {
		   channel = seChannels[soundName];
		   }
		   if (soundStates[soundName])
		   {
		   return;
		   }
		   soundStates[soundName] = 1;
		   var sound:Sound = getSound(soundName);
		   channel = sound.play(0, playNum,skTransform);
		   setTimeout(function():void { soundStates[soundName] = 0}, lifeSpan);
		   }
		 */
		
		public function save():void
		{
		/*SCutils.addShareObject("_bgVolom", _bgVolom);
		   SCutils.addShareObject("_seVolom", _seVolom);
		 SCutils.addShareObject("soundInit", true);*/
		}
		
		public function get bgVolom():Number
		{
			return _bgVolom;
		}
		
		public function set bgVolom(value:Number):void
		{
			_bgVolom = value;
			bgTransform.volume = _bgVolom * _soundType;
			bgChannel.soundTransform = bgTransform;
		}
		
		public function get seVolom():Number
		{
			return _seVolom;
		}
		
		public function set seVolom(value:Number):void
		{
			_seVolom = value;
			seTransform.volume = _seVolom * _soundType;
			skTransform.volume = _seVolom * 0.8 * _soundType;
		}
		
		public function get soundType():int
		{
			return _soundType;
		}
		
		public function set soundType(value:int):void
		{
			_soundType = value;
			bgVolom = _bgVolom;
			seVolom = _seVolom;
		}
	}

}