package test.TetrisMvc.Framework.view.components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import test.TetrisMvc.Framework.object.MapMgr;
	import test.TetrisMvc.Framework.object.vo.BlockVO;
	
	public class MainView extends Sprite
	{
		public static const HELP_PLAY:String = "操作方式：\n↑：旋转\n←→：左右移动\n↓：加速下落\n空格：暂停/继续\nR：重启游戏";
		public static const HELP_START:String = "Author:	luna\nDate:		2013-8-29\n按下空格开始游戏";
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		private var map:Map;//
		public var tip:TextField;
		
		//展示
		private var lineGrad:Shape = new Shape();
		private var blockArray:Vector.<Shape> = new Vector.<Shape>(BlockVO.LENGTH * BlockVO.LENGTH);
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function MainView()
		{
			map = new Map();
			addChild(map);
			
			var format:TextFormat = new TextFormat("宋体",12,0,true);
			tip = new TextField();
			tip.defaultTextFormat = format;
			tip.selectable = false;
			tip.width = 400;
			tip.height = 400;
			tip.x = map.width;
			tip.y = 0;
			tip.text = HELP_START;
			addChild(tip);
			
			
			
			
			lineGrad.graphics.lineStyle(1);
			lineGrad.x = map.width + 10;
			lineGrad.y = 165;
			
			
			var length:uint = BlockVO.LENGTH ;
			for(var i:int = 0;i<=length;i++)
			{
				var x:Number = i * MapMgr.TILE_WIDTH;
				lineGrad.graphics.moveTo(x,0);
				lineGrad.graphics.lineTo(x,length * MapMgr.TILE_HEIGHT);
			}
			for(i = 0;i<=length;i++)
			{
				var y:Number = i * MapMgr.TILE_HEIGHT;
				lineGrad.graphics.moveTo(0,y);
				lineGrad.graphics.lineTo(length * MapMgr.TILE_WIDTH,y);
			}
			
			length = BlockVO.LENGTH * BlockVO.LENGTH;
			for(i = 0;i<length;i++)
			{
				var block:Shape = new Shape();
				block.x = lineGrad.x + uint(i % BlockVO.LENGTH) * MapMgr.TILE_WIDTH;
				block.y = lineGrad.y + uint(i / BlockVO.LENGTH) * MapMgr.TILE_HEIGHT;
				blockArray[i] = block;
				addChild(block);
			}
			//addChild(lineGrad);
		}
		
		/*============================================================================*/
		/* Public Function                                                            */
		/*============================================================================*/
		public function showBlock():void
		{
			lineGrad.visible = true;
			for each(var block:Shape in blockArray)
			block.visible = true;
		}
		public function hideBlock():void
		{
			lineGrad.visible = false;
			for each(var block:Shape in blockArray)
			block.visible = false;
		}
		
		public function setBlock(type:String):void
		{
			for each(var block:Shape in blockArray)
			block.graphics.clear();
			
			var matrix:Array = BlockVO[type];
			var color:uint = BlockVO[type + "color"];
			for(var i:int = 0;i<BlockVO.LENGTH;i++)
			{
				var x:int = matrix[i][0];
				var y:uint = matrix[i][1];
				var value:uint = y * BlockVO.LENGTH + x; 
				
				block = blockArray[value];
				block.graphics.beginFill(color,1);
				block.graphics.drawRect(0,0,MapMgr.TILE_WIDTH,MapMgr.TILE_HEIGHT);
				block.graphics.endFill();
			}
		}
	}
}