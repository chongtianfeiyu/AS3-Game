package test.TetrisMvc.Framework.object.vo
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import test.TetrisMvc.Framework.object.MapMgr;
	
	/**
	 * 格子数据
	 * @date	2013-8-27
	 * @author	luna
	 */
	public class BlockVO
	{
		public static const LENGTH:uint = 4;
		public static const TYPE:Vector.<String> = Vector.<String>(["L","B","Z","S","I","T","J"]);
		public static const L:Array = [[0, 0], [0, 1], [0, 2], [1, 2]];
		public static const B:Array = [[0, 0], [1, 0], [0, 1], [1, 1]];
		public static const Z:Array = [[0, 0], [1, 0], [1, 1], [2, 1]];
		public static const S:Array = [[1, 0], [2, 0], [0, 1], [1, 1]];
		public static const I:Array = [[0, 0], [0, 1], [0, 2], [0, 3]];
		public static const T:Array = [[1, 0], [0, 1], [1, 1], [2, 1]];
		public static const J:Array = [[1, 0], [1, 1], [0, 2], [1, 2]];
		
		public static const Lcolor:uint = 0x6699ff;
		public static const Bcolor:uint = 0xff0066;
		public static const Zcolor:uint = 0x33ff00;
		public static const Scolor:uint = 0xffff00;
		public static const Icolor:uint = 0xcc9933;
		public static const Tcolor:uint = 0xcc3366;
		public static const Jcolor:uint = 0x66ff33;
		
		
		public static function getNewMatrix(matrix:Array):Array
		{
			var newMatrix:Array = new Array(LENGTH);
			for(var i:int = 0;i<LENGTH;i++)
			{
				newMatrix[i] = matrix[i].concat();
			}
			return newMatrix;
		}
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		public var isInverted:Boolean = false;
		public var position:Point = new Point();
		public var type:String = "";
		private var _matrix:Array;//矩阵
		public var color:uint = 0xff0000;
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function BlockVO()
		{
		}
		
		public function clone():BlockVO
		{
			var blockVO:BlockVO = new BlockVO();
			blockVO.position = position.clone();
			blockVO.matrix = getNewMatrix(matrix);
			blockVO.isInverted = isInverted;
			return blockVO;
		}
		
		/**
		 * 旋转 
		 * 
		 */
		public function rotate():void
		{
			for(var i:int = 0;i<LENGTH;i++)
			{
				var pos:Point = new Point(matrix[i][0],matrix[i][1]);
				var mt:Matrix = new Matrix();
				
				//相同形状 回转
				if(isInverted && (type == "Z" || type == "S" || type == "I" ))
					mt.rotate(-90 * Math.PI / 180);
				else
					mt.rotate(90 * Math.PI / 180);
				pos = mt.transformPoint(pos);
				
				matrix[i][0] = Math.round(pos.x);
				matrix[i][1] = Math.round(pos.y);
			}	
			isInverted = !isInverted;
		}
		public function get top():int
		{
			var _up:int = MapMgr.TILE_MAP_HEIGHT;
			var _globalMatrix:Array = globalMatrix;
			for(var i:int = 0;i<LENGTH;i++)
			{
				var x:int = _globalMatrix[i][0]
				var y:int = _globalMatrix[i][1];
				if(y < _up)
					_up = y;
			}
			return _up;
		}
		public function get left():int
		{
			var _left:int = MapMgr.TILE_MAP_WIDTH;
			var _globalMatrix:Array = globalMatrix;
			for(var i:int = 0;i<LENGTH;i++)
			{
				var x:int = _globalMatrix[i][0]
				if(x < _left)
					_left = x;
			}
			return _left;
		}
		public function get right():uint
		{
			var _right:uint = 0;
			var _globalMatrix:Array = globalMatrix;
			for(var i:int = 0;i<LENGTH;i++)
			{
				var x:uint = _globalMatrix[i][0]
				if(x > _right)
					_right = x;
			}
			return _right;
		}
		public function get bottom():uint
		{
			var _bottom:uint = 0;
			var _globalMatrix:Array = globalMatrix;
			for(var i:int = 0;i<LENGTH;i++)
			{
				var x:uint = _globalMatrix[i][0]
				var y:uint = _globalMatrix[i][1];
				if(y > _bottom)
					_bottom = y;
			}
			return _bottom;
		}
		/*============================================================================*/
		/* Public Function                                                            */
		/*============================================================================*/
		public function get positionValue():uint
		{
			return uint(position.y / LENGTH) + uint(position.x % LENGTH);
		}
		public function get matrixValue():Array
		{
			var _matrix:Array = getNewMatrix(matrix);
			for(var i:int = 0;i<LENGTH;i++)
			{
				var x:uint = _matrix[i][0]
				var y:uint = _matrix[i][1];
				var value:uint = y * LENGTH + x; 
				_matrix[i] = value;
			}
			return _matrix;
		}
		
		/**
		 * 全局矩阵 
		 * @return 
		 * 
		 */
		public function get globalMatrix():Array
		{
			var _global:Array = getNewMatrix(matrix);
			for(var i:int = 0;i<4;i++)
			{
				_global[i][0] += position.x;
				_global[i][1] += position.y;
			}
			return _global;
		}
		public function get  globalMatrixValue():Array
		{
			var _matrix:Array = getNewMatrix(globalMatrix);
			for(var i:int = 0;i<LENGTH;i++)
			{
				var x:uint = _matrix[i][0]
				var y:uint = _matrix[i][1];
				var value:uint = y * MapMgr.TILE_MAP_WIDTH + x; 
				_matrix[i] = value;
			}
			return _matrix;
		}
		
		public function initMatirx(value:Array):void
		{
			_matrix = value;
			var maxX:uint = 0;
			var maxY:uint = 0;
			for(var i:int = 0;i<LENGTH;i++)
			{
				var x:uint = _matrix[i][0]
				var y:uint = _matrix[i][1];
				if(x > maxX)
					maxX = x;
				if(y > maxY)
					maxY = y;
			}
			
			for(i = 0;i<LENGTH;i++)
			{
				_matrix[i][0] -= Math.floor(maxX / 2);
				_matrix[i][1] -= Math.floor(maxY / 2);
			}
		}
		
		public function get matrix():Array
		{
			return _matrix;
		}
		
		public function set matrix(value:Array):void
		{
			_matrix = value;
		}
		
	}

}