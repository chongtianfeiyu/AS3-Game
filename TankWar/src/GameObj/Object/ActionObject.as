package GameObj.Object
{
	import GameObj.Global.GlobalMgr;
	
	
	/**
	 *游戏中可运动的对象基类
	 * @author XN-HuangH
	 */	
	public class ActionObject extends GameObject
	{
		private var _hitTargetTypes:Array=[];
		
		/**
		 * 碰撞检测点
		 */
		protected var _hitPoints:Array = [];
		
		protected var _hitTargets:Vector.<GameObject>;

		
		/**
		 *移动速度 
		 */		
		protected var _speed:Number =1.2;
		public function set speed(val:Number):void
		{
			_speed = val;
			
		}
		
		/**
		 *移动方向 
		 */		
		public var moveDirection:uint =1;
		
		
		public var alwaysTop:Boolean=false;
		
		/**
		 * 是否移动
		 */
		protected var _isMove:Boolean = false;

		public function set isMove(val:Boolean):void
		{
			_isMove = val;
		}
		
		
		/**
		 *移动范围 
		 */		
		protected var moveRange:Array=[0,0,GlobalMgr.stage.stageWidth - width,GlobalMgr.stage.stageHeight - height ];
		
		public static const MOVE_UP:uint = 1;  //上
		public static const MOVE_DOWN:uint = 2; //下
		public static const MOVE_LEFT:uint = 3;   //左
		public static const MOVE_RIGHT:uint = 4; //右
		
		public static const HURT_DIRECTION_UP:uint = 1;  //上
		public static const HURT_DIRECTION_DOWN:uint = 2; //下
		public static const HURT_DIRECTION_LEFT:uint = 3;   //左
		public static const HURT_DIRECTION_RIGHT:uint = 4; //右
		
		//----------------攻击类型--------------
		public static const HURT_TYPE_1:uint=1;//攻击类型1
		public static const HURT_TYPE_2:uint=2;//攻击类型1
		public static const HURT_TYPE_3:uint=3;//攻击类型1
		public static const HURT_TYPE_4:uint=4;//攻击类型1
		public static const HURT_TYPE_5:uint=5;//攻击类型1
		
		/**
		 * 修改移动方向
		 */
		public function set direction(dir:uint):void
		{
			moveDirection = dir;
		}
		
		
		//----------------构造函数-------------------------
		public function ActionObject()
		{
			_hitTest=true;
			
			super();
		}
		
		//----------------行为-----------------------------
		
	
		protected function intHitTarget(___hitTargetTypes:Array):void{
			
			_hitTargetTypes=___hitTargetTypes;
			_hitTargets= new Vector.<GameObject>();
			for (var i:int = 0; i < _hitTargetTypes.length; i++) 
			{
				var list:Array = GlobalMgr.scene.AllObject(_hitTargetTypes[i]);
				if(list){
					for (var j:int = 0; j < list.length; j++) 
					{
						addHitTargetHandel(list[j]);
					}
				}
			}
			
		}
		
		protected function addHitTargetHandel(obj:GameObject=null):void
		{
			if(!_hitTargets)
				_hitTargets= new Vector.<GameObject>();
			
			if(obj!=null&&obj.hasOwnProperty("objectListType")){
				if(_hitTargetTypes.indexOf(obj.objectListType)!=-1&&_hitTargets.indexOf(obj)==-1){
					_hitTargets.push(obj);
				}
			}
		}
		
		protected function removeHitTargetHandel(obj:GameObject=null):void
		{
			if(!_hitTargets)
				return;
			
			if(obj!=null&&obj.hasOwnProperty("objectListType")){
				var idx:int =_hitTargets.indexOf(obj);
				if(idx!=-1){
					_hitTargets.splice(idx,1);
				}
			}
		}
		
		
		protected function get  canMoveNext():Boolean{
		
			if(!moveRange){
				return true;
			}
			
			// 下一X位置
			var nx:uint = 0;
			// 下一Y位置
			var ny:uint = 0;
			// 根据移动方向进行处理，计算出下一目标点位置
			switch(moveDirection)
			{
				case MOVE_UP:
					ny = y-_speed;
					nx = x;
					break;
				case MOVE_DOWN:
					ny = y+_speed;
					nx = x;
					break;
				case MOVE_LEFT:
					nx = x-_speed;
					ny = y;
					break;
				case MOVE_RIGHT:
					nx = x+_speed;
					ny = y;
					break;
				default:break;
			}

			// 如果下一目标点超出屏幕范围，则不能移动
			if (nx > moveRange[2] - width || nx < moveRange[0]) return false;
			if (ny >moveRange[3] || ny < moveRange[1]) return false;
			
		
	   if(hitTest&&_hitTargets){

				// 计算下一目标点的碰撞测试（本部分为新增代码）
				for each(var obj:GameObject in _hitTargets)
				{
					if (obj == this || !obj.hitTest) continue;
					
					for each(var p:Array in _hitPoints)
					{
						if (obj.hitTestPoint(nx + p[0], ny + p[1], true)){ 
							
							return false;
						}
					}
				}
		   }
			
			// 检测通过
			return true;
		}
		
		
		
		/**
		 *移动 
		 */		
		protected function Move():void
		{
						//移动方向
						switch(moveDirection)
						{
							case MOVE_UP:
							{
								y -= _speed;
								break;
							}
								
							case MOVE_DOWN:
							{
								y += _speed;
								break;
							}
								
							case MOVE_LEFT:
							{
								x -= _speed;
								break;
							}
								
							case MOVE_RIGHT:
							{
								x += _speed;
								break;
							}
								
							default:
							{
								break;
							}
						}
		}
		
		/**
		 *覆盖父类的Do方法
		 * 
		 */		
		override public function Do():void{
		
		}
		
	
		
	}
}