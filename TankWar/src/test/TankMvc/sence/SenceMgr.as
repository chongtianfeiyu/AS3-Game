package test.TankMvc.sence
{
	import flash.events.EventDispatcher;

	public class SenceMgr extends EventDispatcher
	{
		//单例模式
		private static var _instance:SenceMgr;
		public static function getInstance():SenceMgr {
			if (null == _instance) {
				_instance = new SenceMgr();
			}
			return _instance;
		}
		
		//构造
		public function SenceMgr()
		{
		}
		
		//加载资源
	}
}