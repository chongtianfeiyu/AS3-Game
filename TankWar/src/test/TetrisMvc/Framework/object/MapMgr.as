package test.TetrisMvc.Framework.object
{
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import test.TetrisMvc.Events.Notification;
	import test.TetrisMvc.Framework.object.vo.BlockVO;
	import test.TetrisMvc.Framework.object.vo.StoneVO;

	 /**
	 *@data 2014.08.13 
	 * @author 黄晖
	 *主逻辑,方块主区域管理器
	 */	
	public class MapMgr
	{
		/*============================================================================*/
		/* 成员                                                            */
		/*============================================================================*/
		public static const TILE_MAP_WIDTH:uint = 14;
		public static const TILE_MAP_HEIGHT:uint = 18;
		public static const TILE_HEIGHT:uint = 20;
		public static const TILE_WIDTH:uint = 20;
		
		public static function get TILE_MAP_LENGTH():uint
		{
			return TILE_MAP_WIDTH * TILE_MAP_HEIGHT;
		}
		public static function get MAP_HEIGHT():uint
		{
			return TILE_MAP_HEIGHT * TILE_HEIGHT;
		}
		public static function get MAP_WIDTH():uint
		{
			return TILE_MAP_WIDTH * TILE_WIDTH;
		}
		
		
		[Inject]
		public var dp:IEventDispatcher;
		public var isOver:Boolean = false;
		public var isStopping:Boolean = false;
		public var isStarted:Boolean = false;
		
		public var stones:Vector.<StoneVO>;//所有方块放定之后都变成stone
		public var selectedBlock:BlockVO;
		
		public var nextType:String = "";//下一个类型方块
		public var startTime:uint = 0;//开始的时间
		public var time:uint = 0;//时间
		public var score:uint = 0;//分数
		/*============================================================================*/
		/* 构造                                                                */
		/*============================================================================*/
		public function MapMgr()
		{
			
		}
		/*============================================================================*/
		/* 函数                                                                */
		/*============================================================================*/
		
		public function reset():void
		{
			startGame();
		}
		
		public function startGame():void
		{
			startTime = getTimer();
			time = 0;
			score = 0;
			isOver = false;
			isStopping = false;
			isStarted = true;
			stones = new Vector.<StoneVO>(TILE_MAP_LENGTH);//
			createBlock();
			//dp.dispatchEvent(new Notification(Notification.START_GAME));
		}
		
		public function createBlock():void
		{
			var type:String = "";
			if(nextType != "")
				type = nextType;
			else
			{
				var random:uint = uint(Math.random() * BlockVO.TYPE.length);
				type = BlockVO.TYPE[random];
			}
			random = uint(Math.random() * BlockVO.TYPE.length)
			nextType = BlockVO.TYPE[random];
			var matrix:Array = BlockVO[type];
			var color:uint = BlockVO[type + "color"];
			selectedBlock = new BlockVO();
			selectedBlock.color = color;
			selectedBlock.type = type;
			selectedBlock.initMatirx(BlockVO.getNewMatrix(matrix));
			selectedBlock.position.x = uint(TILE_MAP_WIDTH / 2);
			selectedBlock.position.y = -selectedBlock.top;
		}
		
		
		public function refresh():void
		{
			
			//检测石头
			var isHitStone:Boolean = false;
			var globalMatrix:Array = selectedBlock.globalMatrix;
			for(var i:int = 0;i<BlockVO.LENGTH;i++)
			{
				var x:uint = globalMatrix[i][0];
				var y:uint = globalMatrix[i][1] + 1;;//检测脚下石头
				if(y >= TILE_MAP_HEIGHT)
					continue;
				
				var value:uint = y *TILE_MAP_WIDTH + x; 
				if(stones[value] != null)
				{
					//检测是否已经结束
					if(selectedBlock.top <= 0)
					{
						isOver = true;
						dp.dispatchEvent(new Notification(Notification.GAME_OVER));
						return;
					}
					
					transformStone();
					createBlock();
					isHitStone = true;
					break;
				}
			}
			
			//检测最低
			var isHitBottom:Boolean = false;
			if(!isHitStone && selectedBlock.bottom == TILE_MAP_HEIGHT - 1)
			{
				transformStone();
				createBlock();
				isHitBottom = true;
			}
			if(!isHitBottom && !isHitStone)
			{
				selectedBlock.position.y ++;
			}
			//刷新时间
			time = (getTimer() - startTime) / 1000;
			dp.dispatchEvent(new Notification(Notification.MODEL_UPDATED));
		}
		
		private function transformStone():void
		{
			var globalMatrixValue:Array = selectedBlock.globalMatrixValue;
			//化成stone
			for(var i:int = 0;i<BlockVO.LENGTH;i++)
			{
				var globalValue:uint = globalMatrixValue[i];
				var stone:StoneVO = new StoneVO();
				stone.x = uint(globalValue % TILE_MAP_WIDTH);
				stone.y = uint(globalValue / TILE_MAP_WIDTH);
				stone.color = selectedBlock.color;
				stones[globalValue] = stone;
			}
			
			//检测下方消除
			var clearArr:Vector.<uint> = new Vector.<uint>();
			for(i = TILE_MAP_HEIGHT - 1;i>=0;i--)
			{
				var y:uint = i;
				var n:int = 0;
				var isFullLine:Boolean = true;//是否这一行已满 
				for(n;n<TILE_MAP_WIDTH;n++)
				{
					var x:uint = n;	
					var value:uint = y * TILE_MAP_WIDTH + x;
					stone = stones[value];
					if(stone == null)
					{
						isFullLine = false;
						break;
					}
				}
				if(isFullLine)
				{
					//必须从上往下下落
					clearArr.unshift(y);
				}
			}
			
			for each(var line:uint in clearArr)
			clearLine(line);
			
			//必须从上往下下落
			for each(line in clearArr)
			fallLine(line);
			
			var length:uint = clearArr.length;
			if(length > 0)
			{
				//计算分	
				score += 50 * length * (1 + 0.2 * (length - 1));
			}
		}
		
		/**
		 * 消除一行 
		 * 
		 */
		private function clearLine(y:uint):void
		{
			//clear
			for(var i:int = 0;i<TILE_MAP_WIDTH;i++)
			{
				var value:uint = y * TILE_MAP_WIDTH + i;
				stones[value] = null;
			}
		}
		
		/**
		 * 此行以上落下 
		 * 
		 */
		private function fallLine(y:uint):void
		{
			//上面的向下
			for(var i:int = y;i>=0;i--)
			{
				var x:int = 0
				for(x;x<TILE_MAP_WIDTH;x++)
				{
					var value:uint = i * TILE_MAP_WIDTH + x;
					var stone:StoneVO = stones[value];
					if(stone == null)
						continue;
					
					stones[stone.positionValue] = null;
					stone.y += 1;
					stones[stone.positionValue] = stone;
				}
			}
		}
		
		public function goLeft():void
		{
			if(selectedBlock.left == 0)
				return;
			
			var globalMatrix:Array = selectedBlock.globalMatrix;
			for(var i:int = 0;i<BlockVO.LENGTH;i++)
			{
				var x:int = globalMatrix[i][0] - 1;
				var y:uint = globalMatrix[i][1];
				
				var value:uint = y * TILE_MAP_WIDTH + x; 
				if(stones[value] != null)
				{
					return;
				}
			}
			
			selectedBlock.position.x --;
			dp.dispatchEvent(new Notification(Notification.MODEL_UPDATED));
		}
		public function goRight():void
		{
			if(selectedBlock.right == TILE_MAP_WIDTH - 1)
				return;
			
			var globalMatrix:Array = selectedBlock.globalMatrix;
			for(var i:int = 0;i<BlockVO.LENGTH;i++)
			{
				var x:uint = globalMatrix[i][0] + 1;
				var y:uint = globalMatrix[i][1];
				
				var value:uint = y * TILE_MAP_WIDTH + x; 
				if(stones[value] != null)
				{
					return;
				}
			}
			selectedBlock.position.x ++;
			dp.dispatchEvent(new Notification(Notification.MODEL_UPDATED));
		}
		
		public function rotate():void
		{
			if(selectedBlock.type == "B")
				return; 
			var cloneVO:BlockVO = selectedBlock.clone();
			cloneVO.rotate();
			var global:Array = cloneVO.globalMatrix;
			for(var i:int = 0;i<BlockVO.LENGTH;i++)
			{
				var x:uint = global[i][0];
				var y:uint = global[i][1];
				//检测边缘
				if(x < 0 || y < 0 || y >= TILE_MAP_HEIGHT || x >= TILE_MAP_WIDTH)
				{
					return;
				}
				
				//检测障碍
				var value:uint = y * TILE_MAP_WIDTH + x; 
				if(stones[value] != null)
				{
					return;
				}
			}
			
			selectedBlock.rotate();
			dp.dispatchEvent(new Notification(Notification.MODEL_UPDATED));
		}
		
		
	}
}