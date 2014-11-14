package dqWorld.core.game0.avatar.control
{
	import dqWorld.core.game0.avatar.BaseAvatarPic;

	/**
	 *控制器，改变对象的内部数据变化 
	 * @author XN-HuangH
	 * 
	 */	
	public class BaseCtrl
	{
		protected var _isNoResponse:Boolean=false;
		
		private var _target:BaseAvatarPic;

		public function get target():BaseAvatarPic
		{
			return _target;
		}

		public function set target(value:BaseAvatarPic):void
		{
			_target = value;
		}
		
		public function BaseCtrl()
		{
			
		}
		
		/**
		 *自动运行 
		 * 
		 */		
		public function update():void{
			
		}
		
		
		/**
		 *销毁 
		 * 
		 */		
		public function Die():void{
			
		}
	}
}