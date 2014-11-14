package dqWorld.core.game0.avatar
{
	import flash.geom.Point;
	
	import comLib.display.AnimationCache;

	public class EffectAnimationData
	{
		
		public static const TYPE_BEATTACT:uint=0;
		
		private var _pos:Point;

		public function get pos():Point
		{
			return _pos;
		}

		public function set pos(value:Point):void
		{
			_pos = value;
		}

		
		private var _type:uint;

		public function get type():uint
		{
			return _type;
		}

		public function set type(value:uint):void
		{
			_type = value;
		}

		private var _tid:String;

		public function get tid():String
		{
			return _tid;
		}

		public function set tid(value:String):void
		{
			_tid = value;
		}

		private var _time:int;

		public function get time():int
		{
			return _time;
		}

		public function set time(value:int):void
		{
			_time = value;
		}

		private var _loop:int;

		public function get loop():int
		{
			return _loop;
		}

		public function set loop(value:int):void
		{
			_loop = value;
		}
	
		
		private var _animation:AnimationCache;

		public function get animation():AnimationCache
		{
			return _animation;
		}

		public function set animation(value:AnimationCache):void
		{
			_animation = value;
		}
		
		public function EffectAnimationData()
		{
		}
	}
}