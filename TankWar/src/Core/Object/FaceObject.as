package Core.Object
{
	import flash.display.Sprite;
	
	import GameObj.Controller.BasicController;
	import GameObj.Object.ActionObject;
	
	public class FaceObject extends ActionObject
	{
		//-----------------属性------------------
		
		protected var _hp:uint=100;
		protected var _face:Sprite;
		protected var _contrl:BasicController;
		
		public var Group:uint=0;//阵营
		
		public var AttackRange:int=10; //射程,半径
		public var FollowRange:int=20; //追击范围,半径
		
		/**
		 * 获取HP
		 */
		public function get HP():uint
		{
			return _hp;
		}
		
		
		/**
		 * 
		 * @param        ctrl        控制器
		 * @param        face        外观
		 */
		public function FaceObject(ctrl:BasicController,face:Sprite) 
		{
			if(ctrl){
				_contrl=ctrl;
				_contrl.target = this;
			}
			_face = face;
			addChild(_face);
		}
		
		/**
		 *被攻击 
		 * @param        HurtType        受击方式
		 * @param        damage       基础 伤害
		 * 		 * @param        direction       受击方向
		 */		
		public function Hurt(HurtType:int,damage:Number,direction:int=-1):void{
			_hp -= damage;
			if (_hp <= 0) Die();
		}
	}
}