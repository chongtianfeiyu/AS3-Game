package test.TetrisMvc
{
	import flash.display.Sprite;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.impl.Context;
	
	import test.TetrisMvc.Config.Config;
	import test.TetrisMvc.Framework.view.components.MainView;
	
	/**
	 *俄罗斯方块场景 
	 * @author 黄晖 2014.08.13
	 * 
	 */	
	public class TetrisSence extends Sprite
	{
		
		private var _context:Context;
		
		public function TetrisSence()
		{
			_context = new Context();
			_context.install(MVCSBundle);
			_context.configure(Config,new ContextView(this));
			_context.initialize();
			super();
			
			//mainView
			addChild(new MainView());
		}
	}
}