package shipDock.framework.core.observer
{
	import shipDock.framework.core.manager.LogsManager;
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.manager.SingletonManager;
	import shipDock.framework.core.singleton.SingletonBase;
	import shipDock.framework.core.utils.HashMap;
	
	/**
	 * 主题管理器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SubjectController extends SingletonBase
	{
		public static const SUBJECT_CONTROLLER:String = "subjectController";
		
		public static function getInstance():SubjectController
		{
			return SingletonManager.singletonManager().getSingleton(SUBJECT_CONTROLLER) as SubjectController;
		}
		
		private var _subjects:HashMap; //所有主题集合
		
		public function SubjectController()
		{
			super(this, SUBJECT_CONTROLLER);
			this._subjects = new HashMap();
		}
		
		/**
		 * 添加主题
		 *
		 * @param	subject
		 */
		public function addSubject(subject:ISubject):void
		{
			if (this._subjects.isContainsKey(subject.subjectName))
			{
				LogsManager.getInstance().setLog("Caution NoticeManager-addNotice: " + subject.subjectName + " subject is exist.");
				return;
			}
			this._subjects.put(subject.subjectName, subject);
		}
		
		/**
		 * 获取特定主题
		 *
		 * @param	subjectName
		 * @return
		 */
		public function getSubject(subjectName:String):ISubject
		{
			var subject:ISubject = this._subjects.getValue(subjectName) as ISubject;
			return subject;
		}
		
		/**
		 * 移除出题
		 *
		 * @param	subjectName
		 * @return
		 */
		public function removeSubject(subjectName:String):ISubject
		{
			var result:ISubject = this._subjects.getValue(subjectName, true) as ISubject;
			return result;
		}
	}

}