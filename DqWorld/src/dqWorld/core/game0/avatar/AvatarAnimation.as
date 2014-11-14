package dqWorld.core.game0.avatar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *Avatar动作播放器 
	 * @author XN-HuangH
	 * 
	 */	
	public class AvatarAnimation
	{
		private var _nullBmd:Bitmap;
		/**
		 *设置默认的空样式 
		 */		
		public function set nullBmd(value:Bitmap):void
		{
			_nullBmd = value;
		}
		
		/**
		 *一个记录动画的二维序列 
		 */
		private var _matrixBitmaps:Array;
		
		private var _loop:int=-1;
		
		private var _layer:uint;

		public function get layer():uint
		{
			return _layer;
		}

		
		private var _curFrame:uint;

		/**
		 *当前所在帧 
		 */		
		public function get curFrame():uint
		{
			return _curFrame;
		}
		public function set curFrame(value:uint):void
		{
			_curFrame = value;
		}

		private var _nextFrame:uint;
		/**
		 *下一次要播放的帧 
		 */		
		public function get nextFrame():uint
		{
			return _nextFrame;
		}
		
		private var _endFrame:int;
		private var _startFrame:uint;
		public var complteCallBack:Function;
		private var _bmd:BitmapData;
		private var _canUpdateNextFrame:Boolean;
		private var _isStop:Boolean;
	
		
		/**
		 * 负责播放bmd序列,这个序列是一个二维序列 [关键层，序列组]
		 * @param matrixBitmapData 一个二维序列 维度1为
		 * 
		 */		
		public function AvatarAnimation(matrixBitmaps:Array)
		{
			_matrixBitmaps=matrixBitmaps;
			
			var loadingSp:Sprite=new Sprite();
			var tx:TextField=new TextField();
			tx.height=36;
			tx.defaultTextFormat=new TextFormat("宋体",12);
			tx.text="loading...";
			loadingSp.addChild(tx);
			_nullBmd=new Bitmap(new BitmapData(loadingSp.width,loadingSp.height,true,0));
			_nullBmd.bitmapData.draw(loadingSp);
		}
		
		/**
		 *动画播放 
		 * @param action 播放动作
		 * @param loop 重复次数
		 * @param startFrame 开始帧数 -1为自动为开始位置
		 * @param endFrame  结束帧数 -1为自动到结束位置
		 */		
		public function play(layer:int,loop:int=-1,startFrame:int=1,endFrame:int=-1):void{
			
			_layer=layer;
			_loop =loop;
			
			_startFrame=startFrame<=1?1:startFrame;
			_curFrame=_startFrame-1;
			
			//这个参数没有重新赋值，导致下一帧动作直接跳到结束位置，一个下午的精力都挂在这里了
			_nextFrame=_curFrame;
			
			_endFrame=endFrame<=1?1:endFrame;
			_endFrame=endFrame-1;
			
			if(_endFrame!=-1&&_endFrame<=startFrame)
				_endFrame=-1;
		}
		
		public function stop():void{
			_isStop =true;
		}
		
		public function update():BitmapData{
			
			if(!_matrixBitmaps||_layer>=_matrixBitmaps.length){
				return _nullBmd.bitmapData;
			}
		
			if(_loop==0){
				//停在最后播放的那一帧上
				return getBitmapData(_layer,_curFrame);
			}
			
			if(_curFrame!=_nextFrame)
				_curFrame=_nextFrame;	
			
			_bmd= getBitmapData(_layer,_curFrame);
			
			//如果是最后一帧,重新开始
			if(_curFrame>=_matrixBitmaps[layer].length-1||(_endFrame!=-1&&_curFrame>_endFrame)){
				if(_loop>0){
					_loop--;
					if(_loop==0){
						if(complteCallBack is Function)
							complteCallBack.call(null);
					}
				}
				_nextFrame=_startFrame-1;
				return _bmd;
			}
			
			//如果有指定开始
			if(_startFrame!=-1&&_curFrame<_startFrame-1){
				_nextFrame=_startFrame-1;
				return _bmd;
			}
			
			_nextFrame=_curFrame+1;
			return _bmd;
		}
		
		private function getBitmapData(layer:uint,frame:uint):BitmapData{
			if(layer<_matrixBitmaps.length){
				if(frame<_matrixBitmaps[layer].length){
					return _matrixBitmaps[layer][frame];
				}
			}
			
			return _nullBmd.bitmapData;
		}
		
	
	}
}