package test.TetrisMvc.Framework.view
{
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import test.TetrisMvc.Events.Notification;
	import test.TetrisMvc.Framework.object.MapMgr;
	import test.TetrisMvc.Framework.view.components.MainView;
	
	public class MainMediator extends Mediator
	{
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		[Inject]
		public var model:MapMgr;
		[Inject]
		public var view:MainView;
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function MainMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			addContextListener(Notification.START_GAME,onNotification);
			addContextListener(Notification.MODEL_UPDATED,onNotification);
			addContextListener(Notification.GAME_OVER,onNotification);
			addContextListener(Notification.STOP_GAME,onNotification);
			addContextListener(Notification.CONTINUE_GAME,onNotification);
		}
		private function onNotification(e:Notification):void
		{
			switch(e.type)
			{
				case Notification.START_GAME:
					view.tip.htmlText = MainView.HELP_PLAY + "\n\n时间：" + model.time + "秒\n分数：" + model.score + "\n下一个图形：";
					view.setBlock(model.nextType);
					view.showBlock();
					break;
				case Notification.MODEL_UPDATED:
					view.tip.htmlText = MainView.HELP_PLAY + "\n\n时间：" + model.time + "秒\n分数：" + model.score + "\n下一个图形：";
					view.setBlock(model.nextType);
					break;
				case Notification.GAME_OVER:
					view.tip.htmlText = "游戏结束\n按R：重启游戏" + "\n\n时间：" + model.time + "秒\n分数：" + model.score;
					view.hideBlock();
					break;
				case Notification.STOP_GAME:
					view.tip.htmlText = "暂停中。。。\n按空格继续游戏";
					view.hideBlock();
					break;
				case Notification.CONTINUE_GAME:
					view.tip.htmlText = MainView.HELP_PLAY + "\n\n时间：" + model.time + "秒\n分数：" + model.score + "\n下一个图形：";
					view.showBlock();
					break;
			}
		}
		
		/*============================================================================*/
		/* Public Function                                                            */
		/*============================================================================*/
		
	}
}