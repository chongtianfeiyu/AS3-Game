package test.PathAlgorithmProject
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	
	/**
	 *A*路径算法 
	 * @author 黄晖
	 * 2014.08.11
	 * 知识点：
	 * 1.二叉树排序，冒泡，下滤
	 * 2.A*算法 开放列表，关闭列表，权值消耗  F=G(路径消耗,起点至当前点的消耗)+H(预估消耗，至目标点的距离)
	 * 3.路径回溯
	 */	
	public class AAPathTest extends Sprite
	{
		private var CELL_WIDTH:int=20;
		private var CELL_HEIGHT:int=20;
		
		private var PATH_COST30:int=5;
		private var PATH_COST45:int=7;
		
		private var grids:Array;
		private var points:Array;
		
		private var _stage:Stage;
		
		private var openGrids:Vector.<Object>;
		private var closeGrids:Vector.<Object>;
		
		public function AAPathTest(__stage:Stage)
		{
			_stage=__stage;
			_stage.scaleMode =StageScaleMode.NO_SCALE;
			
			addEventListener(MouseEvent.RIGHT_CLICK,onMouseRightClick);
			addEventListener(MouseEvent.MIDDLE_CLICK,onMouseDoubleClick);
			addEventListener(MouseEvent.CLICK,onMouseClick);
			
			resetView();
			
			super();
		}
		
		protected function onMouseDoubleClick(event:MouseEvent):void
		{
			resetView();
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var grid:Object = findGrid(new Point(mouseX,mouseY));
			if(points.length<2){
				if(grid.isFill)return;
				
				graphics.beginFill(points.length==0?0x22AF18:0xFFE49C);
				graphics.drawRect(grid.x,grid.y,CELL_WIDTH,CELL_HEIGHT);
				graphics.endFill();
				grid.isFill=true;
				points.push(grid);
				
			}
			else{
				//计算寻路
				mallco();
			}
		}
		
		protected function malloc():void{
			var startGrid:Object =points[0];
			var targetGrid:Object =points[1];
			
		}
		
		protected function onMouseRightClick(event:MouseEvent):void
		{
			var grid:Object = findGrid(new Point(mouseX,mouseY));
			if(!grid.isFill){
				graphics.beginFill(0xBB1212);
				graphics.drawRect(grid.x,grid.y,CELL_WIDTH,CELL_HEIGHT);
				graphics.endFill()
				grid.isFill=true;
				grid.isClose=true;
				closeGrids.push(grid);
			}
		}
		
		private function resetView():void{
			
			while(numChildren){
			removeChildAt(0);
			}
			
			closeGrids=new Vector.<Object>();
			openGrids=new Vector.<Object>();
			
			points=new Array();
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
			
			var rows:int = _stage.stageHeight/CELL_HEIGHT;
			var cols:int= _stage.stageWidth/CELL_WIDTH;
			
			intGrids();
			
			graphics.lineStyle(1,0x5A5A5A);
			
			for (var i:int = 0; i < rows; i++) 
			{
				graphics.moveTo(0,i*CELL_HEIGHT);
				graphics.lineTo( _stage.stageWidth,i*CELL_HEIGHT);
			}
			
			for (var j:int = 0; j < cols; j++) 
			{
				graphics.moveTo(j*CELL_WIDTH,0);
				graphics.lineTo(j*CELL_WIDTH,_stage.stageHeight);
			}
			
			graphics.endFill();
		}
		
		private function intGrids():void{
			var rows:int = _stage.stageHeight/CELL_HEIGHT;
			var cols:int= _stage.stageWidth/CELL_WIDTH;
			
			grids=new Array();
			var idx:int=1;
			
			for (var i:int = 0; i < rows; i++) 
			{
				grids[i]=new Array();
				
				for (var j:int = 0; j < cols; j++) 
				{
					grids[i][j]={
						row:i,col:j,
						y:CELL_WIDTH*i,
						x:CELL_HEIGHT*j,
						isFill:false,
						id:idx,
						isClose:false
					};
					
					if(Math.random()>0.8){
						graphics.beginFill(0xBB1212);
						graphics.drawRect(grids[i][j].x,grids[i][j].y,CELL_WIDTH,CELL_HEIGHT);
						graphics.endFill()
						grids[i][j].isFill =true;
						grids[i][j].isClose=true;
						closeGrids.push(grids[i][j]); //加入封闭列表
					}
					
					idx++;
				}
			}
		}
		
		private function findGrid(point:Point):Object{
			var rowIdx:int = point.y/CELL_HEIGHT;
			var cellIdx:int = point.x/CELL_WIDTH;
			
			rowIdx =rowIdx>=grids.length?grids.length-1:rowIdx;
			cellIdx=cellIdx>= grids[rowIdx].length? grids[rowIdx].length-1:cellIdx;
			
			return grids[rowIdx][cellIdx];
		}
		
		private var nextGrid:Object;
		private var _isStart:Boolean;
		private var childGrid:Object;
		/**执行A*算法  */		
		private function mallco():void{
			nextGrid =points[0];
			nextGrid.G=0;
			nextGrid.isClose=true;
			setQz(nextGrid);
			closeGrids.push(nextGrid);
			var step:int=0;
			
			var _isEnd:Boolean =false;
			
			var nowTime:int= getTimer();
			_stage.addEventListener(Event.ENTER_FRAME,function():void{
			
				if(getTimer()-nowTime>10){
					nowTime= getTimer();
					
					if(_isEnd){
						return;
					}
					
					if(!filterOpenGrid()){
						_isEnd=true;
					   //绘制回溯路径
						//回溯路径
						childGrid=points[1];
						while(true){
							graphics.beginFill(0xCCCCCC);
							graphics.drawCircle(childGrid.x+CELL_WIDTH/2,childGrid.y+CELL_HEIGHT/2,5);
							graphics.endFill();
							if(!filterPath())
								break;
						}
					}
				
					if(nextGrid){
						if(!nextGrid.isClose===true){
							nextGrid.isClose=true;
							closeGrids.push(nextGrid);
						}
						
						if(nextGrid){
							var tf:TextField=new TextField();
//							tf.text =String(++step)+","+nextGrid.F;
//							tf.x= nextGrid.x;
//							tf.y=nextGrid.y+CELL_HEIGHT/2;
//							addChild(tf);
						}
					}
				}			
			});
		
		}
		
		private function filterPath():Boolean{
		
			if(!childGrid.par)
				return false;
			
			var hasPar:Boolean=false;
			for each (var grid:Object in closeGrids) 
			{
				if(grid.id==childGrid.par.id){
				   childGrid= grid;
				   hasPar=true;
				   break;
				}
			}
			
			if(!hasPar)
				childGrid=null;
			
			return hasPar;
		}
		
		private function filterOpenGrid():Boolean{
			var rows:int = _stage.stageHeight/CELL_HEIGHT-1;
			var cols:int= _stage.stageWidth/CELL_WIDTH-1;
			
			//direct,G,F,P
			//要移动前，先计算要移动的点8个方向格子放入开发列表中,顺时针
			for (var i:int = 1; i < 9; i++) 
			{
				var grid:Object;
				var nexRow:int;var newCol:int;
				var cost:int;
				
				//				grids[i][j]={
				//					row:i,col:j,
				//					y:CELL_WIDTH*i,
				//						x:CELL_HEIGHT*j,
				//						isFill:false
				//				};
				
				switch(i)
				{
					case 1: //上
						if(nextGrid.row>0){
							grid=grids[nextGrid.row-1][nextGrid.col];
							cost=PATH_COST30;
						}
						break;
					case 2: //右上
						if(nextGrid.row>0&&nextGrid.col<cols){
							
							if(grids[nextGrid.row-1][nextGrid.col].isClose===true&&grids[nextGrid.row][nextGrid.col+1].isClose===true)
								break;
							
								grid=grids[nextGrid.row-1][nextGrid.col+1];
								cost=PATH_COST45;
					
						}
						break;
					case 3: //右
						if(nextGrid.col<cols){
							grid=grids[nextGrid.row][nextGrid.col+1];
					    	cost=PATH_COST30;
						}
						break;
					case 4: //右下
						if(nextGrid.row<rows&&nextGrid.col<cols)
						{
							if(grids[nextGrid.row+1][nextGrid.col].isClose===true&&grids[nextGrid.row][nextGrid.col+1].isClose===true)
								break;
							
								grid=grids[nextGrid.row+1][nextGrid.col+1];
								cost=PATH_COST45;

						}
						break;
					case 5: //下
						if(nextGrid.row<rows){
							grid=grids[nextGrid.row+1][nextGrid.col];
							cost=PATH_COST30;
						}
						break;
					case 6: //左下
						if(nextGrid.row<rows&&nextGrid.col>0){
							if(grids[nextGrid.row+1][nextGrid.col].isClose===true&&grids[nextGrid.row][nextGrid.col-1].isClose===true)
								break;
							
							grid=grids[nextGrid.row+1][nextGrid.col-1];
							cost=PATH_COST45;
						}
						break;
					case 7: //左
						if(nextGrid.col>0){
							grid=grids[nextGrid.row][nextGrid.col-1];
							cost=PATH_COST30;
						}
						break;
					case 8: //左上
						if(nextGrid.row>0&&nextGrid.col>0){
							if(grids[nextGrid.row-1][nextGrid.col].isClose===true&&grids[nextGrid.row][nextGrid.col-1].isClose===true)
								break;
							grid=grids[nextGrid.row-1][nextGrid.col-1];
							cost=PATH_COST45;
					
						}
						break;
				}
				
				if(grid){
					//忽略已封闭的格子
					if(checkCloseGrids(grid.id))
						continue;
					
					if(!grid.isFill){
						//为开发的格子标记颜色#0099CC
						graphics.beginFill(0x0099CC);
						graphics.drawRect(grid.x,grid.y,CELL_WIDTH,CELL_HEIGHT);
						graphics.endFill()
						grid.isFill =true;
					}
					
					grid.par =nextGrid;
					grid.G=nextGrid.G+cost;
					setQz(grid);
					
					var grid1:Object = findOpenGrid(grid.id);
					if(!grid1){
						pushToOpenGrid(grid);
					}else{
						if(grid.F<grid.F){
							pushToOpenGrid(grid);
						
						}
					}
				}
			}
			
			if(openGrids.length==0){
			  return false;
			}
			
	       if(findOpenGrid(points[1].id)){
			   return false;
		   }
		   
		   nextGrid =findMinOpenGrid();
		   if(!nextGrid)
			   return false;
			
		   return true;
		}
		
		
		private function pushToOpenGrid(grid:Object):void{
			//1.加入
			openGrids.push(grid)
			//2.二叉树堆排序，将最小值冒泡
			
			//2.1 获取最新加入项的位置
		   var curIdx:int =openGrids.length-1;
	
		   //2.2 判断是否有父亲节点
		   treeBubbleSort(curIdx);
		}
		
		/***二叉树冒泡 */		
		private function treeBubbleSort(nextIdx:int):void{
			if(nextIdx==0)return;
			
			var parentIdx:int = (nextIdx/2==int(nextIdx/2))?(int(nextIdx/2)-1):int(nextIdx/2);
			//临时，对比后交换使用
			var temp:Object=openGrids[nextIdx];
			if(openGrids[nextIdx].F<openGrids[parentIdx].F){
				openGrids[nextIdx]=openGrids[parentIdx];
				openGrids[parentIdx]=temp;
			}
			
			treeBubbleSort(parentIdx);
		}
		
		/**二叉树下滤*/		
		private function treeDivingSort(parentIdx:int):void{
			if(parentIdx>openGrids.length-1)return;
			
			var leftChildIdx:int = parentIdx*2+1;
			var rightChildIdx:int = leftChildIdx+1;
			
			var compareIdx:int=0;
			if(leftChildIdx>openGrids.length-1)return;
			
			//右边子项不存在时
			if(rightChildIdx>openGrids.length-1){
				compareIdx=leftChildIdx;
			}else{
				compareIdx=(openGrids[leftChildIdx].F<=openGrids[rightChildIdx].F)?leftChildIdx:rightChildIdx;
			}
			
			if(compareIdx==0)return;
			
			if(openGrids[parentIdx].F<openGrids[compareIdx].F)return;
			
			//临时，对比后交换使用
			var temp:Object=openGrids[compareIdx];
		
				openGrids[compareIdx]=openGrids[parentIdx];
				openGrids[parentIdx]=temp;
				parentIdx=compareIdx;

			
			treeDivingSort(parentIdx);
		} 
		
		private function findMinOpenGrid():Object{
			
			if(openGrids.length==0)
				return null;
			
			var minObj:Object =openGrids[0];
			openGrids[0]= openGrids[openGrids.length-1];
			openGrids.pop();
			
			//二叉树下滤
			treeDivingSort(0);
			
			return minObj;
		}
		
		private function checkCloseGrids(gridId:int):Boolean{
			for each (var grid:Object in closeGrids) 
			{
				if(grid.id ==gridId)
					return  true;
			}
		    return false;
		}
		
		private function findOpenGrid(gridId:int):Object{
		
			for each (var grid:Object in openGrids) 
			{
				if(grid.id ==gridId)
					return  grid;
			}
			
			return null;
		}
		
		//计算格子消耗权值
		private function setQz(grid:Object):void{
			var tarGrid:Object = points[1];
			if(grid.y-tarGrid.y!=0){
				//grid.H=Math.abs(int(Math.sqrt(Math.pow(grid.x-tarGrid.x,2)+Math.pow(grid.y-tarGrid.y,2))));
				
				grid.H=Math.abs(grid.x-tarGrid.x)+Math.abs(grid.y-tarGrid.y);
			}
			else{
				grid.H=Math.abs(grid.x-tarGrid.x);
			}
			
			//grid.H=Math.abs(grid.x-tarGrid.x)+Math.abs(grid.y-tarGrid.y);
			
			grid.F=grid.G+grid.H;
		}
		
	}
}