package test.TetrisMvc.Framework.view.components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Timer;
	
	import test.TetrisMvc.Framework.object.MapMgr;
	import test.TetrisMvc.Framework.object.vo.BlockVO;
	import test.TetrisMvc.Framework.object.vo.StoneVO;
	
	public class Map extends Sprite
	{
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		private var blockArray:Vector.<Shape> = new Vector.<Shape>(MapMgr.TILE_MAP_LENGTH);//所有格子
		private var grid:Shape = new Shape;
		public var timer:Timer = new Timer(1000);
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function Map()
		{
			//draw block
			for(var i:int = 0;i<MapMgr.TILE_MAP_LENGTH;i++)
			{
				var block:Shape = new Shape();
				block.x = uint(i % MapMgr.TILE_MAP_WIDTH) * MapMgr.TILE_WIDTH;
				block.y = uint(i / MapMgr.TILE_MAP_WIDTH) * MapMgr.TILE_HEIGHT;
				blockArray[i] = block;
				addChild(block);
			}
			//draw line
			grid.graphics.lineStyle(1);
			addChild(grid); 
			for(i = 0;i<MapMgr.TILE_MAP_WIDTH + 1;i++)
			{
				var x:Number = i * MapMgr.TILE_WIDTH;
				grid.graphics.moveTo(x,0);
				grid.graphics.lineTo(x,MapMgr.MAP_HEIGHT);
			}
			
			for(i = 0;i<MapMgr.TILE_MAP_HEIGHT + 1;i++)
			{
				var y:Number = i * MapMgr.TILE_HEIGHT;
				grid.graphics.moveTo(0,y);
				grid.graphics.lineTo(MapMgr.MAP_WIDTH,y);
			}
		}
		
		public function refresh(model:MapMgr):void
		{
			for each(block in blockArray)
			block.graphics.clear();
			
			//渲染方块
			var globalMatrixValue:Array = model.selectedBlock.globalMatrixValue;
			for(i = 0;i<BlockVO.LENGTH;i++)
			{
				var position:uint = globalMatrixValue[i];
				if(position>=blockArray.length)continue;
				var block:Shape = blockArray[position];
				block.graphics.beginFill(model.selectedBlock.color,1);
				block.graphics.drawRect(0,0,MapMgr.TILE_WIDTH,MapMgr.TILE_HEIGHT);
				block.graphics.endFill();
			}
			
			//渲染石头
			var stones:Vector.<StoneVO> = model.stones;
			for(var i:int = 0;i<MapMgr.TILE_MAP_LENGTH;i++)
			{
				var stone:StoneVO = stones[i];
				if(stone != null)
				{
					block = blockArray[i];
					block.graphics.beginFill(stone.color,1);
					block.graphics.drawRect(0,0,MapMgr.TILE_WIDTH,MapMgr.TILE_HEIGHT);
					block.graphics.endFill();
				}
			}
		}
		
		public function startTimer():void
		{
			timer.start();
		}
		public function stopTimer():void
		{
			timer.stop();
		}
		/*============================================================================*/
		/* Public Function                                                            */
		/*============================================================================*/
		
	}
}