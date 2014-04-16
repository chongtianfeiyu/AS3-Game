package Core.Controller
{
	import Core.Object.GameObjectBase;

	public class BasicController
	{
		
		protected var _target:GameObjectBase;
		
		public function BasicController()
		{
		}
		
		public function set target(character:GameObjectBase):void{
		 _target= character;
		}
		
		/**
		 * 自动运行
		 */
		public function AutoRun():void{}
		
		public function die():void{}
	}
}