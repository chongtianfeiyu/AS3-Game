package Tool.Tween.Classes
{
	
	
	/**
	 *无缓动效果 
	 * @author XN-HuangH
	 * 效果图:
	 */	
	public class Linear implements ITween
	{
		public function Linear()
		{
		}
		
		public function easeIn(t, b, c, d):Number
		{
			return c*t/d + b; 
		}
		
		public function easeInOut(t, b, c, d):Number
		{
			return c*t/d + b; 
		}
		
		public function easeOut(t, b, c, d):Number
		{
			return c*t/d + b; 
		}
		
	}
}