package dqWorld.core.game0.avatar
{
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import dqWorld.core.game0.avatar.control.BaseCtrl;
	import dqWorld.core.game0.avatar.control.PlayerRobotCtrl;

	public class PlayerMonsterAvatar extends PlayerAvatar
	{
		private var _actionFPS:int=2000;
		private var _lastAction:int=0;
		
		private var _control:PlayerRobotCtrl;
		public override function set control(value:BaseCtrl):void
		{
			_control = value as PlayerRobotCtrl;
			_control.target=this;
		}
	
		public function PlayerMonsterAvatar(avatarName:String,autoLoad:Boolean=true,action:uint=AvatarData.ACTION_0,faceTo:uint=1)
		{
			super(avatarName,autoLoad,action,faceTo);
		}
		
		override public function update():void
		{
			if(_control)
				_control.update();
		
			super.update();
			
			if(bitmapData){
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(0,0),new ColorMatrixFilter([
					0.5,0.5,0.0,0,0,
					0.5,0.5,0.0,0,0,
					0.5,0.5,0.0,0,0,
					0,0,0,1,0
				]));
			}
		}
		
	}
}