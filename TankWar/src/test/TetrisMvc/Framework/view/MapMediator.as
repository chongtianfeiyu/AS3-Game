package test.TetrisMvc.Framework.view
{
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import test.TetrisMvc.Events.Notification;
	import test.TetrisMvc.Framework.object.MapMgr;
	import test.TetrisMvc.Framework.view.components.Map;
	
	public class MapMediator extends Mediator
	{
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		[Inject]
		public var model:MapMgr;
		[Inject]
		public var view:Map;
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function MapMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			addContextListener(Notification.START_GAME,onNotification);
			addContextListener(Notification.MODEL_UPDATED,onNotification);
			addContextListener(Notification.STOP_GAME,onNotification);
			addContextListener(Notification.CONTINUE_GAME,onNotification);
			
			eventMap.mapListener(view.timer,TimerEvent.TIMER,onTimer);
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_DOWN,onKeyDown);
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		private function onNotification(e:Notification):void
		{
			switch(e.type)
			{
				case Notification.START_GAME:
					view.refresh(model);
					view.timer.reset();
					view.startTimer();
					break;
				case Notification.MODEL_UPDATED:
					view.refresh(model);
					break;
				case Notification.STOP_GAME:
					view.stopTimer();
					break;
				case Notification.CONTINUE_GAME:
					view.startTimer();
					break;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			var keyCode:uint = e.keyCode;
			switch(keyCode)
			{
				default:
					dispatch(new Notification(Notification.KEY_DOWN,e.keyCode));
					break;
			}
		}
		private function onKeyUp(e:KeyboardEvent):void
		{
			var keyCode:uint = e.keyCode;
			switch(keyCode)
			{
			}
		}
		private function onTimer(e:TimerEvent):void
		{
			dispatch(new Notification(Notification.REFRESH_MODEL));
		}
		
		
		/*============================================================================*/
		/* Public Function                                                            */
		/*============================================================================*/
		
	}
}