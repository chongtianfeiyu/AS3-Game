package test.hitTestProject
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 *测试场景 
	 * @author XN-HuangH
	 * 
	 */	
	public class testSence extends Sprite
	{
		private var _balls:Vector.<HitBmpCase>;
		private var _grid:Vector.<Vector.<Vector.<HitBmpCase>>>;
		private var _numBalls:int=100;
		private const RADIUS:Number=15;//小球的半径
		private var __stage:Stage;
		private var GRID_SIZE:int=30;
		private var _numChecks:int;
		private var _txt:TextField;
		private var _fpsCount:int;
		private var minDist:Number=100;
		private var springAmount:Number=.001;
		
		public function testSence(_stage:Stage)
		{
			__stage=_stage;
			super();
			reDrewGrid();
			reDrawBalls();
			
			makeGrid();
			
			//计算fps
			_txt=new TextField();//创建文本实例
			_txt.textColor=0xff0000;//设置文本颜色
			addChild(_txt)//加载这个文本
			var myTimer:Timer = new Timer(1000);//Timer类挺好使，类似于setInterval,参数是循环间隔时间，单位是毫秒
			myTimer.addEventListener("timer", timerHandler);//注册事件
			myTimer.start();//Timer实例需要start来进行启动
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			//Timer实例调用的方法
			_txt.text="FPS:"+_fpsCount;
			_fpsCount=0;//每隔1秒进行清零
		}
		
		protected function onEnterFrame(e:Event):void
		{
			_fpsCount++;
			updateBalls();
			assignBallsToGrid();
			checkGrid();
		}
		
		//让小球动起来
		private function updateBalls():void {
			for (var i:int = 0; i < _numBalls; i++) {
				
				if(!_balls[i])continue;
				
				var ball:HitBmpCase=_balls[i] as HitBmpCase;
				ball.update();
				if (ball.x<RADIUS) {
					ball.x=RADIUS;
					ball.vx*=-1.05;
				} else if (ball.x > __stage.stageWidth - RADIUS) {
					ball.x=__stage.stageWidth-RADIUS;
					ball.vx*=-1.05;
				}
				if (ball.y<RADIUS) {
					ball.y=RADIUS;
					ball.vy*=-1.05;
				} else if (ball.y > __stage.stageHeight - RADIUS) {
					ball.y=__stage.stageHeight-RADIUS;
					ball.vy*=-1.05;
				}
				ball.color=0xffffff;
			}
			
			makeGrid();
		}
		
		/**碰撞的小球 */		
		public function reDrawBalls():void{
			_balls=new  Vector.<HitBmpCase>();
			for (var i:int=0; i<_numBalls; i++) {
				var ball:HitBmpCase=new HitBmpCase(RADIUS);
				ball.x=Math.random()*__stage.stageWidth;
				ball.y=Math.random()*__stage.stageHeight;
				ball.vx=Math.random()*4-2;
				ball.vy=Math.random()*4-2;
				addChild(ball);
				_balls.push(ball);
			}
		}
		
		/**绘制网格  */		
		public function reDrewGrid():void{
			// 画出行列线
			
			graphics.lineStyle(0,0xFFFFFF,0.5);
			
			var i:int=0;
			//先画列
			for ( i=0; i<=__stage.stageWidth; i+=GRID_SIZE) {
				graphics.moveTo(i,0);
				graphics.lineTo(i,__stage.stageHeight);
			}
			
			//再画行
			for ( i=0; i<=__stage.stageHeight; i+=GRID_SIZE) {
				graphics.moveTo(0,i);
				graphics.lineTo(__stage.stageWidth,i);
			}
			
			graphics.endFill();
		}
		
		/**创建逻辑格子管理器*/		
		private function makeGrid():void {
			
			//if(_grid)return;
			
			_grid=new Vector.<Vector.<Vector.<HitBmpCase>>>();
			
			for (var i:int=0; i<__stage.stageWidth/GRID_SIZE; i++) {//计算网格列数
				_grid[i]= new Vector.<Vector.<HitBmpCase>>();
				
				for (var j:int=0; j<__stage.stageHeight/GRID_SIZE; j++) {//计算网格行数
					_grid[i][j]=new  Vector.<HitBmpCase>() ;//每个单元格对应一个数组（用来存放该单元格中的小球）
				}
			}
		}
		
		private function assignBallsToGrid():void {
			for (var i:int=0; i<_numBalls; i++) {
				if(!_balls[i])continue;
				// 球的位置除以格子大小，得到该球所在网格的行列数
				var ball:HitBmpCase=_balls[i] as HitBmpCase;
				var xpos:int=Math.floor(ball.x/GRID_SIZE);//逻辑格子x
				var ypos:int=Math.floor(ball.y/GRID_SIZE);//逻辑格子y
				_grid[xpos][ypos].push(ball);//将小球推入对应单元格数组
				
//				if(ball.preLogicCell){
//					if(ball.preLogicCell[0]!=xpos&&ball.preLogicCell[1]!=ypos){
//						_grid[ball.preLogicCell[0]][ball.preLogicCell[1]].splice(_grid[xpos][ypos].indexOf(ball),1);
//						_grid[xpos][ypos].push(ball);//将小球推入对应单元格数组
//					}
//				}else{
//					ball.preLogicCell=[xpos,ypos];
//					_grid[xpos][ypos].push(ball);//将小球推入对应单元格数组
//				}
			}
		}
		
		private function checkGrid():void {
			for (var i:int=0; i<_grid.length; i++) {
				for (var j:int=0; j<_grid[i].length; j++) {
					
					checkOneCell(i,j);//单元格cell_self自身的碰撞检测
					checkTwoCells(i,j,i+1,j);//单元格cell_self与单元格cell_right(右侧)的碰撞检测
					checkTwoCells(i,j,i-1,j+1);//单元格cell_self与单元格cell_left_bottom(左下角)的碰撞检测
					checkTwoCells(i,j,i,j+1);//单元格cell_self与单元格cell_bottom(下侧)的碰撞检测
					checkTwoCells(i,j,i+1,j+1);//单元格cell_self与单元格cell_right_bottom(右下角)的碰撞检测
				}
			}
		}
		
		private function checkOneCell(x:int,y:int):void
		{
			// 检测当前格子内所有的对象
			var cell:Vector.<HitBmpCase>=_grid[x][y] as Vector.<HitBmpCase>;
			for (var i:int=0; i<cell.length-1; i++) {
				var ballA:HitBmpCase=cell[i] as HitBmpCase;
				for (var j:int=i+1; j<cell.length; j++) {
					var ballB:HitBmpCase=cell[j] as HitBmpCase;
					checkCollision(ballA,ballB);
				}
			}
		}
		
		private function checkTwoCells(x1:int,y1:int,x2:int,y2:int):void
		{
			//确保要检测的格子存在
			if (x2<0) {
				return;
			}
			if (x2>=_grid.length) {
				return;
			}
			if (y2>=_grid[x2].length) {
				return;
			}
			var cell0: Vector.<HitBmpCase>=_grid[x1][y1] as Vector.<HitBmpCase>;
			var cell1: Vector.<HitBmpCase>=_grid[x2][y2] as Vector.<HitBmpCase>;
			
			// 检测当前格子和邻接格子内所有的对象
			for (var i:int=0; i<cell0.length; i++) {
				var ballA:HitBmpCase=cell0[i] as HitBmpCase;
				for (var j:int=0; j<cell1.length; j++) {
					var ballB:HitBmpCase=cell1[j] as HitBmpCase;
					checkCollision(ballA,ballB);
				}
			}
			
		}
		
		private function checkCollision(ballA:HitBmpCase, ballB:HitBmpCase):void
		{
			// 判断距离的碰撞检测
			_numChecks++;//计数器累加
			var dx:Number=ballB.x-ballA.x;
			var dy:Number=ballB.y-ballA.y;
			var dist:Number=Math.sqrt(dx*dx+dy*dy);
			if (dist<ballA.radius+ballB.radius) {
				//碰撞的小球变红色
				ballA.color=0xff0000;
				ballB.color=0xff0000;
				
				if(_balls.indexOf(ballA)!=-1)
					_balls[_balls.indexOf(ballA)]=null;
				
				if(_balls.indexOf(ballB)!=-1)
					_balls[_balls.indexOf(ballB)]=null;
				
			}
			
			//spring(ballA,ballB);
		}
		
		//绘制两个物体的连接线
		private function spring(partA:HitBmpCase, partB:HitBmpCase):void {
			var dx:Number=partB.x-partA.x;
			var dy:Number=partB.y-partA.y;
			var dist:Number=Math.sqrt(dx*dx+dy*dy);
			if (dist<minDist) {
				
				graphics.lineStyle(1, 0x00ff00, 1 - dist / minDist);
				graphics.moveTo(partA.x+RADIUS, partA.y+RADIUS);
				graphics.lineTo(partB.x+RADIUS, partB.y+RADIUS);
			}
		}
		
		
	}
}