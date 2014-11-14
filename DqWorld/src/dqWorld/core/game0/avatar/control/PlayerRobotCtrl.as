package dqWorld.core.game0.avatar.control
{
	import flash.display.Stage;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import dqWorld.core.game0.avatar.AvatarData;
	import dqWorld.core.game0.avatar.BaseAvatarPic;
	import dqWorld.core.game0.avatar.PlayerMonsterAvatar;
	
	public class PlayerRobotCtrl extends BaseCtrl
	{
		private var _moveKeyCodes:Array =[Keyboard.A,Keyboard.S,Keyboard.D,Keyboard.W];
		private var _attackKeyCodes:Array=[AvatarData.ACTION_4,AvatarData.ACTION_5];

		private var _stage:Stage;
		private var _avatarObj:PlayerMonsterAvatar;
		
		private var _lastAttack:int;
		private var _attackFPS:int=5000*Math.random();
		
		private var _lastAction:int;
		private var _actionFPS:int=2000*Math.random();
		public var autoMove:Boolean=true;
		public var autoAttack:Boolean=true;
		
		override public function set target(value:BaseAvatarPic):void
		{
			// TODO Auto Generated method stub
			super.target = value;
			_avatarObj= super.target as PlayerMonsterAvatar;
			_avatarObj.onAnimationComplteCallBackFn =onAnimationEnd;
		}
		
		public function PlayerRobotCtrl(__stage:Stage)
		{
			_stage=__stage;
			
		}
		
		override public function update():void
		{
			if(!_avatarObj)return;
			if(_isNoResponse)return;
			
			if (!_lastAction||getTimer()-_lastAction> _actionFPS)
			{
				_lastAction = getTimer();
				if(autoMove)
					AutoMove();
			}
			
			if (!_lastAttack||getTimer()-_lastAttack> _attackFPS)
			{
				_lastAttack = getTimer();
				if(autoAttack)
					AutoAttack();
			}
		}
		
		//随机移动
		private function AutoMove():void{
			var nextDirection:int =_moveKeyCodes[int(Math.random() * 4)];
			if(_avatarObj.direction !=nextDirection){
				_avatarObj.direction =nextDirection;
				_avatarObj.speed=5;
			}			
			if(!_avatarObj.isWalk){
				_avatarObj.isWalk=true;
				_avatarObj.setAnimation(AvatarData.ACTION_1);
			}
		}
		
		private function AutoAttack():void
		{
			_avatarObj.isWalk=false;
			_avatarObj.isRun=false;
			_avatarObj.isAttack=true;
			_isNoResponse=true;
			_avatarObj.setAnimation(_attackKeyCodes[int(Math.random() * 2)],1);
		}
		
		private function onAnimationEnd():void
		{
			_isNoResponse=false;
		}
		
		override public function Die():void
		{
			super.Die();
		}
		
	}
}


