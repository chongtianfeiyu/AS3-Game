package Tool.Tween.Classes
{
	/**
	 *指数衰减的反弹缓动 
	 * @author XN-HuangH
	 * 
	 */	
	public class Bounce implements ITween
	{
		public function Bounce()
		{
		}
		
		public function easeIn(t:*, b:*, c:*, d:*):Number
		{
			return c - new Bounce().easeOut(d-t, 0, c, d) + b;
		}
		
		public function easeOut(t:*, b:*, c:*, d:*):Number
		{
			if (t < d/2) return new Bounce().easeIn(t*2, 0, c, d) * .5 + b;
			else return new Bounce().easeOut(t*2-d, 0, c, d) * .5 + c*.5 + b;
		}
		
		public function easeInOut(t:*, b:*, c:*, d:*):Number
		{
			if ((t/=d) < (1/2.75)) {
				return c*(7.5625*t*t) + b;
			} else if (t < (2/2.75)) {
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} else if (t < (2.5/2.75)) {
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} else {
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
			}
		}
	}
}