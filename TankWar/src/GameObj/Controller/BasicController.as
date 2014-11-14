package GameObj.Controller
{
	import GameObj.Object.ActionObject;
	import GameObj.Object.GameObject;
	
	/**
	 *基础控制器 
	 * @author XN-HuangH
	 * 
	 */	
	public class BasicController
	{
		/**
		 *控制对象 
		 */		
		protected var _target:GameObject;
		
		public function BasicController()
		{
			
		}
		
		/**
		 * 设置控制对象
		 */
		public function set target(obj:ActionObject):void
		{
			_target = obj;
		}
		
		/**
		 * 消亡
		 */
		public function Die():void{
		
		}
		
		public function AutoRun():void{
		
		}
		
	}
}