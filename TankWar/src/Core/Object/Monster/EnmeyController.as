package Core.Object.Monster
{
	import GameObj.Controller.BasicController;


	public class EnmeyController extends BasicController 
	{
		private var _lastShoot:Date;
		private var _lastAction:Date;
		private var _shootFPS:int=5000;
		private var _actionFPS:int=2000;
	
		
		public function EnmeyController()
		{
			_lastShoot=new Date();
		}
		
		//自动
		override public function AutoRun():void
		{
			var me:EnmeyObject = _target as EnmeyObject;
			
			// TODO Auto Generated method stub	
			var date:Date = new Date();
			// 如果运行时间已经超过频率所指定的时间间隔，那么运行程序
			if (!_lastAction||date.time-_lastAction.time > _actionFPS)
			{
				_lastAction = date;
				AutoMove(me);
			}
			
			//每5秒随机攻击
			
			if(false){//有可攻击目标时
			
			}
			else //攻击目标不在范围内
			{
				if((date.time-_lastShoot.time > _shootFPS)){
				
				_lastShoot = date;
				AutoAttack(me);
				trace("fire");
				}
			}
			
		}
		
		//随机移动
		private function AutoMove(me:EnmeyObject):void{
			
			me.direction = 2+int(Math.random() * 3);
			me.isMove = true;
		}
		
		//随机60%开火
		private function AutoAttack(me:EnmeyObject):void{
			
			 if(Math.random()*10>3)
				 me.Shoot();
		}
		
	}
}