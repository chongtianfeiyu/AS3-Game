package Core.Object.Map
{
	import flash.display.Sprite;
	
	import Core.Object.FaceObject;
	
	import GameObj.Object.ActionObject;
	
	import TANK_UI.Grid;
	import TANK_UI.Wall;
	
	public class GridObject extends FaceObject
	{
		public function GridObject()
		{
			super(null,new TANK_UI.Grid());
			
			_hitTest=true;
			var skin:Sprite = new Wall();
			
			
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