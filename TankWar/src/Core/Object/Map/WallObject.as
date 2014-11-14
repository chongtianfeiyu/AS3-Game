package Core.Object.Map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import Core.Sence.TankSence;
	import Core.Object.FaceObject;
	import Core.Sound.SoundMgr;
	
	import GameObj.Global.GlobalMgr;
	import GameObj.Object.ActionObject;
	
	import TANK_UI.Wall;
	
	public class WallObject extends FaceObject
	{
		private var _bitMap:Bitmap;
		private var _oX:int=int.MIN_VALUE;
		private var _oY:int=int.MIN_VALUE;
		
		public function WallObject()
		{
			_hitTest=true;
			
			var skin:Sprite = new Sprite();
			var row:int=1;
			for ( var k:int = 2; k < 6; k++) 
			{
				var wall:Wall =new  Wall();
				if(k==4){
					row=2;
				}
				
				wall.x = (k%2)*wall.width;
				wall.y=((row-1))*wall.height;
				skin.addChild(wall);
			}
			
			super(null,skin);
			addChild(skin);
			
			_bitMap= new Bitmap(new BitmapData(skin.width,skin.height));
			_bitMap.bitmapData.draw(skin);
			
			setHitPoints();
		}
		
		private function setHitPoints(_x:int=0,_y:int=0):void{
			_hitPoints=[
				[_x,_y],
				[_x+width/2,_y],
				[_x+width,_y],
				[_x+width,_y+height/2],
				[_x+width,_y+height],
				[_x+width/2,_y+height/2],
				[_x,_y+height],
				[_x,_y+height/2]
			];
			
		}
		
		override public function Hurt(HurtType:int, damage:Number,direction:int=-1):void
		{
			if(_oX==int.MIN_VALUE)_oX=x;
			if(_oY==int.MIN_VALUE)_oY=y;
			
			var subVal:int=8;
			var oHeight:int= height;
			var oWidth:int=width;

			switch(direction)
			{
				case ActionObject.HURT_DIRECTION_DOWN:
					oHeight=subVal<height?(oHeight-subVal):0;
					break;
				case ActionObject.HURT_DIRECTION_UP:
					oHeight=subVal<oHeight?(oHeight-subVal):0;
					y=subVal<oHeight?(y+subVal):(y+oHeight);
					break;
				case ActionObject.HURT_DIRECTION_LEFT:
					oWidth=subVal<oWidth?(oWidth-subVal):0;
					x=subVal<oWidth?(x+subVal):(x+oWidth);
					break;
				case ActionObject.HURT_DIRECTION_RIGHT:						
					oWidth=subVal<oWidth?(oWidth-subVal):0;
					break;
			}
			
			while(numChildren){
				removeChildAt(0);
			}
			
			graphics.clear();
			graphics.beginBitmapFill(_bitMap.bitmapData,new Matrix(1,0,0,1,_oX-x,_oY-y));
			graphics.drawRect(0,0,oWidth,oHeight);
			graphics.endFill();
			
			SoundMgr.playTankShot();
		
			if(height<=0&&width<=0){
				Die();return;
			}
			
			//重置碰撞区
			setHitPoints(0,0);
		
		}
		
		
		override public function Die():void
		{
			
			super.Die();
			GlobalMgr.scene.removeObject(this,TankSence.OBJECT_LIST_TYPE_MAP_ACTIONOBJ);
			
		
		}
		
	}
}