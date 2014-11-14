package test.AvatarProject
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 *动画对象 
	 * @author XN-HuangH
	 * 
	 */	
	public class AnimationObject extends Bitmap
	{
		//动画帧率
		private var timer:Timer = new Timer( 100 );
		public var imgList:Vector.<Vector.<Bitmap>> = new  Vector.<Vector.<Bitmap>>();
		
		private var currentFrame:int = 0;
		private var _stopIndex:int = 0;
		
		/**
		 * 设置动画帧率 
		 * @param value 多少时间切换一副图片，单位毫秒
		 * 
		 */                
		public function set frameRate( value:int ):void{
			timer.delay = value;
		}
		
		/**
		 * 设置动画播放次数 ，若为0，则不断运行，默认为0
		 * @param value 动画播放次数，单位：次
		 * 
		 */                
		public function set repeatCount( value:int ):void{
			timer.repeatCount = value * imgList.length;
		}
		
		
		public function AnimationObject(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
		}		
		
		/**
		 * 播放动画 
		 * 
		 */                
		public function play():void{
			timer.reset();
			timer.start();
		}
		/**
		 * 停止动画 
		 * 
		 */                
		public function stop():void{
			timer.stop();
		}
	}
}