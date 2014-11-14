package Event
{
	/**
	 *事件管理器 (观察者设计模式，广播中心，收听者[注册，移除])
	 * @author XN-HuangH
	 * 
	 */	
	public class CallBackDispatcher
	{
		/**
		 *收听者注册，移除事件后的列表 
		 */		
		private var _callBacks:Vector.<CallBackContent>=new Vector.<CallBackContent>();
	
		
		public function CallBackDispatcher()
		{
			
		}
		
		public function addCallBack( type:uint, callBackFn:Function):int{
			
			removeCallBack(type,callBackFn);
			var fnContent:CallBackContent = new CallBackContent(type,callBackFn);
			return _callBacks.push(fnContent);
		}
		
		public function removeCallBack(type:uint, callBackFn:Function):void{
			if(!_callBacks)return;
			
			
			var len:int =_callBacks.length;
			for (var i:int = 0; i < len; i++) 
			{
				var fn:CallBackContent = _callBacks[i];
				if(fn&&fn.type==type&&fn.callBackFn==callBackFn){
					_callBacks.splice(i,1);
					callBackFn=null
					break;
				}
			}
			
		}
		
		public function dispatchCallBack(type:uint, ...parameters):void{
			if(!_callBacks)return;
			var len:uint = _callBacks.length;//先获取长度，避免直接遍历数组时因为数组变动引发的移除
			
			for (var i:int = 0; i < len; i++) 
			{ 
				var fn:CallBackContent =_callBacks[i];
				if(fn&&fn.type==type){
					fn.callBackFn.apply(null,parameters);
				}
			}
			
		};
		
	}
}