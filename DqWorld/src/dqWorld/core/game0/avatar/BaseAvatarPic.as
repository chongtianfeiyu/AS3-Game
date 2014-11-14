package dqWorld.core.game0.avatar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import dqWorld.core.game0.avatar.control.BaseCtrl;
	import dqWorld.core.game0.avatar.control.PlayerAvatarCtrl;
	import dqWorld.core.game0.avatar.loader.AvatarLoader;
	
	public class BaseAvatarPic extends Bitmap
	{
		//上帝模式，无敌状态,哈哈哈哈哈
		public var godMod:Boolean=false;
		
		//是否参与碰撞
		public var checkHitTest:Boolean=false;		
		
		//逻辑格子位置
		public var logicPos:Array;
		protected var _curBitmapData:BitmapData;
		private var _curMatrixData:Object;
		
		protected var _isDead:Boolean;
		public function get isDead():Boolean
		{
			return _isDead;
		}
		public function set isDead(value:Boolean):void
		{
			_isDead = value;
		}
		
		
		protected var _control:BaseCtrl;

		public function get control():BaseCtrl
		{
			return _control;
		}

		public function set control(value:BaseCtrl):void
		{
			_control = value;
			_control.target=this;
		}
		
		
		protected var _totalHp:int=10;
		public function get totalHp():int
		{
			return _totalHp;
		}
		
		protected var _hp:int=10;
		/***血量*/	
		public function get hp():int
		{
			return _hp;
		}
		public function set hp(value:int):void
		{
			_hp = value;
		}

		//动作
		protected var  _action:int=0;
		public function get action():int
		{
			return _action;
		}
		public function set action(value:int):void
		{
			_action = value;
		}
		
		//奔跑方向
		protected var _direction:uint=0;
		public function get direction():uint
		{
			return _direction;
		}
		public function set direction(value:uint):void
		{
			_direction = value;
		}
		
		//面朝方向 0:右 1:左
		protected var _faceTo:uint=1;
		public function get faceTo():uint{
			return _faceTo;
		}
		
		protected var _isWait:Boolean=true;
		public function get isWait():Boolean
		{
			return _isWait;
		}
		public function set isWait(value:Boolean):void
		{
			_isWait = value;
		}
		
		//是否行走
		protected var _isWalk:Boolean=false;
		public function get isWalk():Boolean
		{
			return _isWalk;
		}
		public function set isWalk(value:Boolean):void
		{
			_isWalk = value;
		}
		
		//是否奔跑中
		protected var _isRun:Boolean=false;
		public function get isRun():Boolean
		{
			return _isRun;
		}
		public function set isRun(value:Boolean):void
		{
			_isRun = value;
		}
		
		//是否跳跃中
		protected var _isJump:Boolean=false;
		public function get isJump():Boolean
		{
			return _isJump;
		}
		public function set isJump(value:Boolean):void
		{
			_isJump = value;
		}
		
		protected var _isAttack:Boolean;
		public function get isAttack():Boolean
		{
			return _isAttack;
		}
		public function set isAttack(value:Boolean):void
		{
			_isAttack = value;
		}
		
		protected var _speed:Number;
		public function get speed():Number
		{
			return _speed;
		}
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		protected var _fps:int=24;
		/**
		 * 设置动画帧率 
		 * @param value 多少时间切换一副图片，单位毫秒
		 *  */                
		public function set fps( value:int ):void{
			_fps = value;
		}
		
		protected var _xSpeed:Number;
		
		//坐标位置
		public var pointX:Number=0;
		public var pointY:Number=0;
		
		//贴图时候的位置
		public function get senceX():Number
		{
				if(_curMatrixData){
					 if(faceTo==1){
						 return pointX+_curMatrixData.cPoint[0];
					 }
					 
					 return pointX-(_curMatrixData.width+_curMatrixData.cPoint[0]);
				}
				return pointX;
		}

		public function get senceY():Number
		{
		
			if(_curMatrixData){
				return pointY+_curMatrixData.cPoint[1];
			}
			
		
			return pointY;
		}
		
		protected var _hitObjects:Vector.<BaseAvatarPic>;
		/**
		 * 可碰撞对象
		 *  */                
		public function set hitObjects( value:Vector.<BaseAvatarPic> ):void{
			_hitObjects = value;
		}
		
		
		private var _bitmapData:BitmapData;
		private var _avatarLoader:AvatarLoader;
		
		public function get matrixData():Array{
		  return _avatarLoader.matrixDatas;
		}
		
		public function setActionBmd(xmlConfig:XML,bmd:BitmapData):void{
			_avatarLoader.xml =xmlConfig;
			_avatarLoader.fillArr(bmd);
		}
		
		private  var _animationPlayer:AvatarAnimation;
		private var _curFrame:uint;
		private var _lastTime:int;
		private var _effectMgr:EffectAnimation;

		public function get effectMgr():EffectAnimation
		{
			return _effectMgr;
		}

	
		protected function get animationPlayer():AvatarAnimation
		{
			return _animationPlayer;
		}

		public function BaseAvatarPic(avatarName:String,autoLoad:Boolean=true)
		{
			super(null, "auto", false);
			_avatarLoader =new AvatarLoader(avatarName,autoLoad);
			_animationPlayer =new AvatarAnimation(_avatarLoader.matrixBitmaps);
			_effectMgr=new EffectAnimation();
			_lastTime=getTimer()
		}
		
		/**
		 *动画播放 
		 * @param action 播放动作
		 * @param loop 重复次数
		 * @param startFrame 开始帧数 -1为自动为开始位置
		 * @param endFrame  结束帧数 -1为自动到结束位置
		 * 
		 */		
		public function setAnimation(action:int,loop:int=-1,startFrame:int=1,endFrame:int=-1):void{
			_action =action;
			_animationPlayer.stop();
			_animationPlayer.play(action,loop,startFrame,endFrame);
		}
		
		protected function resetPostion():void{
		
		}

		public function update():void{
			
			if(isDead)return;
			
			if(getTimer()- _lastTime<(1000/_fps)){
				return;
			}
			
			_lastTime=getTimer()
				
			if(bitmapData)
				bitmapData.lock();
				
			_curBitmapData=animationPlayer.update();
			_curFrame=animationPlayer.curFrame;
		
			if(_faceTo==0&&_curBitmapData){
				_curBitmapData=setRegPoint(_curBitmapData);
			}
			
			bitmapData=_curBitmapData;
			_curMatrixData=getMatrixBitmapData(_action,_curFrame);
		
			//碰撞
			if(checkHitTest)
					hitTest();
		
			//打完以后调整位置
			resetPostion();
			
			resetEffect();
			
			if(bitmapData)
				bitmapData.unlock();
		}
		
		/**碰撞相关操作 */		
		protected function hitTest():void{
			
		}
		
		protected function resetEffect():void
		{
			
		}
		
		//判断两个对象是否已经接触
		protected function checkHit(avatar:Object):Boolean{
			
			//先判断是否在已进入范围
			var _inRange:Boolean=false;
			if(bitmapData&&avatar.bitmapData){
				if(bitmapData.hitTest(new Point(senceX,senceY),255,avatar.bitmapData,new Point(avatar.senceX,avatar.senceY),255)){
					return true;
				}
			}
			
			return false;
		}
		
		//判断是否进入有效攻击
		protected function checkVaildAttack(avatar:Object):Boolean{
			
			var hitAreas:Array =getCurFrameHitAreas();
			//没有有效的攻击
			if(!hitAreas)return false;
			
			var bittenAreas:Array =avatar.getCurFrameBittenAreas();
			//没有有效的受击区域
			if(!bittenAreas)return false;
			
			for (var i:int = 0; i < hitAreas.length; i++) 
			{
				var aX:Number=hitAreas[i][0];
				var aY:Number=hitAreas[i][1];
				var aW:Number=hitAreas[i][2];
				var aH:Number=hitAreas[i][3];
				
				aY+=senceY;
				//正常方向
				if(faceTo==1){
					aX=senceX+aX;
				}
				else{
					//镜像
					aX= (senceX+width)-(aX)-aW;
				}
				
				
				var aBmd:BitmapData=new BitmapData(aW,aH,false,0);
				
				for (var j:int = 0; j < bittenAreas.length; j++) 
				{
					var bX:Number=bittenAreas[j][0];
					var bY:Number= bittenAreas[j][1];
					var bW:Number=bittenAreas[j][2];
					var bH:Number=bittenAreas[j][3];
					bY+=avatar.senceY;
					if(avatar.faceTo==1){
						bX=avatar.senceX+bX
					}
					else{
						//镜像
						bX=(avatar.senceX+avatar.width)-(bX)-bW;
					}
					
					var bBmd:BitmapData=new BitmapData(bW,bH,false,0);
					
					
					if(aBmd.hitTest(new Point(aX,aY),255,bBmd,new Point(bX,bY),255)){	
						return true;
					}
				}
			}
			return false;
		}
		
		private function getMatrixBitmapData(layer:uint,frame:uint):Object{
			
			if(layer<_avatarLoader.matrixDatas.length){
				if(frame<_avatarLoader.matrixDatas[layer].length){
					return _avatarLoader.matrixDatas[layer][frame];
				}
			}
			return null;
		}
		
		protected function setRegPoint(oldBmd:BitmapData):BitmapData{
			var m:Matrix = new Matrix(); 
			m.a = -1;
			m.translate(oldBmd.width,0); 
			var bd:BitmapData = new BitmapData(oldBmd.width, oldBmd.height,true,0); 
			bd.draw(oldBmd,m);
			return bd;
		}

		/**
		 * 停止动画 
		 * 
		 */                
		public function stop():void{
			animationPlayer.stop();
		}
		
		/**
		 *获取当前帧可受击的区域 
		 */	
		protected function getCurFrameBittenAreas():Array{
			var areas:Array=[];
			if(matrixData[_action]&&_curFrame<matrixData[_action].length){
				var bittenAreas:Array =matrixData[_action][_curFrame].bittenAreas;
				if(!bittenAreas)return null;
				
				for (var i:int = 0; i < bittenAreas.length; i++) 
				{
					if(bittenAreas[i]==""||!bittenAreas)continue;
					if(bittenAreas[i].split(',').length==4){
						areas.push(bittenAreas[i].split(','));
					}
				}
			}
			return areas;
		}
		
		/**
		 *获取当前帧有效的攻击区域
		 */
		protected function getCurFrameHitAreas():Array{
			var areas:Array=[];
			if(matrixData[_action]&&_curFrame<matrixData[_action].length){
				var hitAreas:Array =matrixData[_action][_curFrame].hitAreas;
				if(!hitAreas)return null;
				
				for (var i:int = 0; i < hitAreas.length; i++) 
				{
					if(hitAreas[i]==""||!hitAreas)continue;
					if(hitAreas[i].split(",").length==4){
						areas.push(hitAreas[i].split(","));
					}
				}
			}
			return areas;
		}
	
	}
}