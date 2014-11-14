package Core.Object.Player
{
	import flash.events.KeyboardEvent;
	
	import GameObj.Controller.KeyController;
	import GameObj.Object.ActionObject;
	
	/**
	 *Player专用控制器 
	 * @author XN-HuangH
	 * 
	 */	
	public class KeyController extends GameObj.Controller.KeyController
	{
		private var _moveKeyCodes:Array=new Array();
		
		private var moveConfigKeyCodes:Array;
		
		public function KeyController()
		{
			super();
			_moveKeyCodes=new Array();
			
			moveConfigKeyCodes = new Array(
				KeyCodeDef.KEYCODE_W,
				KeyCodeDef.KEYCODE_UP_ARROW,
				KeyCodeDef.KEYCODE_S,
				KeyCodeDef.KEYCODE_DOWN_ARROW,
				KeyCodeDef.KEYCODE_A,
				KeyCodeDef.KEYCODE_LEFT_ARROW,
				KeyCodeDef.KEYCODE_D,
				KeyCodeDef.KEYCODE_RIGHT_ARROW
			);
		}
		
		
		/**
		 *键盘弹起
		 * @param event
		 * 
		 */		
		override protected function onKeyUp(e:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			var me:PlayerObject = _target as PlayerObject;
			
		 
			//解决同时又两个以上方向键被按下，不同时弹起的问题
			if (moveConfigKeyCodes.indexOf(e.keyCode) != -1) {
				
				_moveKeyCodes.splice(_moveKeyCodes.indexOf(e.keyCode),1);
			
				if(_moveKeyCodes.length>=0){
					keyDown(_moveKeyCodes[0]);
				}

				
				if(_moveKeyCodes.length==0){
					me.isMove =false;
				}
				
			}
		}
		
		/**	
		 *键盘按下 
		 * @param event
		 * 
		 */		
		override protected function onKeyDown(e:KeyboardEvent):void
		{
			
			if(_moveKeyCodes.indexOf(e.keyCode)==-1&&moveConfigKeyCodes.indexOf(e.keyCode) != -1){
			
				trace(e.keyCode);
				trace(_moveKeyCodes.indexOf(e.keyCode));
				trace(moveConfigKeyCodes.indexOf(e.keyCode));
				
		
				_moveKeyCodes.push(e.keyCode);
			}
			
			keyDown(e.keyCode);
		}
		
		private function keyDown(keyCode:int):void{
			var me:PlayerObject = _target as PlayerObject;
			switch(keyCode)
			{
				case KeyCodeDef.KEYCODE_W:
				case KeyCodeDef.KEYCODE_UP_ARROW:
					me.direction = ActionObject.MOVE_UP;
					me.isMove =true;
					break;
				
				case KeyCodeDef.KEYCODE_S:
				case KeyCodeDef.KEYCODE_DOWN_ARROW:
					me.direction = ActionObject.MOVE_DOWN;
					me.isMove =true;
					break;
				
				case KeyCodeDef.KEYCODE_A:
				case KeyCodeDef.KEYCODE_LEFT_ARROW:
					me.direction = ActionObject.MOVE_LEFT;
					me.isMove =true;
					break;
				
				case  KeyCodeDef.KEYCODE_D:
				case KeyCodeDef.KEYCODE_RIGHT_ARROW:
					me.direction = ActionObject.MOVE_RIGHT;
					me.isMove =true;
					break;
				
				case  KeyCodeDef.KEYCODE_J:
			
					me.Shoot();
					break;
				
				default:break;
			}
		}
	   
	}
}