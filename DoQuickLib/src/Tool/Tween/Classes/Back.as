package Tool.Tween.Classes
{
	/**
	 *超过范围的三次方缓动（(s+1)*t^3 - s*t^2） 
	 * @author XN-HuangH
	 * 
	 */	
	public class Back implements ITween_3
	{
		public function Back()
		{
		}
		
		public function easeIn(t:*, b:*, c:*, d:*, s:*):Number
		{
			if (s == undefined) s = 1.70158;
			return c*(t/=d)*t*((s+1)*t - s) + b;
		}
		
		public function easeOut(t:*, b:*, c:*, d:*, s:*):Number
		{
			if (s == undefined) s = 1.70158;
			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
		}
		
		public function easeInOut(t:*, b:*, c:*, d:*, s:*):Number
		{
			if (s == undefined) s = 1.70158; 
			if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
			return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
		}
	}
}