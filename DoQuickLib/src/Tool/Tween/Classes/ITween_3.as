package Tool.Tween.Classes
{
	/**
	*缓动效果类
	* @author XN-HuangH
	* Linear：无缓动效果；
	*Quadratic：二次方的缓动（t^2）；
	*Cubic：三次方的缓动（t^3）；
	*Quartic：四次方的缓动（t^4）；
	*Quintic：五次方的缓动（t^5）；
	*Sinusoidal：正弦曲线的缓动（sin(t)）；
	*Exponential：指数曲线的缓动（2^t）；
	*Circular：圆形曲线的缓动（sqrt(1-t^2)）；
	*Elastic：指数衰减的正弦曲线缓动；
	*Back：超过范围的三次方缓动（(s+1)*t^3 - s*t^2）；
	*Bounce：指数衰减的反弹缓动。
	 * 
	 * 
	 * 
	 * 每个效果都分三个缓动方式（方法），分别是：
	 *easeIn：从0开始加速的缓动；
 	 *easeOut：减速到0的缓动；
	 *easeInOut：前半段从0开始加速，后半段减速到0的缓动。
	 * 
	 */	
	public interface ITween_3
	{
	
		/**
		 * 
		 * @param t current time（当前时间）
		 * @param b  beginning value（初始值）
		 * @param c change in value（变化量）
		 * @param d duration（持续时间）
		 *  @param s Specifies the amount of overshoot, where the higher the value指定的过冲量，该值，其中较高) 
		 * @return 
		 * 
		 */		
		 function    easeIn(t,b,c,d,s):Number;
		
		
		
		/**
		 * 
		 * @param t current time（当前时间）
		 * @param b  beginning value（初始值）
		 * @param c change in value（变化量）
		 * @param d duration（持续时间）
	    * @param s Specifies the amount of overshoot, where the higher the value指定的过冲量，该值，其中较高) 
		 * @return 
		 * 
		 */		
		  function  easeOut(t,b,c,d,s):Number;
		
		 
		 
		 /**
		  * 
		  * @param t current time（当前时间）
		  * @param b  beginning value（初始值）
		  * @param c change in value（变化量）
		  * @param d duration（持续时间）
			*  @param s Specifies the amount of overshoot, where the higher the value指定的过冲量，该值，其中较高) 
		  * @return 
		  * 
		  */		
		  function  easeInOut(t,b,c,d,s):Number;
		
		
	}
}