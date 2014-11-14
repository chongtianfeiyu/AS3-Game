package Tool.Tween.Classes
{
	/**
	 *圆形曲线的缓动（sqrt(1-t^2)） 
	 * @author XN-HuangH
	 * 
	 */	
	public class Circular implements  ITween
	{
		public function Circular()
		{
			super();
		}
		
		 public function easeIn(t, b, c, d):Number
		{
			// TODO Auto Generated method stub
			return super.easeIn(t, b, c, d);
		}
		
		 public function easeInOut(t, b, c, d):Number
		{
			// TODO Auto Generated method stub
			return super.easeInOut(t, b, c, d);
		}
		
		 public function easeOut(t, b, c, d):Number
		{
			// TODO Auto Generated method stub
			return super.easeOut(t, b, c, d);
		}
		
	}
}