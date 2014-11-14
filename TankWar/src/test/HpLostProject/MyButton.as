package test.HpLostProject
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MyButton extends Sprite
	{
		public function MyButton( label:String, width:Number, height:Number, UpColor:uint=0x999999, overColor:uint=0x000099 )
		{
			var Label:TextField = new TextField();
			Label.selectable = false;
			Label.htmlText = label;
			Label.width = Label.textWidth + 4;
			Label.height = Label.textHeight + 4;
			Label.mouseEnabled = false;
			
			updateBtn( UpColor, width, height );
			Label.x = Label.y = 5;
			this.addChild( Label );
			this.addEventListener(MouseEvent.ROLL_OVER, function(event:MouseEvent):void{
				updateBtn( overColor, width, height);
			});
			this.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):void{
				updateBtn( UpColor, width, height);
			});
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		private function updateBtn( color:uint, w:Number, h:Number ):void{
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.beginFill( color );
			this.graphics.drawRect( 0, 0, w, h );
			this.graphics.endFill();
		}
	}
}

