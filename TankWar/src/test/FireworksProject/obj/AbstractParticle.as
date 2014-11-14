package test.FireworksProject.obj
{
	public class AbstractParticle
	{
		//当前的x坐标
		public var x:Number;  
		//当前的y坐标
		public var y:Number;  
		//当前的alpha值
		public var alpha:Number;  
		//当前的scaleX值
		public var scaleX:Number;  
		//当前的scaleY值
		public var scaleY:Number;  
		//当前的旋转角度
		public var rotation:Number;  
		//x方向的速度
		public var speedX:Number;  
		//y方向的速度
		public var speedY:Number;  
		//x方向的加速度
		public var accelerationX:Number;  
		//y方向的速度
		public var accelerationY:Number;
		//粒子的颜色
		public var color:uint;
		
		public function AbstractParticle()
		{
			x = 0;
			y = 0;
			alpha = 1;
			scaleX = 1;
			scaleY = 1;
			rotation = 0;
			speedX = 0;
			speedY = 0;
			accelerationX = 0;
			accelerationY = 0;  
		}
		
		/**
		 * 移动粒子
		 *
		 **/
		public function move():void{
			
		}  
		
		/**
		 * 是否完成了它的使命
		 *
		 **/
		public function get finished():Boolean {
			return false;
		}  
	}
}