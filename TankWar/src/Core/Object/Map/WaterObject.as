package Core.Object.Map
{
	import flash.display.Sprite;
	
	import GameObj.Object.ActionObject;
	
	
	import TANK_UI.Water;
	
	public class WaterObject extends ActionObject
	{
		public function WaterObject()
		{
			super();
			var skin:Sprite = new Water();
			
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
			
			addChild(skin);
			
		}
	}
}