package Event
{
	/**
	 *回调函数
	 * @author XN-HuangH
	 * 
	 */	
	public class CallBackContent
	{
		/**
		 *回调类型 
		 */		
		public var type:int;
		
		/**
		 *回调函数 
		 */		
		public var callBackFn:Function;
		
		/**
		 * 是否已经失效
		 */
		public var isFailure:Boolean;
		
		public function CallBackContent(_type:int,_callBackFn:Function)
		{
			type=_type;
			callBackFn =_callBackFn;
		}
	}
}