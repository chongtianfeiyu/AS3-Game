package test.BackGroundDragProject
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import TANK_UI.Num1;
	
	public class BackGroundSence extends Sprite
	{
		private var __stage:Stage;
		private var _oldPoint:Point;
		private var _newPoint:Point;
		public function BackGroundSence(_stage:Stage)
		{
		    __stage=_stage;
			__stage.scaleMode=StageScaleMode.NO_SCALE;
	
			graphics.beginFill(1*Math.random(),1);
			graphics.drawRect(0,0,1000,1000);
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);

			super();
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			trace("up");
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			_oldPoint=new Point(__stage.mouseX,__stage.mouseY);
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			_newPoint= new Point(__stage.mouseX,__stage.mouseY);
			var distanceX:Number =_oldPoint.x -_newPoint.x;
			var distanceY:Number =_oldPoint.y -_newPoint.y;
			x = x-distanceX;
			y=y-distanceY;
			
			_oldPoint=new Point(__stage.mouseX,__stage.mouseY);
		}
		
	}
}