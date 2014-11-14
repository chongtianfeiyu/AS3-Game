package GameObj.Controller
{
	import flash.events.KeyboardEvent;
	
	import GameObj.Global.GlobalMgr;
	

	/**
	 *键盘控制器 
	 * @author XN-HuangH
	 * 
	 */	
	public class KeyController extends BasicController
	{
		protected var _keyCodes:Array=new Array(); //用于记录最近响应的按键
		
		public function KeyController()
		{
			super();
			SetupListener();
		}
		
		
		/**
		 * 销毁时撤销监听
		 */
		override public function Die():void{
			GlobalMgr.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			GlobalMgr.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		/**
		 * 安装侦听器
		 */
		public function SetupListener():void
		{
			GlobalMgr.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			GlobalMgr.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
		}
		
		/**
		 *键盘弹起
		 * @param event
		 * 
		 */		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		/**
		 *键盘按下 
		 * @param event
		 * 
		 */		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
		}
		
	}
}