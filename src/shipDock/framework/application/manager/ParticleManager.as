package shipDock.framework.application.manager
{
	import shipDock.framework.application.effect.particle.PDParticleSystem;
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.singleton.SingletonBase;
	import shipDock.framework.core.utils.HashMap;
	import starling.textures.Texture;
	
	/**
	 * 粒子系统管理器
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class ParticleManager extends SingletonBase
	{
		
		public static const PARTICLE_MANAGER:String = "particleMgr";
		
		public static function getInstance():ParticleManager
		{
			return SingletonManager.singletonManager().getSingleton(PARTICLE_MANAGER) as ParticleManager;
		}
		
		private var _configMap:HashMap;
		private var _configHeadName:String = "pex_";
		
		public function ParticleManager()
		{
			super(this, PARTICLE_MANAGER);
			this._configMap = new HashMap();
		}
		
		public function getConfigName(name:String):String
		{
			return this._configHeadName + name;
		}
		
		public function addPexConfig(name:String, data:*):void
		{
			(!_configMap.isContainsKey(name)) && _configMap.put(name, new XML(data));
		}
		
		public function getParticle(pexName:String, textureName:String):PDParticleSystem
		{
			var name:String = this.getConfigName(pexName);
			if (!this._configMap.isContainsKey(name))
				LogsManager.getInstance().setLog("【PARTICLE】The particle config is not exsit. name is " + name);
			var xml:XML = this._configMap.getXML(name);
			var texture:Texture = SDAssetManager.getInstance().getTexture(textureName);
			var result:PDParticleSystem = new PDParticleSystem(xml, texture, pexName);
			return result;
		}
		
		public function get configHeadName():String
		{
			return _configHeadName;
		}
		
		public function set configHeadName(value:String):void
		{
			_configHeadName = value;
		}
	}
}