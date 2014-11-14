package Core.Sound
{
	import TANK_SOUND.SoundShot;

	public class SoundMgr
	{
		private static var _soundShot:TANK_SOUND.SoundShot;
		private static var _soundFire:TANK_SOUND.SoundFire;
		private static var _soundBoom1: TANK_SOUND.SoundBoom1;
		
		public function SoundMgr()
		{
		}
		
		public static function playTankShot():void{
			if(!_soundShot)
				_soundShot =new  TANK_SOUND.SoundShot();
			_soundShot.play();
		}
		
		public static function playSoundFire():void{
			if(!_soundFire)
				_soundFire =new  TANK_SOUND.SoundFire();
			_soundFire.play();
		}
		
		
		public static function playSoundBoom1():void{
			if(!_soundBoom1)
				_soundBoom1 =new  TANK_SOUND.SoundBoom1();
			_soundBoom1.play();
		}
	}
}