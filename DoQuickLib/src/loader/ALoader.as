package loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.setTimeout;
	
	/**
	 *封装各类Loader
	 */	
	public class ALoader extends EventDispatcher
	{

		private var _loader:Loader;
		private var _urlLoader:URLLoader;
		private var _urlStream:URLStream;
		private var _resInfo:ResInfo;
		
		
		private var _progressHandler:Function;
		private var _completeHandler:Function;
		private var _progress:int;
		
		
		public function ALoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 *加载元件的方式获取影片剪辑 
		 * @param url
		 * @param data 加载完毕后，返回
		 * @return 
		 * 
		 */		
		public function load(info:ResInfo,progressHandler:Function, completeHandler:Function):void{
			
			_resInfo=info;
			_progressHandler=progressHandler;
			_completeHandler=completeHandler;
			tryLoad();
		}
		

		/**
		 * 加载
		 */
		private function tryLoad():void
		{
			if(!_resInfo)return;
			switch(_resInfo.type)
			{
				case ResInfo.TYPE_SWF:
				{
					if(!_loader){
						_loader=new Loader();
						_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
						_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
						_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadResFailed);
					}
					
					_loader.load(new URLRequest(_resInfo.url));
					break;
				}
					
				case ResInfo.TYPE_URL:
				{
					if(!_urlLoader){
						_urlLoader = new URLLoader();
						_urlLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
						_urlLoader.addEventListener(Event.COMPLETE, onLoadComplete);
						_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadResFailed);
					}
					_urlLoader.load(new URLRequest(_resInfo.url))
					break;
				}
					
				case ResInfo.TYPE_STREAM:
				{
					if(!_urlStream){
						_urlStream = new URLStream();
						_urlStream.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
						_urlStream.addEventListener(Event.COMPLETE, onLoadComplete);
						_urlStream.addEventListener(IOErrorEvent.IO_ERROR, onLoadResFailed);
					}
					_urlStream.load(new URLRequest(_resInfo.url));
					break;
				}
			}
		}
		
		/**
		 * 加载资源失败
		 */
		protected function onLoadResFailed(e:IOErrorEvent):void
		{
			setTimeout(tryLoad,5000);
			// Event.OPEN
			this.dispatchEvent(e);
		}
		

		
		/**
		 * 加载包含元件的swf文件完成
		 */
		protected function onLoadComplete(e:Event):void
		{
			if(_completeHandler is Function){
				var data:*;
				var loaderInfo:LoaderInfo;
				if(_loader)loaderInfo = _loader.contentLoaderInfo
				switch(e.currentTarget){
					case loaderInfo:
						data = _loader.content;
						break;
					case _urlLoader:
						data = _urlLoader.data;
						break;
					case _urlStream:
						var buffer:ByteArray = new ByteArray();
						_urlStream.endian = Endian.LITTLE_ENDIAN;
						_urlStream.readBytes(buffer);
						data = buffer;
						break;
				}
				_completeHandler.call(null, _resInfo, e, data);
			}
		}
		
		/**
		 * 加载资源进程 
		 * @param evt 事件
		 * 
		 */		
		protected function onLoadProgress(e:ProgressEvent):void
		{
			_progress = e.bytesLoaded / e.bytesTotal * 100;
			if(_progressHandler is Function ){
				_progressHandler.call(null, _resInfo, _progress);
			}
		}
		
		
		/*关闭下载(给强制加载的空出带宽)*/
		public function close1():void{
			if(_progress > 75) return;
			//下载不超过75%的停掉
			clear();
		}
		
		public function clear():void{
			if(_resInfo){
				_resInfo.dispose();
				_resInfo = null;
			}
			_progressHandler = null;
			_completeHandler = null;
			
			if(_urlLoader){
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				_urlLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadResFailed);
				try{
					_urlLoader.close();
				}catch(e:Error){}
			}
			if(_loader){
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadResFailed);
				try{
					_loader.close();
				}catch(e:Error){}
			}
			if(_urlStream){
				_urlStream.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				_urlStream.removeEventListener(Event.COMPLETE, onLoadComplete);
				_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onLoadResFailed);
				try{
					_urlStream.close();
				}catch(e:Error){}
			}
			
			_loader = null;
			_urlLoader = null;
			_urlStream = null;
		}
		
	}
}