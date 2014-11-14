package comLib.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class AnimationCache
	{
		private  var bmdList:Array=new Array();
		
		private var  _curFrame:uint=1;
		private var _nextFrame:uint=1;
		
		private var  _totalFrame:uint=0;
		private var _time:int;
		private var _fps:uint=24;
		private var _bmd:BitmapData;
		
		private var _stop:Boolean=false;
		private var _loop:int;
		
		public var onComplteFn:Function;
		
		public function AnimationCache()
		{
			_time =getTimer();
		}
		
		public function init(refMc:MovieClip,loop:int=-1,fps:uint=24):void{
			_totalFrame=refMc.totalFrames;
			_fps=fps;
			_loop =loop;
			var canve:BitmapData;
			for (var i:int = 0; i < _totalFrame; i++) 
			{
				//创建一个当前帧画板,把所有的图层都绘制进来
				canve= new BitmapData(refMc.width,refMc.height,true,0);
				refMc.gotoAndStop(i+1);
				copyPixels(i+1,refMc,canve);
				bmdList[i]=canve;
			}
		}
		
		public function copyPixels(curFrame:uint,mc:DisplayObject,canve:BitmapData):void{
			var cbmd:BitmapData;
			cbmd=new BitmapData(mc.width,mc.height,true,0);
			if(!(mc is MovieClip)){
				cbmd.draw(cmc);
				canve.copyPixels(cbmd,cbmd.rect,new Point(cmc.x,cmc.y));
				return;
			}
			
			if(mc is MovieClip){
				if(curFrame>MovieClip(mc).totalFrames)return;
				MovieClip(mc).gotoAndStop(curFrame);
				
				var childNum:int = MovieClip(mc).numChildren;
				if(childNum==0){
					cbmd.draw(cmc);
					canve.copyPixels(cbmd,cbmd.rect,new Point(cmc.x,cmc.y));
					return;
				}
				
				for (var j:int = 0; j < childNum; j++) 
				{
					var cmc:DisplayObject = MovieClip(mc).getChildAt(j);
					cbmd=new BitmapData(cmc.width,cmc.height,true,0);
					cbmd.draw(cmc);
					
					if(cmc.name.indexOf("mc")!=-1){
						//如果是嵌套，深入下一层拷贝
						copyPixels(curFrame,cmc,canve);
					}
					else{
						//直接拷贝
						canve.copyPixels(cbmd,cbmd.rect,new Point(cmc.x,cmc.y));
					}
				}	
			}
		}
		
		public function getCurBmd():BitmapData{
			return getBmd(_curFrame-1);
		}
		
		public function update():BitmapData{
			
			if(getTimer()-_time<(1000/_fps)||_loop==0){
				return getBmd(_curFrame-1);
			}
			
			_time=getTimer();
			
			if(_curFrame!=_nextFrame)
				_curFrame=_nextFrame;
			
			_bmd=getBmd(_curFrame-1);
			if(_curFrame>=_totalFrame){
				_nextFrame=1;
				if(_loop>0){
					_loop--;
				}
				
				if(onComplteFn is Function)
						onComplteFn.call(null,this);
			}else{
				_nextFrame=_curFrame+1;
			}
			return _bmd;
		}
		
		private function getBmd(idx:uint):BitmapData{
		    if(idx<bmdList.length){
			 return bmdList[idx];
			}
			return null;
		}
	}
}