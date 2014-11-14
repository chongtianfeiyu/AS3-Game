package Core.Object.Map
{

	import flash.display.Sprite;
	
	import GameObj.Object.ActionObject;
	
	import TANK_UI.Grass;

	public class GrassObject extends ActionObject
	{
		public function GrassObject()
		{
			super();
			_hitTest=false;
			
			var skin:Sprite = new Sprite();
			var row:int=1;
			for ( var k:int = 2; k < 6; k++) 
			{
				var wall:Grass =new  Grass();
				if(k==4){
					row=2;
				}
				
				wall.x = (k%2)*wall.width;
				wall.y=((row-1))*wall.height;
				skin.addChild(wall);
			}
			
			addChild(skin);

		}
		
	}
}