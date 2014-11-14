package test.TetrisMvc.Framework.object.vo
{
	import test.TetrisMvc.Framework.object.MapMgr;

	/**
	 * @date	2013-8-28
	 * @author	luna
	 */
	public class StoneVO
	{
		/*============================================================================*/
		/* Public Variable                                                            */
		/*============================================================================*/
		public var x:uint;
		public var y:uint;
		public var color:uint;//颜色
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function StoneVO()
		{
		}
		
		/*============================================================================*/
		/* Public Function                                                            */
		/*============================================================================*/
		public function get positionValue():uint
		{
			return y * MapMgr.TILE_MAP_WIDTH + x;
		}
	}
}