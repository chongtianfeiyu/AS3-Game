package Tool.Tween.Classes
{
	/**
	 *五次方的缓动（t^5） 
	 * @author XN-HuangH
	 * 
	 */	
	public class Quintic implements ITween
	{
		public function Quintic()
		{
			super();
		}
		
		public function easeIn(t, b, c, d):Number
		{
			return c*(t/=d)*t*t*t*t + b;
		}
		
		public function easeInOut(t, b, c, d):Number
		{
			return c*((t=t/d-1)*t*t*t*t + 1) + b;
		}
		
		public function easeOut(t, b, c, d):Number
		{
			if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
			return c/2*((t-=2)*t*t*t*t + 2) + b;
		}
		
	}
}