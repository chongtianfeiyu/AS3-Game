package test.AvatarProject
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class bmpMgr extends Sprite
	{
	
		
		private var  _matrixBitmap:Array;
		private var _direction:int=0;
		private var _bmp:Bitmap;
		private var _isLoaded:Boolean=false;
		private var _speed:Number=10;
		private var _isMove:Boolean=false;
		
		public function bmpMgr(stage:Stage)
		{
			super();
			var loader:URLLoader=new URLLoader();
			loader.load(new URLRequest("../asset/res/b4.png"));
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandle);
			loader.addEventListener(Event.COMPLETE,onCompleteHandle);
			
			_matrixBitmap=new Array();
			
			var timer:Timer =new Timer(300);
			timer.addEventListener(TimerEvent.TIMER,onTimerEvent);
			timer.start();
			
			_bmp=new Bitmap();
			addChild(_bmp);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			_isMove=false;
			
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:					
					_direction=3;_isMove=true;break;
				case Keyboard.DOWN:					
					_direction=0;_isMove=true;break;
				case Keyboard.LEFT:					
					_direction=1;_isMove=true;break;
				case Keyboard.RIGHT:					
					_direction=2;_isMove=true;break;
			}
			
		}
		
		protected function onTimerEvent(event:TimerEvent):void
		{
			if(!_isLoaded)return;
			
			if(_isMove){
				switch(_direction)
				{
					case 3:	y-=_speed;break;
					case 0:	y+=_speed;break;
					case 1:	x-=_speed;break;
					case 2:	x+=_speed;break;
				}
			}
			
			if(_matrixBitmap&&_matrixBitmap.length>_direction){
				_matrixBitmap[_direction].push(_matrixBitmap[_direction].shift());
				//永远播放最上面的帧
				_bmp.bitmapData=_matrixBitmap[_direction][0];
			}
	
		}
	
		
		protected function onCompleteHandle(e:Event):void
		{
			var bArr:ByteArray =  e.target.data; 
			var loader:Loader = new Loader(); 
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onLoadComplete); 
			loader.loadBytes(bArr); 
			
		}
		
		protected function __onLoadComplete(e:Event):void
		{
			var bit:Bitmap = e.target.content as Bitmap;
			_matrixBitmap=fillArr(bit.bitmapData,4,4);
			_isLoaded=true;
		}
		
		protected function onProgressHandle(e:ProgressEvent):void
		{
			trace(e.bytesLoaded/e.bytesTotal);
		}
		
		private function fillArr(bmd:BitmapData,wNum:uint,hNum:uint):Array{
		  var arr:Array=[];
		  var mx:Matrix=new Matrix();
		  var sw:Number=bmd.width / wNum;
		  var sh:Number=bmd.height / hNum;
		  
		  var _bmd:BitmapData=new BitmapData(sw, sh);
		  for (var i:uint=0; i < hNum; i++)
		  {
			  arr[i]=[];
			  for (var j:uint=0; j < wNum; j++)
			  {    
				  //相当于又建立了个BitmapData的实例
				  _bmd=_bmd.clone();
				  mx.tx=-1 * sw * j;
				  mx.ty=-1 * sh * i;
				  //给每个画面加入位图数据
				  _bmd.draw(bmd, mx);
				  arr[i][j]=_bmd;
			  }
		  }
		
		  return arr;
		}
		
		public function doMove(direction:int=0):void{
			_direction=direction;
		}
	}
}