package Core.Object.Bullet
{
	
	import flash.display.Sprite;
	
	import Core.Sence.TankSence;
	import Core.Object.FaceObject;
	import Core.Object.Map.WallObject;
	
	import GameObj.Global.GlobalMgr;
	import GameObj.Object.ActionObject;
	import GameObj.Object.GameObject;
	
	import TANK_UI.Bullet;


	/**
	 *子弹 
	 * @author XN-HuangH
	 * 
	 */	
	public class BulletObject extends ActionObject
	{
		//拥有者
		protected var _owner:ActionObject;
		
		
		//子弹的飞行方向
		protected var _direction:uint;
		
		public function BulletObject(owner:ActionObject,skin:Sprite=null)
		{
			_owner = owner;
			_direction=owner.moveDirection;
			speed=4.5;
			
			//根据移动方向调整子弹头方向，子弹原始方向为向上，0°
			switch(_direction)
			{
				case ActionObject.MOVE_DOWN:
				{
					rotation=180;
				
					break;
				}
					
				case ActionObject.MOVE_LEFT:
				{
					rotation =-90;
				
					break;
				}
					
				case ActionObject.MOVE_RIGHT:
				{
					rotation =90;
				
					break;
				}
					
				default:
				{
					break;
				}
			}
		
			
			
			if(!skin){
				skin=new TANK_UI.Bullet();
				addChild(skin);
			}
			else{
			  addChild(skin);
			}
			
		}
		
		override public function Die():void{
			
		   while(numChildren){
		    removeChildAt(0);
		   }
			
		    GlobalMgr.scene.removeObject(this,TankSence.OBJECT_LIST_TYPE_BULLET);
			
			if(parent){
				parent.removeChild(this);
			}
			
		}
		
		override public function Do():void
		{
			
		   if(!canMoveNext){
		   	  Die();
			  return;
		   }
		   
			switch(_direction)
			{
				case ActionObject.MOVE_UP:
					y -= _speed;
					break;
				case ActionObject.MOVE_DOWN:
					y += _speed;
					break;
				case ActionObject.MOVE_LEFT:
					x -= _speed;
					break;
				case ActionObject.MOVE_RIGHT:
					x += _speed;
					break;
				default:break;
			}
			
			var canHurtObjects:Array=[TankSence.OBJECT_LIST_TYPE_MAP_ACTIONOBJ];
			if(_owner["Group"]&&_owner["Group"]==TankSence.OBJECT_CAMP_2){//玩家发出的子弹
			   canHurtObjects.push(TankSence.OBJECT_LIST_TYPE_ENEMY);	
			}
			
			if(_owner["Group"]&&_owner["Group"]==TankSence.OBJECT_CAMP_3){//敌人发出的子弹
				canHurtObjects.push(TankSence.OBJECT_LIST_TYPE_PLAYER);
			}
			
			for (var i:int = 0; i < canHurtObjects.length; i++) 
			{
				var type:int =canHurtObjects[i];
				var isHurt:Boolean=false;
				
				for each(var obj:GameObject in GlobalMgr.scene.AllObject(type))
				{
					if (obj.hitTestPoint(x, y, true) && obj!=_owner&&obj!=this)
					{
						
						if (!obj.hasOwnProperty('Hurt')) continue;
						
						if(obj["Group"]!=_owner["Group"]){
							
							var hurtDerction:int=-1;
							if(obj is WallObject){
								switch(_direction)
								{
									case ActionObject.MOVE_DOWN:hurtDerction=ActionObject.HURT_DIRECTION_UP;break;
									case ActionObject.MOVE_UP:hurtDerction=ActionObject.HURT_DIRECTION_DOWN;break;
									case ActionObject.MOVE_LEFT:hurtDerction=ActionObject.HURT_DIRECTION_RIGHT;break;
									case ActionObject.MOVE_RIGHT:hurtDerction=ActionObject.HURT_DIRECTION_LEFT;break;
								}
							}
							
							if(obj.x>=x&&obj.y>=y){
								hurtDerction=ActionObject.HURT_DIRECTION_UP;//上面受击中
							}
							
							if(obj.x>=x&&obj.y<=y){
								hurtDerction=ActionObject.HURT_DIRECTION_DOWN;//上面受击中
							}
							
							(obj as FaceObject).Hurt(ActionObject.HURT_TYPE_1,100,hurtDerction);
							Die();
							isHurt=true;
						}
						
						break;
					}
				}
				
                if(isHurt){
				break;
				}
			}
			
	
		}
		
		
	}
}