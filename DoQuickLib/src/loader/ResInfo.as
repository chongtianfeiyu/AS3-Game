package loader
{
	import flash.system.LoaderContext;

	public class ResInfo
	{
		/**swf资源*/		
		public static const TYPE_SWF:uint=0;
		/**UrlLoader方式 加载 */		
		public static const TYPE_URL:uint=1;
		/**Stream方式加载文件*/		
		public static const TYPE_STREAM:uint=2;
		
		
		private var _name:String;
		private var _isBackground					:Boolean = false; 

	
		/**
		 * 是否后台下载
		 */
		public function get isBackground():Boolean
		{
			return _isBackground;
		}
		
		/**
		 * 资源名称
		 */
		public function get name():String
		{
			return _name;
		}
		
		private var _url:String;
		
		/**
		 * 资源路径
		 */
		public function get url():String
		{
			return _url;
		}
		
		private var _type:uint;
		
		/**
		 * 资源类型
		 */
		public function get type():uint
		{
			return _type;
		}
		
		private var _onComplete:Function;

		public function get onComplete():Function
		{
			return _onComplete;
		}

		
		private var _loaderContext:LoaderContext;
		
		public function get loaderContext():LoaderContext{
			return _loaderContext;
		}
		
		
		public function ResInfo(name:String, url:String, type:uint, onComplete:Function = null, background:Boolean = false, context:LoaderContext = null)
		{
			_name = name;
			_url = url;
			_type = type;
			_onComplete = onComplete;
			_isBackground = background;
			_loaderContext = context;
		}
		
		/**
		 * 释放
		 */		
		public function dispose():void{
			_onComplete = null;
			_loaderContext = null;
		}
		
		/**
		 * 拷贝
		 */		
		public function copy(info:ResInfo):void{
			_name = info._name;
			_url = info._url;
			_type = info._type;
			_onComplete = info._onComplete;
			_isBackground = info._isBackground;
			_loaderContext = info._loaderContext;
		}
	}
	
}


