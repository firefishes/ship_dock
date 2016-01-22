package shipDock.framework.core.queueExecuter
{
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.IMethodElement;
	import shipDock.framework.core.interfaces.IPoolObject;
	import shipDock.framework.core.interfaces.IQueueExecuter;
	import shipDock.framework.core.manager.ObjectPoolManager;
	import shipDock.framework.core.queueExecuter.QueueExecuterEvent;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 流程队列执行类
	 *
	 * 提供按顺序逐个执行方法或流程对象的功能
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class QueueExecuter extends EventDispatcher implements IQueueExecuter, IDispose, IPoolObject
	{
		
		private var _currentIndex:int; //当前执行到的索引
		private var _queue:Array; //流程队列
		private var _isDisposed:Boolean;
		private var _isRunning:Boolean;
		
		public function QueueExecuter()
		{
			this.init();
		}
		
		/**
		 * 销毁
		 *
		 */
		public function dispose():void
		{
			if (this._isDisposed)
				return; //不重复销毁，否则会引起循环调用
			this._isRunning = false;
			this._isDisposed = true;
			if (this._queue.length > 0)
			{
				var i:int = 0; //移除剩余的没有执行的执行单元
				var max:int = this._queue.length;
				while (i < max)
				{
					var unit:* = this._queue[i];
					var isMethod:Boolean = unit is Function;
					if (!isMethod && (unit is EventDispatcher))
					{
						(unit as EventDispatcher).removeEventListener(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT, this.nextUnit);
						(unit is IQueueExecuter) && (unit as IQueueExecuter).dispose();
					}
					i++;
				}
			}
			this._queue = [];
			this._currentIndex = -1;
		}
		
		/**
		 * 初始化
		 *
		 */
		private function init():void
		{
			this._isRunning = false;
			this._isDisposed = false;
			this._currentIndex = 0;
			this._queue = [];
		}
		
		/**
		 * 将一个流程执行器增加到队列末尾
		 *
		 */
		public function add(... args):void
		{
			if (args.length > 0)
			{
				var i:int = 0;
				var max:int = args.length;
				while (i < max)
				{
					(args[i]) && this._queue.push(args[i]);
					i++;
				}
			}
		}
		
		/**
		 * 将一个流程执行器增加到队列指定位置
		 *
		 */
		public function addTo(item:*, index:int):void
		{
			(index <= this._currentIndex) && (index = this._currentIndex + 1);
			if (index >= this._queue.length)
				this.add(item);
			else
			{
				var sub:Array = this._queue.splice(0, index - 1);
				sub.push(item);
				this._queue = sub.concat(this._queue);
			}
		}
		
		/**
		 * 将一个流程执行器从队列的末尾移除
		 *
		 */
		public function remove():*
		{
			return this._queue.pop();
		}
		
		/**
		 * 将一个指定位置的流程执行器从队列移除
		 *
		 */
		public function removeAt(index:int, count:int = 1):*
		{
			if (this._queue.length <= index)
				return;
			return this._queue.splice(index, count);
		}
		
		/**
		 * 移除队列里的所有流程执行器
		 *
		 */
		public function removeAll():void
		{
			this.reset();
		}
		
		/**
		 * 开始执行流程队列
		 *
		 */
		public function start():void
		{
			if (this._isRunning)
				return;
			this._isRunning = true;
			this._isDisposed = false;
			this._currentIndex = 0;
			this.executeUnit();
		}
		
		/**
		 * 执行队列中的下一个执行器
		 *
		 */
		protected function executeUnit():void
		{
			var unit:*;
			this.dispatchEvent(new QueueExecuterEvent(QueueExecuterEvent.QUEUE_UNIT_EXECUTED_EVENT));
			if (this._currentIndex < this._queue.length)
			{
				unit = this._queue[this._currentIndex]; //设置当前单元为下一个执行单元
				this._currentIndex++;
			}
			else
			{
				this._isRunning = false;
				this.dispatchEvent(new QueueExecuterEvent(QueueExecuterEvent.QUEUE_COMPLETE_EVENT));
				this.dispose();
				return;
			}
			var canNext:Boolean = true;
			var skip:Boolean = this.canSkip();
			if (!skip)
			{
				if (unit != null)
				{
					if (unit is Function)
						unit();
					else if (unit is IQueueExecuter)
					{
						if (unit is EventDispatcher)
						{
							canNext = false;
							(unit as EventDispatcher).addEventListener(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT, this.nextUnit);
						}
						(unit as IQueueExecuter).commit();
					}
					else if (unit is IMethodElement)
						(unit as IMethodElement).apply();
				}
			}
			(canNext) && this.executeUnit();
		}
		
		/**
		 * 执行队列中的下一个执行器事件处理函数
		 *
		 */
		protected function nextUnit(event:Event):void
		{
			var target:EventDispatcher = event.target;
			target.removeEventListener(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT, this.nextUnit);
			this.executeUnit();
		}
		
		/**
		 * 此执行器是否可以被跳过
		 *
		 */
		protected function canSkip():Boolean
		{
			return false;
		}
		
		/**
		 * 此执行器被执行时的入口
		 *
		 */
		public function commit():void
		{
			this.start();
		}
		
		/**
		 * 重置
		 *
		 */
		public function reset():void
		{
			this.dispose();
			this.init();
		}
		
		public function resetPoolObject():void
		{
			this.reset();
		}
		
		public function reinitPoolObject(args:Array):void {
		}
		
		/**
		 * 执行此对象所在队列的下一个队列元素
		 *
		 */
		public function queueNext():void
		{
			this.dispatchEventWith(QueueExecuterEvent.QUEUE_UNIT_NEXT_EVENT);
		}
		
		/**
		 * 获取当前执行队列的执行位置
		 *
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function get isDisposed():Boolean
		{
			return _isDisposed;
		}
		
		public function get isReleaseInPool():Boolean
		{
			return ObjectPoolManager.getInstance().isReleaseInPool(this);
		}
		
		public function get queueSize():uint
		{
			return (!!this._queue) ? this._queue.length : 0;
		}
		
		final public function get eventDispatcher():EventDispatcher {
			return this as EventDispatcher;
		}
	}

}