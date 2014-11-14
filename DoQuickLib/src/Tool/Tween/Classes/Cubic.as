package Tool.Tween.Classes
{
	/**
	 *Cubic：三次方的缓动（t^3） 
	 * @author XN-HuangH
	 * 
	 */	
	public class Cubic implements ITween
	{
		public function Cubic()
		{
			//TODO: implement function
			super();
		}
		
		public function easeIn(t, b, c, d):Number
		{
			return c*(t/=d)*t*t + b;
		}
		
		public function easeInOut(t, b, c, d):Number
		{
			if ((t/=d/2) < 1) return c/2*t*t*t + b;
			return c/2*((t-=2)*t*t + 2) + b;
		}
		
		public function easeOut(t, b, c, d):Number
		{
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		
	}
}