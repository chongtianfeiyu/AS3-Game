package test.FireworksProject
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import test.FireworksProject.obj.ClientDef;
	import test.FireworksProject.obj.FireworksParticle;
	
	/**
	 * 2014.8.4 烟花场景
	 * 目的:模拟烟花效果
	 * 知识点:
	 * 1.bitmapdata 取代 movieclip
	 * 2.元件的颜色变化控制
	 * 3.元件的缩放、角度、透明度控制
	 * 4.元件的滤镜控制
	 * 5.三角函数:三角函数是数学中常见的一类关于角度的函数,计算元件指定角度移动时候x,y轴的变化量计算
	 * 6.矩阵
	 * 7.性能优化
	 * 8.多位图组合
	 */

	public class FireWorksSence extends Bitmap
	{
		private var __stage:Stage;

		private var _filterTimer:Timer;
		
		//生成烟花效果所使用的BitmapData
		private var _fireWorks:Vector.<Object>;
		private var _fireWorkBd:BitmapData;  
		private var _needToUseBlur:Boolean;
		
		//发光部分的BitmapData
		private var _glowBd:BitmapData; 
		//发光粒子的BitmapData
		private var _fireWorksGlows:Array;
		//用于判断发光粒子的BitmapData是否需要绘制
		private var _needToUseGlow:Boolean;
		
		//模糊滤镜
		private var _clFilter:ConvolutionFilter = new ConvolutionFilter(3, 3, [1, 1, 1, 1, 32, 1, 1, 1, 1], 43,0);  
		private var _lastBound:Rectangle;
	
		public function FireWorksSence(_stage:Stage)
		{
			
			//创建bmp容器
			var bitmapData:BitmapData=new BitmapData(ClientDef.STAGE_WIDTH, ClientDef.STAGE_HEIGHT, false,   0x000000);
			var pixelSnapping:String="auto";
			var smoothing:Boolean=false;
			super(bitmapData, pixelSnapping, smoothing);
			
			_fireWorkBd=new BitmapData(ClientDef.STAGE_WIDTH, ClientDef.STAGE_HEIGHT, false,   0x000000);
			_glowBd=new BitmapData(ClientDef.STAGE_WIDTH, ClientDef.STAGE_HEIGHT, true,   0x000000);
			
			//初始化发光粒子的BitmapData，本次先分配两张
			_fireWorksGlows = [];
			//第一张，给1个像素填充75%不透明度白色，发光滤镜较弱，作为较暗的图像
			_fireWorksGlows[0] = new BitmapData(15, 15, true, 0x00000000);
			_fireWorksGlows[0].setPixel32(7, 7, 0xCCFFFFFF);
			_fireWorksGlows[0].applyFilter(_fireWorksGlows[0], _fireWorksGlows[0].rect, _fireWorksGlows[0].rect.topLeft, new GlowFilter(0xFFFFFF, 0.4));
			//第一张，给4个像素填充100%不透明度白色，发光滤镜较强，作为较亮的图像
			_fireWorksGlows[1] = new BitmapData(15, 15, true, 0x00000000);
			_fireWorksGlows[1].fillRect(new Rectangle(6, 6, 2, 5), 0xFFFFFFFF);
			_fireWorksGlows[1].applyFilter(_fireWorksGlows[1], _fireWorksGlows[1].rect, _fireWorksGlows[1].rect.topLeft, new GlowFilter(0xFFFFFF, 0.8, 6, 6, 4));
			
			__stage=_stage;
			__stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			__stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			_filterTimer = new Timer(5000);
			_filterTimer.addEventListener(TimerEvent.TIMER, onFilterTimerHandler);
			_filterTimer.start();
			
			_fireWorks=new Vector.<Object>();
			
		}
		
		protected function onFilterTimerHandler(event:TimerEvent):void
		{
			var _len:int = _fireWorks.length;
			//如果粒子数量大于0，舞台必然会有粒子的存在，也就不需要再做compare这种耗性能的判断了
			if(_needToUseBlur && _len == 0 && bitmapData.getColorBoundsRect(0xFFFFFF, 0x000000, false).width == 0){
				//如果fireworks_bd已经全是黑色，就不需要再用模糊滤镜了
				_needToUseBlur = false;
			}
			
			if(_needToUseGlow && _len == 0){
				_needToUseGlow = false;
			}
		}
		
		protected function onMouseDownHandler(event:MouseEvent):void
		{
			createFrieWorks(mouseX,mouseY);
			_needToUseBlur = _needToUseGlow=true;
		}
		
		protected function createFrieWorks(x:int,y:int):void{
			
			for (var i:int = 0; i < 100; i++) 
			{
				setTimeout(
					function():void{
						
						var particel:FireworksParticle=new FireworksParticle();
						
						//为烟花粒子设置随机的角度、透明度、缩放
						particel.rotation=Math.random()*360;
						particel.alpha = particel.scaleX = particel.scaleY= Math.random()* 0.3 + 0.7;
						particel.x= x;
						particel.y=y;
						
						//为每个烟花粒子设置随机颜色（方式：60%的概率全随机，40%的概率白色）
						var color:uint = (Math.random() > 0.9) ? 0xFFFFFF : Math.random() * 0xFFFFFF;
						particel.color = color;
						//将粒子属性同步到BitmapData中
						syncToBitMap(particel);
						
						//初始化物理学变量：初速度，用三角函数算出两个方向上的分量（这次速度调成随机的）
						particel.speedX = 6 * Math.random() * Math.cos(particel.rotation * Math.PI / 180);
						particel.speedY = 6 * Math.random() * Math.sin(particel.rotation * Math.PI / 180);
						//初始化物理学变量：向下的加速度（重力加速度）
						particel.accelerationY = 0.2;
						
						_fireWorks.push({particel:particel});
						
					},
					200*int(i/20)//每100毫秒出现10个“小球”
				);
			}
		}
		
		/***烟花粒子运动轨迹 */		
		protected function onEnterFrame(e:Event):void
		{
			if(!_needToUseBlur && !_needToUseGlow) {
				return;
			}
			
			//清空发光部分BitmapData重新绘制，使得原有的像素颜色不残留，发光粒子的运动显得更为干净利落
			if(_needToUseGlow && _lastBound){
				_glowBd.fillRect(_lastBound, 0x00000000);
			}
			
			bitmapData.lock();
			
			for each (var item:Object in _fireWorks) 
			{
				var particel:FireworksParticle=item.particel as FireworksParticle;
				//粒子运动计算
				particel.move();
				
				//将计算后的数据同步到BitmapData中
				syncToBitMap(particel);
				
				//以透明度接近于0作为条件，移除元件
				if(particel.finished){
					_fireWorks.splice(_fireWorks.indexOf(item), 1);
				}
			}
			
			if(_needToUseBlur){
			
				//为_fireWorkBd应用模糊滤镜，使得所有粒子都淡出到舞台上
				_fireWorkBd.applyFilter(_fireWorkBd, _fireWorkBd.rect, _fireWorkBd.rect.topLeft, _clFilter);
				//将主位图_fireWorkBd写入到最终显示的BitmapData上
				bitmapData.copyPixels(_fireWorkBd, _fireWorkBd.rect, _fireWorkBd.rect.topLeft);
			}
			
			if(_needToUseGlow){
				//将发光部分的位图写入到最终显示的BitmapData上
				bitmapData.copyPixels(_glowBd, _glowBd.rect, _glowBd.rect.topLeft);
			}
			
			//BitmapData操作完成，解锁
			var _thisBound:Rectangle = bitmapData.getColorBoundsRect(0xFFFFFF, 0x000000, false);
			bitmapData.unlock(_lastBound ? _thisBound.union(_lastBound) : _thisBound);
			_lastBound = _thisBound;
		}
		
		/**同步数据至BitMap  */		
		public function syncToBitMap(particel:FireworksParticle):void{
			
			//确定要绘制到BitmapData上的颜色
			var _color:uint = particel.color;
			var _centerX:Number = particel.x + Math.random() * 3;
			var _centerY:Number = particel.y + Math.random() * 3;
			//获得当前点的颜色
			var _centerColor:uint = _fireWorkBd.getPixel(_centerX, _centerY);
			//用滤色模式计算出结果色
			_color = getScreenColor(_color, _centerColor);
			/**删除原来的发光滤镜应用，改回色彩填充**/
			_fireWorkBd.fillRect(new Rectangle(_centerX, _centerY, 2, 2), _color);
			//随机一个发光粒子
			var _random_bd:BitmapData = _fireWorksGlows[int(Math.random() * 2)];
			//将其绘制到发光的BitmapData上
			_glowBd.copyPixels(_random_bd, _random_bd.rect, new Point(_centerX - 7, _centerY - 7));
			
		}
		
		private function screen(bg:int, blend:int):int
		{
			//滤色混合公式
			return 255 - (255 - bg) * (255 - blend) / 255;
		}
		private function getScreenColor(bgColor:uint, blendColor:uint):uint
		{
			//将通道分离出来
			var bgR:uint = bgColor >> 16 & 0xFF;
			var bgG:uint = bgColor >> 8 & 0xFF;
			var bgB:uint = bgColor & 0xFF;
			var blendR:uint = blendColor >> 16 & 0xFF;
			var blendG:uint = blendColor >> 8 & 0xFF;
			var blendB:uint = blendColor & 0xFF;
			//每个通道都混合一下
			var resultR:int = screen(bgR, blendR);
			var resultG:int = screen(bgG, blendG);
			var resultB:int = screen(bgB, blendB);
			return resultR << 16 | resultG << 8 | resultB;   
		}
	}
}