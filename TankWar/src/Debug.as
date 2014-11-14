package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Core.Sence.TankSence;
	
	import test.AvatarProject.bmpMgr;
	import test.BackGroundDragProject.BackGroundSence;
	import test.FireworksProject.FireWorksSence;
	import test.HpLostProject.LostLifeEffects;
	import test.PathAlgorithmProject.AAPathTest;
	import test.TetrisMvc.TetrisSence;
	import test.hitTestProject.testSence;
	
	[SWF(backgroundColor = "#FFFFFF",frameRate="60",height=900,width=1200)]
	public class Debug extends Sprite
	{
		
		public function Debug()
		{
			addEventListener(Event.ADDED_TO_STAGE, onInt); 
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		
		protected function onInt(event:Event):void
		{
			//1.缓动测试
			//tweenTest();
			
			//2.bmp形象
			//bmpAvatarTest()
			
			//3.碰撞测试
			//hitTest();
			
			//4.坦克游戏
			//tankGame()
			
			//5.烟花效果DEMO
			//fireWorksTest();
			
			//6.视角移动
			//camareTest();
			
			//A*寻路
			//aaPathTest();
			
			//俄罗斯方块游戏
			terisGame();
		}		
		
		/**缓动DEOM */		
		private function tweenTest():void{
			addChild(new LostLifeEffects());
		}
		
		/**bmp形象动作DEOM */			
		private function bmpAvatarTest():void{
			var bMgr:bmpMgr = new  bmpMgr(stage);
			addChild(bMgr);
			bMgr.doMove(4);
		}
		
		/**高级基础碰撞DEMO */		
		private function hitTest():void{
			addChild(new testSence(stage));
		}
		
		/**坦克游戏DEMO*/			
		private function tankGame():void{
			var tsMgr:TankSence=new TankSence(stage);
			//创建地图
			tsMgr.SetupBattleFiled();
			addChild(tsMgr);
		}
		
		/**
		 *烟花效果DEMO 
		 * 2014.08.04
		 */		
		private function fireWorksTest():void{
			addChild(new FireWorksSence(stage));
		}
		
		/**
		 *视角移动DEMO 
		 * 2014.8.5
		 */		
		private function camareTest():void{
		 addChild(new BackGroundSence(stage));
		}
		
		private function aaPathTest():void{
			addChild(new AAPathTest(stage));
		}
		
		private function terisGame():void{
			addChild(new TetrisSence());
		}
	}
}