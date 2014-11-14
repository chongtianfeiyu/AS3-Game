package comLib.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 *影片剪辑缓存 
	 * @author XN-HuangH
	 * 
	 */	
	public class MovieClipCache extends Bitmap
	{
		
		/*缓存数据集合*/
		public static var __CACHE:Dictionary = new Dictionary(true);
		
		public function MovieClipCache(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}