package Core.Object.Player
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import Core.Sence.TankSence;
	import Core.MyInterFace.IShoot;
	import Core.Object.FaceObject;
	import Core.Object.Bullet.BulletObject;
	
	import GameObj.Global.GlobalMgr;
	import GameObj.Sence.GameScene;
	
	import Core.Sound.SoundMgr;
	
	import TANK_SOUND.SoundFire;
	
	import TANK_UI.Bullet;
	
	public class PlayerObject extends FaceObject implements IShoot
	{
		private var _keyContrl:KeyController;
		private var _bullet:BulletObject; //单例
		private var _soundFire:Object; //单例
		
		private var hitTargetTypes:Array=[TankSence.OBJECT_LIST_TYPE_BULLET,TankSence.OBJECT_LIST_TYPE_ENEMY,TankSence.OBJECT_LIST_TYPE_MAP_ACTIONOBJ,TankSence.OBJECT_LIST_TYPE_PLAYER];
		
		public function PlayerObject(skin:Sprite)
		{
			super(new KeyController(),skin);
			_hitPoints=[
				[0,0],
				[skin.width/2,0],
				[skin.width,0],
				[skin.width,height/2],
				[skin.width,skin.height],
				[skin.width/2,skin.height/2],
				[0,skin.height],
				[0,skin.height/2]
			];
			
			
			
			intHitTarget(hitTargetTypes);
			GlobalMgr.callBackDispatcher.addCallBack(GameScene.CALLBACK_ADD_OBJECT,addHitTargetHandel);
			GlobalMgr.callBackDispatcher.addCallBack(GameScene.CALLBACK_REMOVE_OBJECT,removeHitTargetHandel);
		}
		
		
		
		
		override public function Do():void
		{
			if (_isMove){
				Move();
			}
			
			super.Do();
		}
		
		override public function Die():void
		{
			super.Die();
	
			GlobalMgr.callBackDispatcher.removeCallBack(GameScene.CALLBACK_ADD_OBJECT,addHitTargetHandel);
			GlobalMgr.callBackDispatcher.removeCallBack(GameScene.CALLBACK_REMOVE_OBJECT,removeHitTargetHandel);
			
			GlobalMgr.scene.removeObject(this,TankSence.OBJECT_LIST_TYPE_PLAYER);

		}
		
		override protected function Move():void
		{
			//转向
			(_face as MovieClip).gotoAndStop(moveDirection);
			
			if(!canMoveNext)
				return;
			
			//移动
			switch(moveDirection)
			{
				case MOVE_UP:
				{
					y -= _speed;
					
					break;
				}
					
				case MOVE_DOWN:
				{
					y += _speed;
					
					break;
				}
					
				case MOVE_LEFT:
				{
					x -= _speed;
					
					break;
				}
					
				case MOVE_RIGHT:
				{
					x += _speed;
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		//射击
		public function Shoot():void
		{
			
			var bulletList:Array= GlobalMgr.scene.AllObject(TankSence.OBJECT_LIST_TYPE_BULLET);
			
			if (!bulletList||bulletList.indexOf(_bullet)==-1) 
			{
				SoundMgr.playSoundFire();
				
				// TODO Auto Generated method stub
				_bullet= new BulletObject(this,new TANK_UI.Bullet());
				_bullet.x = x+width/2;
				_bullet.y = y+height/2;
				_bullet.direction = moveDirection;
				GlobalMgr.scene.addObject(_bullet,TankSence.OBJECT_LIST_TYPE_BULLET);
				
			}
			
		}
		
	
			
	}
}