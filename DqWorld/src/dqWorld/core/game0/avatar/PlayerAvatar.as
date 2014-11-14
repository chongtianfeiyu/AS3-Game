package dqWorld.core.game0.avatar
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	/**
	 *噬魂专用avatar形象 
	 * @author XN-HuangH	
	 * 
	 */	
	public class PlayerAvatar extends BaseAvatarPic
	{
		
		//跳跃阶段,上升，下降
		private static const JUMP_STAGE_UP:uint=0;
		private static const JUM_STAGE_FALL:uint=0;
		
		
		private var _moveKeyCodes:Array =[Keyboard.A,Keyboard.S,Keyboard.D,Keyboard.W,Keyboard.L];
		private var _attackKeyCodes:Array=[Keyboard.J,Keyboard.K];
		
		private var _isPressKey:Boolean;
		private var _lastTime:int=0;
		
		public var onAnimationComplteCallBackFn:Function;
		
		public function PlayerAvatar(resPath:String,autoLoad:Boolean=true,action:uint=AvatarData.ACTION_0,__faceTo:uint=1)
		{
			super(resPath,autoLoad);
			//默认动作为等待
			animationPlayer.complteCallBack =complteCallBack;
			
			_action=action;
			_faceTo=__faceTo;
			setAnimation(action);
		}
		
		public function wait():void{
			isRun=false;
			isWalk=false;
			isJump=false;
			isWait=true;
			isAttack=false;
			
			setAnimation(AvatarData.ACTION_0);
		}
		
		public function beAttack(damage:Number):void{
			
			effectMgr.addEffect(new Point(10,0),EffectAnimationData.TYPE_BEATTACT);
			setAnimation(AvatarData.ACTION_8,1);
			
			//我是上帝，无敌了
			if(godMod)return;
			
			_speed=0;
			hp=hp-damage;
			hp=hp<0?0:hp;
			if(hp==0)_isDead=true;
			

		}
		
		
		override public function update():void
		{
			if(control)
				control.update();
			//更新位图
			super.update();
			
		}
		
		//碰撞后的具体动作
		override protected function hitTest():void
		{
			//碰撞
			for each (var avatar:BaseAvatarPic in _hitObjects) 
			{
				var a:Object = avatar;
				if(this!=a){
					if(checkHit(a)){
						if(_isAttack&&checkVaildAttack(a)){
							a.beAttack(_action==AvatarData.ACTION_4?1:3);
						}
					}
				}
			}
		}
		
		
		//设置新的坐标位置
		override protected function resetPostion():void{
			
			if(_isWalk||_isRun){
				var nextX:int=pointX;
				var nextY:int=pointY;
				switch(_direction)
				{
					case Keyboard.W:
						nextY-=_speed;
						break;
					case Keyboard.S:
						nextY+=_speed;
						break;
					case Keyboard.A:
						nextX-=_speed;_faceTo=0;
						break;
					case Keyboard.D:
						nextX+=_speed;_faceTo=1;
						break;
				}
				if(nextY>0||nextY<300)
					pointY=nextY;
				if(nextX>0||nextX<500)
					pointX=nextX;
			}
		}
		
		
		private function complteCallBack():void{
			
			if(onAnimationComplteCallBackFn is Function){
				onAnimationComplteCallBackFn.call(null);
			}
			
			if(hp<=0)isDead=true;
			wait();
		
		}
		
	}
}