package Core.Character
{
	import flash.display.Sprite;
	
	import Core.Controller.BasicController;
	import Core.Object.ActionObject;
	
	public class WizPlayer extends ActionObject
	{
		public function WizPlayer(ctrl:BasicController)
		{
			super(ctrl,new WIZ());
		}
	}
}