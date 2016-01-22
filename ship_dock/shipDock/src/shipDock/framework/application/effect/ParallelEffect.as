package shipDock.framework.application.effect
{
	import shipDock.framework.application.events.EffectEvent;
	import shipDock.framework.core.interfaces.IQueueExecuter;
	import shipDock.framework.core.utils.SDUtils;
	import starling.events.EventDispatcher;
	
	/**
	 * 并行特效
	 *
	 * ...
	 * @author ch.ji
	 */
	public class ParallelEffect extends QueueEffect
	{
		
		/**
		 * 并行特效
		 *
		 */
		public function ParallelEffect(list:Array = null)
		{
			super(list);
		}
		
		/**
		 * 启动动画
		 *
		 */
		override public function effectStart():void {
			SDUtils.wLoop(0, this._effectList.length, this.commitEffect);
		}
		
		private function commitEffect(index:int):void
		{
			var effect:IQueueExecuter = this._effectList[index];
			if (effect is EventDispatcher)
			{
				(effect as EventDispatcher).addEventListener(EffectEvent.EFFECT_FINISH_EVENT, this.parallelUnitCompleteHandler);
				this._waitingCount++; //累计等待执行的特效数
			}
			(!!effect) && effect.commit();
		}
		
		protected function parallelUnitCompleteHandler(event:EffectEvent):void
		{
			this.queueUnitExecutedHandler(null); //等待执行的特效数自减
			event.target.removeEventListener(EffectEvent.EFFECT_FINISH_EVENT, this.parallelUnitCompleteHandler);
			(this._waitingCount == 0) && this.effectFinish(); //没有等待执行的特效时此并行特效结束
		}
	}

}