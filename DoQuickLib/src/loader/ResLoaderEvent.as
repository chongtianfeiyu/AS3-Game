package loader
{
	import flash.events.Event;
	
	public class ResLoaderEvent extends Event
	{
		
		public static const PROGRESS:String = "PROGRESS";
		public var asset:Vector.<ResInfo>;//资源包
		public var assetName:String;//素材名称
		public var progress:Number;//进度
		public var info:ResInfo;//资源
		public var data:*;//数据
		public function ResLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}