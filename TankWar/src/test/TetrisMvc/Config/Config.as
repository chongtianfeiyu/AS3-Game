package test.TetrisMvc.Config
{
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	import test.TetrisMvc.Events.Notification;
	import test.TetrisMvc.control.MapCommand;
	import test.TetrisMvc.Framework.object.MapMgr;
	import test.TetrisMvc.Framework.view.MainMediator;
	import test.TetrisMvc.Framework.view.MapMediator;
	import test.TetrisMvc.Framework.view.components.MainView;
	import test.TetrisMvc.Framework.view.components.Map;

	public class Config implements IConfig
	{
		
		/*============================================================================*/
		/* 成员                                                            */
		/*============================================================================*/
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var commandMap:IEventCommandMap;
		
		[Inject]
		public var viewProcessorMap:IViewProcessorMap;
		
		[Inject]
		public var contextView:ContextView;
		
		/*============================================================================*/
		/* 构造函数                                                                */
		/*============================================================================*/
		public function Config()
		{
		}
		
		public function configure():void
		{
			//model
			injector.map(MapMgr).asSingleton();
			//view
			mediatorMap.map(Map).toMediator(MapMediator);
			mediatorMap.map(MainView).toMediator(MainMediator);
			
			//command
			commandMap.map(Notification.KEY_DOWN).toCommand(MapCommand);
			commandMap.map(Notification.REFRESH_MODEL).toCommand(MapCommand);
			
			//mainView
			//contextView.view.addChild(new MainView());
		}
		
	}
}