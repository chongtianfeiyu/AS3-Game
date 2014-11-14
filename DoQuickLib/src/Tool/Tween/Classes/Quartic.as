package Tool.Tween.Classes
{
	/**
	 *四次方的缓动（t^4） 
	 * @author XN-HuangH
	 * 
	 */	
	public class Quartic implements ITween
	{
		public function Quartic()
		{
			super();
		}
		
		public function easeIn(t, b, c, d):Number
		{
			return c*(t/=d)*t*t*t + b;
		}
		
		public function easeInOut(t, b, c, d):Number
		{
			if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
			return -c/2 * ((t-=2)*t*t*t - 2) + b;
		}
		
		public function easeOut(t, b, c, d):Number
		{
			return -c * ((t=t/d-1)*t*t*t - 1) + b;
		}
		
	}
}