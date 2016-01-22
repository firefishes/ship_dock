package shipDock.framework.core.manager
{
	import shipDock.framework.core.interfaces.ISubject;
	import shipDock.framework.core.observer.SubjectController;
	
	/**
	 * 主题管理器
	 *
	 * ...
	 * @author shaoxin.ji
	 */
	public class SubjectManager
	{
		public static const SUBJECT_MANAGER:String = "subjectMgr";
		
		public static function addSubject(subject:ISubject):void
		{
			SubjectController.getInstance().addSubject(subject);
		}
		
		public static function getSubject(subjectName:String):ISubject
		{
			return SubjectController.getInstance().getSubject(subjectName);
		}
		
		public static function removeSubject(subjectName:String):ISubject
		{
			return SubjectController.getInstance().removeSubject(subjectName);
		}
		
		public function SubjectManager()
		{
			
		}
	}

}