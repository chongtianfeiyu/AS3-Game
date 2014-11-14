package Core.Object.Monster
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Core.Sence.TankSence;
	import Core.MyInterFace.IShoot;
	import Core.Object.FaceObject;
	import Core.Object.Bullet.BulletObject;
	import Core.Sound.SoundMgr;
	
	import GameObj.Global.GlobalMgr;
	import GameObj.Sence.GameScene;
	
	import TANK_UI.Bullet;
	import TANK_UI.HitFx;
	
	public class EnmeyObject extends FaceObject  implements IShoot
	{
		private var _rangLayer:Sprite=new Sprite();
		private var _followLayer:Sprite= new Sprite();
		private var _layer:Sprite=new Sprite();
		
		private var _bullet:BulletObject; //单例
		private var hitTargetTypes:Array=[TankSence.OBJECT_LIST_TYPE_BULLET,TankSence.OBJECT_LIST_TYPE_ENEMY,TankSence.OBJECT_LIST_TYPE_MAP_ACTIONOBJ,TankSence.OBJECT_LIST_TYPE_PLAYER];
	
		
		private var _isDead:Boolean=false;
		
		public function EnmeyObject(skin:Sprite)
		{
			super(new EnmeyController(),skin);
			(skin as MovieClip).gotoAndStop(1);
		
			
//			AttackRange=100;
//			FollowRange=150;
//			
//	
//			_followLayer.graphics.beginFill(0x000000,0.03);
//			_followLayer.graphics.drawCircle(0,0,FollowRange);
//		
//			var t1:TextField=new TextField();
//			t1.text="警戒范围";
//			t1.x =FollowRange-50;
//			t1.y =_followLayer.y;
//			
//			_followLayer.addChild(t1);
//			
//			
//			_rangLayer.graphics.beginFill(0x000000,0.06);
//			_rangLayer.graphics.drawCircle(0,0,AttackRange);
//			
//			var t2:TextField=new TextField();
//			t2.text="攻击范围";
//			t2.x =AttackRange-60;
//			t2.y =_rangLayer.y;
//			
//			_rangLayer.addChild(t2);
//			
//			
//			_layer.addChild(_rangLayer);
//			_layer.addChild(_followLayer);
			
			GlobalMgr.scene.addLayer(_layer);
			
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
			   if(_isDead)return;
			
				_contrl.AutoRun();
				Move();
				
				_rangLayer.x = this.x+this.width/2;
				_rangLayer.y= this.y+this.height/2;
				
				_followLayer.x = this.x+this.width/2;
				_followLayer.y= this.y+this.height/2;
				
		}
		
		override protected function Move():void
		{
			if(!canMoveNext)
				return;
		
			//移动方向
			switch(moveDirection)
			{
				case MOVE_UP:
				{
					y -= _speed;
					(_face as MovieClip).gotoAndStop(1);
					break;
				}
					
				case MOVE_DOWN:
				{
					y += _speed;
					(_face as MovieClip).gotoAndStop(2);
					break;
				}
					
				case MOVE_LEFT:
				{
					x -= _speed;
					(_face as MovieClip).gotoAndStop(3);
					break;
				}
					
				case MOVE_RIGHT:
				{
					x += _speed;
					(_face as MovieClip).gotoAndStop(4);
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		override public function Die():void
		{
			var obj:EnmeyObject =this;
			// TODO Auto Generated method stub
			super.Die();
			_isDead=true;
			SoundMgr.playSoundBoom1();
			_hitPoints=[];
			var fx:TANK_UI.HitFx=new HitFx();
			fx.x =this.width/2;
			fx.y= this.height/2;
			
			while(numChildren){
			 removeChildAt(0);
			}
		     
		    addChild(fx);
			fx.addEventListener(Event.ENTER_FRAME,function():void{
				if(fx.currentFrame==fx.totalFrames)
				  GlobalMgr.scene.removeObject(obj,TankSence.OBJECT_LIST_TYPE_ENEMY);
			});

		}
		
		
		public function Shoot():void
		{
			var bulletList:Array= GlobalMgr.scene.AllObject(TankSence.OBJECT_LIST_TYPE_BULLET);
			
			if (!bulletList||bulletList.indexOf(_bullet)==-1) 
			{
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