package loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	
	/**
	 *多资源队列加载 
	 * @author XN-HuangH
	 * 
	 */	
	public class ResLoader extends EventDispatcher
	{
		
		/*已加载的资源*/
		private const _completes:Vector.<String> = new Vector.<String>();
		/*正在下载的资源*/
		private const _loading:Vector.<String> = new Vector.<String>();
		/*资源加载队列*/
		private const _seq:Vector.<ResInfo> = new Vector.<ResInfo>();
		/*当前阶段*/
		private var _curPacket:Vector.<ResInfo>;
		
		//计时器
		private const _timer:Timer = new Timer(100);
		
		public function ResLoader()
		{
		}
		
		private function onTimer(e:Event):void{
			onUpdate();
		}
		
		/**
		 * 插入预加载
		 */		
		public function preload(set:ResInfo):void
		{
			//存在于队列
			//if(findPacketPos(_seq, set.url)>=0) return;
			_seq[_seq.length] = set;
			startTimer();
		}
		
		
		/**
		 * 开始计时器 
		 * 
		 */		
		private function startTimer():void{
			stopTimer();
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
		}
		
		/**
		 * 停止计时器 
		 * 
		 */		
		private function stopTimer():void{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
		}
		
		/**
		 * 查找指定的 
		 * @param packet
		 * @param url
		 * @return 
		 * 
		 */		
		private function findPacketPos(packet:Vector.<ResInfo>, url:String):int{
			for (var i:int = 0; i < packet.length; i++) {
				if(packet[i].url == url) return i;
			}
			return -1;
		}
		
		private var _loader:ALoader;
		/**
		 * 进入一个阶段
		 * @param newPhase
		 * @return 返回插入是否成功
		 */
		public function loadAssetPacket(newPacket:Vector.<ResInfo>):Boolean
		{
			if(_curPacket) return false;//理论上来讲不允许强制加载时再插入强制队列
			var len:uint = newPacket.length;
			for(var i:int = 0; i < len; i ++)
			{
				var ls:ResInfo = newPacket[i];
				//从完成列表里拿掉为了触发回调
				idx = _completes.indexOf(ls.url);
				if(idx != -1){
					_completes.splice(idx, 1);
				}
				//判断队列里面是否存在、位置
				var idx:int = findPacketPos(_seq, ls.url);
				//队列存在则先移除，等待后面统一插入到最前端，其实就是排序
				if(idx >=0){
					var info:ResInfo = _seq[idx];
					_seq.splice(idx, 1);
					//插入到队伍最前头
					_seq.splice(0, 0, info);
					info.copy(ls);
					newPacket[i] = info;
					ls.dispose();
				}
				else{
					//插入到队伍最前头
					_seq.splice(0, 0, ls);
				}
			}
			//设置当前的下载资源包
			_curPacket = newPacket;
			//如果没启动，则启动
			startTimer();
			return true;
		}
		
		/*心跳检测*/
		private function onUpdate():void
		{
			if(_curPacket)
			{
				var isCurPacketComplete:Boolean = true;
				var len:uint = _curPacket.length;
				for(var i:int = 0; i < len; i ++){
					if(_completes.indexOf(_curPacket[i].url) < 0){
						isCurPacketComplete = false;
						break;
					}
				}
				//抛出下载完成事件
				if(isCurPacketComplete){
					var event:ResLoaderEvent = new ResLoaderEvent(Event.COMPLETE);
					event.asset = _curPacket;
					//当前包完成了，不理会了
					_curPacket = null;
					dispatchEvent(event);
				}
			}			
			
			//按照队列顺序进行下载
			if(_seq.length==0) {
				//队列没东西，心跳停下来吧
				stopTimer();
				return;
			}
			//已经在下载了，等待它的完成吧
			if(_loading.indexOf(_seq[0].url) >= 0) return;
			//存在于完成列表，则忽略
			if(_completes.indexOf(_seq[0].url)>=0){
				//从队列移除
				_seq[0].dispose();
				_seq.splice(0, 1);
				return;
			}
			
			//插入到正在加载的队列
			_loading.splice(0, 0, _seq[0].url);
			//开始加载
			//Log.outDebug("load asset->" + _seq[0].name + ":" + _seq[0].url);
			_loader = new ALoader();
			_loader.load(_seq[0], onProgressHandler, onCompleteHandler);
		}
		
		/*更新下载进度*/
		private function onProgressHandler(asset:ResInfo, progress:int):void{
			if(!_curPacket || _curPacket.indexOf(asset) < 0 || asset.isBackground) return;
			var event:ResLoaderEvent = new ResLoaderEvent(ResLoaderEvent.PROGRESS);
			event.asset = _curPacket;
			event.assetName = asset.name;
			event.progress = progress;
			dispatchEvent(event); 
		}
		
		private function onCompleteHandler(asset:ResInfo, e:Event, data:*):void
		{
			if(_completes.indexOf(asset.url) >= 0)
				throw new Error("AssetLoader Error Repeat downloads URL:" + asset.url);
			
			var loadingIdx:int = _loading.indexOf(asset.url);
			if(loadingIdx <0)
				throw new Error("AssetLoader Error this resource URL not in download list:" + asset.url);
			
//			var seqIdx:int = findPacketPos(_seq, asset.url);
//			if(seqIdx<0)
//				throw new Error("AssetLoader Error this resource URL not in list:" + asset.url);
			
			//插入到已完成列表
			_completes[_completes.length] = asset.url;
			//从正在下载列表移除
			_loading.splice(loadingIdx, 1);
			
			//从队列移除
			var rems:Vector.<ResInfo>=new Vector.<ResInfo>();
			for each (var res:ResInfo in _seq) 
			{
				if(res.url==asset.url){
					if(res.onComplete is Function){
						res.onComplete.call(null, data);
						res.dispose();
					}
					rems.push(res);
				}
			}
			
			for (var i:int = 0; i < rems.length; i++) 
			{
				var idx:int = _seq.indexOf(rems[i]);
				if(idx!=-1)
					_seq.splice(idx,1);
			}
		}
		
		public function close():void
		{
			stopTimer();
			
			if(_loader)
				_loader.close1();
		}
		
		
		/**
		 * 释放
		 */		
		public function dispose():void{
			close();
			_completes.length = 0;
			_loading.length = 0;
			if(_curPacket){
				while(_curPacket.length){
					var assetInfo:ResInfo = _curPacket.shift();
					if(assetInfo)
						assetInfo.dispose();
				}
			}
			while(_seq.length){
				assetInfo = _seq.shift();
				if(assetInfo)
					assetInfo.dispose();
			}
			if(_loader)
				_loader.clear();
			_loader = null;
		}
		
	}
}