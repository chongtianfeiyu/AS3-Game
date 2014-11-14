package dqWorld.core.game0.avatar.control
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import dqWorld.core.game0.avatar.AvatarData;
	import dqWorld.core.game0.avatar.BaseAvatarPic;
	import dqWorld.core.game0.avatar.PlayerAvatar;

	public class PlayerAvatarCtrl extends BaseCtrl
	{
		//动作池[最大数量[20] 可能是组合
		private var _acitonPool:Vector.<Object>=new Vector.<Object>();
		
		//锁定所有响应
		private var _keyPressTags:Dictionary;
		
		private var _moveKeyCodes:Array =[Keyboard.A,Keyboard.S,Keyboard.D,Keyboard.W,Keyboard.L];
		private var _attackKeyCodes:Array=[Keyboard.J,Keyboard.K];
		
		private var _stage:Stage;
		private var _avatarObj:PlayerAvatar;
		override public function set target(value:BaseAvatarPic):void
		{
			// TODO Auto Generated method stub
			super.target = value;
			_avatarObj= super.target as PlayerAvatar;
			_avatarObj.onAnimationComplteCallBackFn =onAnimationEnd;
		}
		
		
		public function PlayerAvatarCtrl(__stage:Stage)
		{
			_avatarObj= target as PlayerAvatar;
			_stage=__stage;
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
			_keyPressTags=new Dictionary();
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			if(!_avatarObj)return;
			if(_isNoResponse)return;
			toWait();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(!_avatarObj)return;
			if(_isNoResponse)return;
			
			
			if(!_keyPressTags[event.keyCode]){
				_keyPressTags[event.keyCode]=true;
				//动作池
				var len:uint=_acitonPool.unshift({code:event.keyCode,time:getTimer()});
				if(len>20)
					_acitonPool.pop();
			}

			
			/*********************************/
			//判断逻辑
			/*********************************/
			
			//确定行走方向
			if(_moveKeyCodes.indexOf(event.keyCode)!=-1){
				_avatarObj.direction =event.keyCode;
				_avatarObj.isWalk=true;
			}
			
			//判断动作组合 行走->奔跑
			if(_avatarObj.isWalk&&!_avatarObj.isRun){
				_avatarObj.isRun=false;
				if(_acitonPool.length>=2&&_moveKeyCodes.indexOf(event.keyCode)!=-1){
					if(_acitonPool[0].code ==_acitonPool[1].code){
						if(_acitonPool[0].time-_acitonPool[1].time<300){
							if(!_avatarObj.isRun){
								_avatarObj.isRun=true;
							}
						}
					}
				}
			}
			
			//攻击
			if(_attackKeyCodes.indexOf(event.keyCode)!=-1){
				_avatarObj.isAttack=true;
			}
			//设置动画
			if(_avatarObj.isAttack){
				if(event.keyCode==Keyboard.J){
					if(_avatarObj.action!=AvatarData.ACTION_4){
						_avatarObj.isWalk=false;
						_avatarObj.isRun=false;
						_isNoResponse=true;
						_avatarObj.setAnimation(AvatarData.ACTION_4,1);
					}
				}
				if(event.keyCode==Keyboard.K){
					if(_avatarObj.action!=AvatarData.ACTION_5){
						_avatarObj.isWalk=false;
						_avatarObj.isRun=false;
						_isNoResponse=true;
						_avatarObj.setAnimation(AvatarData.ACTION_5,1);
					}
				}
				return;
			}
		}
		
		
		override public  function update():void{
			
			if(_avatarObj.isWalk&&_avatarObj.isRun){
				_avatarObj.speed=10;
				if(_avatarObj.action!=AvatarData.ACTION_1){
					_avatarObj.setAnimation(AvatarData.ACTION_1);
				}
			}
			else if(_avatarObj.isWalk){
				_avatarObj.speed=5;
				if(_avatarObj.action!=AvatarData.ACTION_1){
					_avatarObj.setAnimation(AvatarData.ACTION_1);
				}
			}
		}
		
		public function toWait():void{
			_avatarObj.wait();
			_keyPressTags=new Dictionary();
		}
		
		/**
		 *解除控制器锁定状态，有时候动画播放的时候需要锁掉控制器 * 
		 */		
		public function onAnimationEnd():void{
		
			//返回的是最后一个动作，才能解除锁定
				_isNoResponse=false;
		}
		
		override public function Die():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			super.Die();
		}
		
	}
}