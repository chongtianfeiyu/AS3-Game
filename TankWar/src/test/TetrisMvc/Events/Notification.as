package test.TetrisMvc.Events
{
	import flash.events.Event;

	public class Notification extends Event
	{
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		public static const REFRESH_MODEL:String = "REFRESH_MODEL";//刷新
		public static const MODEL_UPDATED:String = "MODEL_UPDATED";//模型刷新完毕
		
		public static const KEY_DOWN:String = "KEY_DOWN";//键盘按下
		
		public static const START_GAME:String = "START_GAME";//开始游戏
		public static const GAME_OVER:String = "GAME_OVER";//游戏结束
		
		public static const RESET_GAME:String = "RESET_GAME";//重启游戏
		
		public static const STOP_GAME:String = "STOP_GAME";//暂停游戏
		public static const CONTINUE_GAME:String = "CONTINUE_GAME";//继续游戏
		
		private var _data:Object;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function Notification(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		/*============================================================================*/
		/* Public Function                                                           */
		/*============================================================================*/
		public function get data():Object
		{
			return _data;
		}

	}
}