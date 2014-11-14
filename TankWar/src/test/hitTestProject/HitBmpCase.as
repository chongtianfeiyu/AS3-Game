package test.hitTestProject
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class HitBmpCase extends Bitmap
	{
		private var _color:uint;
		private var _radius:Number;
		private var _vx:Number=0;
		private var _vy:Number=0;
		private var _txt:TextField;
		
		public var preLogicCell:Array;
		
		public function update():void {
			x+=_vx;
			y+=_vy;
		}
		public function set color(value:uint):void {
			_color=value;
			draw();
		}
		public function get color():uint {
			return _color;
		}
		public function set radius(value:Number):void {
			_radius=value;
			draw();
		}
		public function get radius():Number {
			return _radius;
		}
		public function set vx(value:Number):void {
			_vx=value;
		}
		public function get vx():Number {
			return _vx;
		}
		public function set vy(value:Number):void {
			_vy=value;
		}
		public function get vy():Number {
			return _vy;
		}
		
		public function HitBmpCase(radius:Number, color:uint = 0xffffff)
		{
			_radius=radius;
			_color=color;
			
			var bitmapData:BitmapData=new  BitmapData(radius*2,radius*2,true,color);
			var pixelSnapping:String="auto";
			var smoothing:Boolean=false;

			
			super(bitmapData, pixelSnapping, smoothing);
			draw();
		}
		
		private function draw():void {
			
			var sprite:Sprite = new Sprite();  
			sprite.graphics.clear();
			sprite.graphics.lineStyle(0);
			sprite.graphics.beginFill(_color, 1);
			sprite.graphics.drawCircle(_radius,_radius, _radius);
			sprite.graphics.endFill();
			sprite.graphics.drawCircle(sprite.width/2, sprite.height/2, 1);//在中心画一个点
		
			bitmapData.draw(sprite);
		}
	}
}