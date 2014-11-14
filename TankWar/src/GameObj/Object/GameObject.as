package GameObj.Object
{
	import flash.display.Sprite;
	
	/**
	 *游戏对象的基类
	 * @author XN-HuangH
	 * 
	 */	
	public class GameObject extends Sprite
	{
		 protected var _hitTest:Boolean= false; //碰撞测试
		 
		 public var objectListType:int=0;
		
		/**
		 * 是否参与碰撞检测 
		 */
		public function get hitTest():Boolean
		{
			return _hitTest;
		}
		
		
		public function GameObject()
		{
		}
		
		
		/**
		 * 动作,所有监听的动作统一在这边处理
		 */		
		public function Do():void{
		
		}
		
		/**
		 *死亡或销毁 
		 */		
		public function Die():void{
		
		}
	}
}