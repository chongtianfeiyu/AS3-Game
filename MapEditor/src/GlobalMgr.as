package
{
	import flash.display.Stage;
	
	import loader.ResLoader;

	public class GlobalMgr
	{
		public static var  stage:Stage;
		public static const   loderMgr:ResLoader=new ResLoader();
		
		public function GlobalMgr()
		{
		}
	}
}