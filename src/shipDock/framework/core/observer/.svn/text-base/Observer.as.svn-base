package shipDock.framework.core.observer 
{
	import shipDock.framework.core.interfaces.IDispose;
	import shipDock.framework.core.interfaces.INotice;
	import shipDock.framework.core.interfaces.IObserver;
	import shipDock.framework.core.interfaces.ISubject;
	
	/**
	 * 观察者基类
	 * 
	 * 可以用于需要根据数据更改而更新的操作，并可以接收被广播的消息
	 * 
	 * ...
	 * @author shaoxin.ji
	 */
	public class Observer implements IObserver, IDispose
	{
		
		private var _subjects:Object;
		
		public function Observer() 
		{
			
		}
		
		public function dispose():void {
			this._subjects = { };
		}
		
		/* INTERFACE shipDock.interfaces.IObserver */
		
		public function notify(notice:INotice):* 
		{
			
		}
		
		public function setSubject(subject:ISubject):void {
			if (this._subjects == null) {
				this._subjects = { };
			}
			this._subjects[subject.subjectName] = subject;
		}
		
		public function removeSubject(subject:ISubject):void {
			if (this._subjects.hasOwnProperty(subject.subjectName)) {
				delete this._subjects[subject.subjectName];
			}
		}
	}

}