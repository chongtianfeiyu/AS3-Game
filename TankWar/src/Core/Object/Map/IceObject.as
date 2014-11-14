package Core.Object.Map
{
	import GameObj.Object.ActionObject;
	
	import TANK_UI.Ice;
	
	public class IceObject extends ActionObject
	{
		public function IceObject()
		{
			super();
			_hitTest=false;
			addChild(new Ice());
		}
	}
}