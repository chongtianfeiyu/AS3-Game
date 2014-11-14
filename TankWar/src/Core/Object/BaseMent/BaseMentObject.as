package Core.Object.BaseMent
{
	import flash.display.Sprite;
	
	import Core.Sence.TankSence;
	import Core.Object.FaceObject;
	
	import GameObj.Controller.BasicController;
	import GameObj.Global.GlobalMgr;
	
	public class BaseMentObject extends FaceObject 
	{
		public function BaseMentObject(face:Sprite)
		{
			_hp=1; 
			super(null, face);
			
			//碰撞点
			_hitPoints=[
				[0,0],
				[face.width/2,0],
				[face.width,0],
				[face.width,height/2],
				[face.width,face.height],
				[face.width/2,face.height/2],
				[0,face.height],
				[0,face.height/2]
			];
		}
		
		override public function Die():void
		{
			// TODO Auto Generated method stub
			super.Die();	
			GlobalMgr.scene.removeObject(this,TankSence.OBJECT_LIST_TYPE_PLAYER);
		}
		
	}
}