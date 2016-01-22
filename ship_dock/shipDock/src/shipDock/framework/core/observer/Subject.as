package shipDock.framework.core.observer
{
	import shipDock.framework.core.action.ActionController;
	import shipDock.framework.core.interfaces.IAction;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.INoticeSender;
	import shipDock.framework.core.interfaces.IObserver;
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.manager.NoticeManager;
	import shipDock.framework.core.notice.Notice;
	import shipDock.framework.core.utils.StringUtils;
	
	/**
	 * 观察者主题基类
	 *
	 * 用于建立数据操作类或者将消息广播到观察者上的功能类
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class Subject implements ISubject, INoticeSender
	{
		/*主题名*/
		private var _subjectName:String;
		/*观察者列表*/
		private var _observers:Array;
		
		public function Subject(name:String = null)
		{
			this._subjectName = name;
			this._observers = [];
			(this._subjectName == null) && (this._subjectName = StringUtils.qualifiedClassName(this));//默认的主题名与类名相同
			
			SubjectController.getInstance().addSubject(this);
		}
		
		/* INTERFACE shipDock.interfaces.ISubject */
		public function dispose():void
		{
			SubjectController.getInstance().removeSubject(this.subjectName);
			
			for each (var observer:IObserver in this._observers)
			{
				this.unsubscribe(observer);
			}
			this._subjectName = null;
			this._observers = null;
		}
		
		/**
		 * 通知所有注册了此主题的观察者响应更改
		 *
		 * 此方法为所有观察者的响应提供专门通道
		 *
		 * @param	notice
		 */
		public function notify(notice:INotice = null):void
		{
			if (notice != null)
			{
				var i:int = 0;
				var max:int = this._observers.length;
				while (i < max)
				{
					var observer:IObserver = this._observers[i];
					observer.notify(notice);
					i++;
				}
			}
		}
		
		/**
		 * 发送消息
		 *
		 * 相对于notify方法，此方法用于观察者做出响应操作之外的操作
		 *
		 * @param	notice
		 * @return
		 */
		public function sendNotice(target:*, body:* = null, subCommand:String = null, observer:IObserver = null, autoDispose:Boolean = true):*
		{
			var result:*;
			var notice:INotice;
			if(target is INotice)
				notice = target;
			else if (target is String)
				notice = new Notice(target, body, observer, autoDispose);
			(notice && subCommand) && (notice.subCommand = subCommand);
			result = NoticeManager.sendNotice(target);
			return result;
		}
		
		/**
		 * 注册观察者
		 *
		 * @param	observer
		 */
		public function registered(observer:IObserver):void
		{
			observer.setSubject(this);
			this._observers.push(observer);
		}
		
		/**
		 * 注销观察者，将观察者从观察列表中清除
		 *
		 * @param	observer
		 */
		public function unsubscribe(observer:IObserver):void
		{
			var index:int = this._observers.indexOf(observer);
			if (index != -1)
			{
				observer = this._observers.splice(index, 1)[0];
				observer.removeSubject(this);
			}
		}
		
		public function getAction(actionName:String):IAction
		{
			return ActionController.getInstance().getAction(actionName);
		}
		
		/**
		 * 设置和获取和设置主题名
		 *
		 */
		public function set subjectName(value:String):void
		{
			this._subjectName = value;
		}
		
		public function get subjectName():String
		{
			return _subjectName;
		}
	
	}

}