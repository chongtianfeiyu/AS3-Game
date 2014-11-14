package GameObj.Global 
{
	import flash.display.Stage;
	
	import Event.CallBackDispatcher;
	
	import GameObj.Sence.GameScene;

	/**
	 *FLASH场景管理
	 * @author XN-HuangH
	 * 
	 */	
	public class GlobalMgr
	{
		/**
		 *舞台管理 
		 */		
		public static var stage:Stage;
		
		public static var callBackDispatcher:CallBackDispatcher = new CallBackDispatcher();
		
		/**
		 * 直接调用游戏场景
		 */
		public static var scene:GameScene;
		
		public function GlobalMgr()
		{
			
		}
	}
}