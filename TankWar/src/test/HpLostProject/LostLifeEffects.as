package test.HpLostProject
{
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class LostLifeEffects extends Sprite
	{
		private var redOne:Shape = new Shape();
		private var whiteOne:Shape = new Shape();
		private var w:Number = 200;
		private var h:Number = 50;
		private var currentHP:Number;
		private var hurtNum:TextField;
		
		public function LostLifeEffects()
		{
			super();
			initView();
			initBtn();
			initText();
		}
		
		private function initBtn():void{
			var attackBtn:MyButton = new MyButton( "攻击", 50, 30 );
			addChild( attackBtn );
			attackBtn.x = 50;
			attackBtn.y = 50;
			attackBtn.addEventListener(MouseEvent.CLICK, attack);
			
			var resetBtn:MyButton = new MyButton( "重置", 50, 30 );
			addChild( resetBtn );
			resetBtn.x = 50;
			resetBtn.y = 100;
			resetBtn.addEventListener(MouseEvent.CLICK, reset);
		}
		
		private function initView():void{
			currentHP = w;
			this.graphics.lineStyle(1);
			this.graphics.drawRect( 50, 200, w, h );
			initBar( whiteOne, 0xffff0f, w, h );
			initBar( redOne, 0xff0000, w, h );
		}
		
		private function initText():void{
			hurtNum = new TextField();
			hurtNum.type = TextFieldType.INPUT;
			hurtNum.restrict = "0-9";
			hurtNum.x = 150;
			hurtNum.y = 100;
			hurtNum.height = 20;
			hurtNum.width = 40;
			hurtNum.border = true;
			addChild( hurtNum );
			
			var description:TextField = new TextField();
			description.text = "请输入一次扣除的血量：0-200";
			description.selectable = false;
			description.x = 120;
			description.y = 60;
			description.height = description.textHeight + 4;
			description.width = description.textWidth + 4;
			addChild( description );
		}
		
		private function initBar( bar:Shape, color:uint, width:Number, height:Number ):void{
			bar.graphics.beginFill( color );
			bar.graphics.drawRect(0, 0, width, height);
			bar.graphics.endFill();
			addChild( bar );
			bar.x = 50;
			bar.y = 200;
		}
		
		private function updateHPBar( reduceNum:Number ):void{
			currentHP -= reduceNum;
			if( currentHP <= 0 )currentHP = 0;
			redOne.width = currentHP;//红色血条宽度立即减少
			TweenLite.to( whiteOne, 2, {width:currentHP} );//白色血条宽度缓慢减少
		}
		
		private function attack(event:MouseEvent):void{
			updateHPBar( Number(hurtNum.text) );
		}
		
		private function reset(event:MouseEvent):void{
			currentHP = redOne.width = whiteOne.width = w;
		}
	}
}