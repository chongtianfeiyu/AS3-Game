package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import FlixeGame.ModeMaster.Mode;
	import FlixeGame.flixeGame0.MainSence;
	
	import dqWorld.core.game0.globalMgr;
	import dqWorld.core.game0.avatar.PlayerAvatar;
	import dqWorld.core.game0.sence.MainSence;

	public class DqWorld extends Sprite
	{
		private var _avatar:PlayerAvatar;
		public static var _stage:Stage;
		
		
		public function DqWorld()
		{
			 addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			_stage=stage;
			stage.scaleMode =StageScaleMode.NO_SCALE;
			globalMgr.stage =stage;
			
//			addChild(new MainSence());
			addChild(new FlixeGame.flixeGame0.MainSence());
			//addChild(new Mode);
		}
	}
}