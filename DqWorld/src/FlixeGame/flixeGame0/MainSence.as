package FlixeGame.flixeGame0
{
	import org.flixel.FlxGame;
	
	[SWF(width="800", height="800", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class MainSence extends FlxGame
	{
		public function MainSence()
		{
			super(800,800,FlixeGame.flixeGame0.MenuState,1,20,20);
		}
	}
}