package test.TetrisMvc.control
{
	import flash.events.IEventDispatcher;
	import flash.ui.Keyboard;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	import test.TetrisMvc.Events.Notification;
	import test.TetrisMvc.Framework.object.MapMgr;
	
	public class MapCommand extends Command
	{
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		[Inject]
		public var event:Notification;
		[Inject]
		public var model:MapMgr;
		[Inject]
		public var dp:IEventDispatcher;
		
		public function MapCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			switch(event.type)
			{
				case Notification.KEY_DOWN:
					var keyCode:uint = event.data as uint;
					if(keyCode == Keyboard.SPACE)
					{
						if(model.isOver)
							return;
						
						if(!model.isStarted)
						{
							model.startGame();
						}
						else
						{
							model.isStopping = !model.isStopping;
							if(model.isStopping)
								dp.dispatchEvent(new Notification(Notification.STOP_GAME));
							else
								dp.dispatchEvent(new Notification(Notification.CONTINUE_GAME));
						}
					}
					else if(keyCode == "R".charCodeAt())
					{
						if(model.isStarted)
						{
							model.reset();
							dp.dispatchEvent(new Notification(Notification.MODEL_UPDATED));
						}
					}
					else if(keyCode == Keyboard.DOWN)
					{
						if(!model.isStarted || model.isStopping || model.isOver)
							return;
						
						model.refresh();
					}
					else if(keyCode == Keyboard.LEFT)
					{
						if(!model.isStarted || model.isStopping || model.isOver)
							return;
						
						model.goLeft();
					}
					else if(keyCode == Keyboard.RIGHT)
					{
						if(!model.isStarted || model.isStopping || model.isOver)
							return;
						
						model.goRight();
					}
					else if(keyCode == Keyboard.UP)
					{
						if(!model.isStarted || model.isStopping || model.isOver)
							return;
						//变形
						model.rotate();
					}
					break;
				case Notification.REFRESH_MODEL:
					model.refresh();
					break;
			}
		}
	}
}