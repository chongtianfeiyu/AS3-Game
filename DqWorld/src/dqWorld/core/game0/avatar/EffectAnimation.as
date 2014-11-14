package dqWorld.core.game0.avatar
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import Effect.MCAttack;
	
	import comLib.display.AnimationCache;

	/**
	 *特效管理，同一个avatar可以有多个效果
	 */	
	public class EffectAnimation
	{
		//效果池
		private var _effectPool:Vector.<EffectAnimationData>;
		
		public function EffectAnimation()
		{
			_effectPool=new Vector.<EffectAnimationData>();
			//效果数据 优先级:贴图时候的层次权重 Bmd:位图数据 BmdConfig:配置信息(宽，高，偏移量)
//			_avatarLoader =new AvatarLoader();
//			_animationPlayer =new BmdAnimation(_avatarLoader.matrixBitmaps);
		}
		
		/**
		 * 添加效果，效果可叠加
		 * @param pos 相对于avatar的位置
		 * @param effectType 效果
		 *  @param effectTid 指定效果ID,如果发现重复，持续时间更具具体值进行增减
		 * @param loop 循环次数
		 * 
		 */
		public function addEffect(pos:Point,effectType:uint,effectTid:String="",loop:int=1):void{
				
			    var data:EffectAnimationData;
			
				if(effectTid!=""){
					var idx:int = findEffect(effectType,effectTid);
					if(idx!=-1){
						data=_effectPool[idx];
						return;
					}
				}
				
				data=new EffectAnimationData();
				data.type=effectType;
				data.tid=effectTid;
				data.loop=loop;
				data.pos=pos;
			
				switch(data.type)
				{	
					case EffectAnimationData.TYPE_BEATTACT:
						data.animation=new AnimationCache();
						data.animation.onComplteFn=onAnimationComplte;
						var mc:MovieClip =new MCAttack;
						data.animation.init(mc,loop);
						break;
				}
				
				_effectPool.push(data);
		}
		
		private function onAnimationComplte(an:AnimationCache):void
		{
			for (var i:int = 0; i < _effectPool.length; i++) 
			{
				if(_effectPool[i].animation==an){
					_effectPool.splice(i,1);
					break;
				}
			}
		}
		
		/**
		 *获取最新的效果组
		 */		
		public function update():Vector.<EffectAnimationData>{
			for (var i:int = 0; i < _effectPool.length; i++) 
			{
				_effectPool[i].animation.update();
			}
			
			return _effectPool;
		}
		
		private function findEffect(effectType:uint,effectTid:String):int{
			for (var i:int = 0; i < _effectPool.length; i++) 
			{
				if(!_effectPool[i])continue;
				if(_effectPool[i].type==effectType&&_effectPool[i].tid==effectTid){
					return i;
				}
			}
			return -1;
		}
	}
}