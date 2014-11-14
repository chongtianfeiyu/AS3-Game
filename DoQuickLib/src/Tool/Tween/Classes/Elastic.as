package Tool.Tween.Classes
{
	/**
	 *指数衰减的正弦曲线缓动 
	 * @author XN-HuangH
	 * 
	 */	
	public class Elastic implements ITween_2
	{
		public function Elastic()
		{
		}
		
		public function easeIn(t, b, c, d, a, p):Number
		{
			var s:Number;
			
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (!a || a < Math.abs(c))
			{ 
				a=c; 
				 s=p/4;
			}
			else {
				 s = p/(2*Math.PI) * Math.asin (c/a);
			}
			
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		}
		
		public function easeInOut(t, b, c, d, a, p):Number
		{
			var s:Number;
			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
			if (!a || a < Math.abs(c)) { a=c;  s=p/4; }
			else  s = p/(2*Math.PI) * Math.asin (c/a);
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
			
			
		}
		
		public function easeOut(t, b, c, d, a, p):Number
		{
			var s:Number;
			
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (!a || a < Math.abs(c)) { a=c;  s=p/4; }
			else  s = p/(2*Math.PI) * Math.asin (c/a);
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
		}
		
	}
}