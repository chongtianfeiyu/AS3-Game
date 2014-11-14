package Tool.Tween.Classes
{
	/**
	 *二次方的缓动（t^2） 
	 * @author XN-HuangH
	 */	
	public class Quadratic implements ITween
	{
		public function Quadratic()
		{
			super();
		}
		
		public function easeIn(t, b, c, d):Number
		{
			return c*(t/=d)*t + b;
		}
		
		public function easeInOut(t, b, c, d):Number
		{
			if ((t/=d/2) < 1) return c/2*t*t + b;
			return -c/2 * ((--t)*(t-2) - 1) + b;
		}
		
		public function easeOut(t, b, c, d):Number
		{
			return -c *(t/=d)*(t-2) + b;
		}
		
	}
}