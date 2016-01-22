package starling.extensions 
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author HongSama
	 */
	public class ParticlePool implements IAnimatable
	{
		private static var _instance:ParticlePool;
		private var pool:Array = [];
		private var maxParticles:int = 5000;
		
		public function ParticlePool() 
		{
			
		}
		
		public function start():void
		{
			Starling.juggler.add(this);
		}
		
		public function clear():void
		{
			pool = null;
		}
		
		public function advanceTime(time:Number):void 
		{
			if (time <= 0.033 && pool.length < maxParticles)
			{
				addParticle(5);
			}
		}
		
		private function addParticle(count:int):void 
		{
			for (var i:int = 0; i < count; i++)
			{
				pool.push(new PDParticle());
			}
		}
		
		
		public function get particle():Particle
		{
			if (pool.length > 0)
			{
				var p:PDParticle = pool.pop();
				return p;
			}
			else
			{
				return new PDParticle();
			}
		}
		
		static public function get instance():ParticlePool 
		{
			if (!_instance)
			{
				_instance = new ParticlePool();
			}
			return _instance;
		}
		
		static public function set instance(value:ParticlePool):void 
		{
			_instance = value;
		}
	}

}