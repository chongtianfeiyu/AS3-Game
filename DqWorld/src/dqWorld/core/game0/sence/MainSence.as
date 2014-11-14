package dqWorld.core.game0.sence
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import comLib.display.AnimationCache;
	
	import dqWorld.core.game0.ResConfig;
	import dqWorld.core.game0.globalMgr;
	import dqWorld.core.game0.avatar.AvatarData;
	import dqWorld.core.game0.avatar.EffectAnimationData;
	import dqWorld.core.game0.avatar.BaseAvatarPic;
	import dqWorld.core.game0.avatar.PlayerAvatar;
	import dqWorld.core.game0.avatar.PlayerMonsterAvatar;
	import dqWorld.core.game0.avatar.control.PlayerAvatarCtrl;
	import dqWorld.core.game0.avatar.control.PlayerRobotCtrl;
	
	import loader.ResInfo;
	
	public class MainSence extends BaseSence
	{
		private var _avatar:PlayerAvatar;
		private var _avatar2:PlayerMonsterAvatar;
		
		private static var  avatarList:Vector.<BaseAvatarPic>;
		private static var  avatarList0:Vector.<BaseAvatarPic>;
		private var anmation:AnimationCache;
		private var _aBmd:BitmapData;

		
		public function MainSence()
		{	
			
			super(new BitmapData(1000,600,true,0));
			
			
			fps=24;
			
			avatarList=new Vector.<BaseAvatarPic>();
			avatarList0=new Vector.<BaseAvatarPic>();
		
			
			loadMapBG("map1");
			
			
			//玩家
			_avatar=new PlayerAvatar("xiaolin",false);
			_avatar.control =new PlayerAvatarCtrl(globalMgr.stage);
			_avatar.pointX = 500;
			_avatar.pointY=200;
			_avatar.godMod=true;
			_avatar.checkHitTest=true;//是否加入碰撞,默认是false,直接无敌了?也打不中别人
			_avatar.hitObjects=avatarList;
			
			//机器人
			for (var i:int = 0; i <50; i++) 
			{
				_avatar2=new PlayerMonsterAvatar("xiaolin",false,AvatarData.ACTION_0,0);
				var ctr:PlayerRobotCtrl=new PlayerRobotCtrl(globalMgr.stage);
//				ctr.autoAttack=false;
//				ctr.autoMove=false;
				_avatar2.control =ctr;
				_avatar2.checkHitTest=true;
//				
//				_avatar2.pointX = 250;
//				_avatar2.pointY=250;
				
				_avatar2.pointX = Math.random()*1000;
				_avatar2.pointY=Math.random()*800;
				//_avatar2.hitObjects=avatarList;
				addAvatarToSence(_avatar2);
			}
	
			addAvatarToSence(_avatar);
			
			//预加载动作数据
			globalMgr.loderMgr.preload(new ResInfo("actonXml",ResConfig.resPath+"xiaolin"+"/action.xml",ResInfo.TYPE_URL,function(data:*):void{
				var xml:XML =new XML(data);
				var imgPath:String = xml.attribute("imagePath");
				globalMgr.loderMgr.preload(new ResInfo("actonPNG",ResConfig.resPath+"xiaolin"+"/"+imgPath,ResInfo.TYPE_SWF,function(data:*):void{
			
					for each (var avatar:PlayerAvatar in senceAvatars) 
					{
						avatar.setActionBmd(xml,(data as Bitmap).bitmapData);
					}
				}));
			}));
			
			
			
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode==Keyboard.SPACE){
			if(_avatar&&_avatar.isDead){
					_avatar.hp=10;
					_avatar.isDead=false;
					addAvatarToSence(_avatar);
					stop=false;
				
					globalMgr.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				}
			}
		}	
		
		override protected function onUpdate():void
		{
			
			
			//先更新位置信息
			resetTitlMapData();
			//重新配置碰撞对象
			setHitAvatars();
			for each (var avatar0:BaseAvatarPic in senceAvatars) 
			{	
				if(avatar0.isDead)
					senceAvatars.splice(senceAvatars.indexOf(avatar0),1);
			}
			
			for each (var avatar:BaseAvatarPic in senceAvatars) 
			{	
				//优化碰撞区域,从场景来判断获取碰撞对手
				avatar.update();
				if(avatar.bitmapData)//画血条
				{
					bitmapData.copyPixels(avatar.bitmapData, avatar.bitmapData.rect, new Point(avatar.senceX,avatar.senceY),null,null,true);
					
					var effects:Vector.<EffectAnimationData>=avatar.effectMgr.update();			
					for each (var eff:EffectAnimationData in effects) 
					{
						if(!eff.animation)continue;
						var effBmd:BitmapData= eff.animation.getCurBmd();
						if(effBmd){
							bitmapData.copyPixels(effBmd,effBmd.rect,new Point(avatar.senceX,avatar.senceY),null,null,true);
						}
					}
					
					var hpWidth:Number=  avatar.hp/avatar.totalHp*30;
					if(hpWidth>0){
						bitmapData.copyPixels(new BitmapData(hpWidth,5,false,0xFF0000),new Rectangle(0,0,hpWidth,5),new Point(avatar.pointX-hpWidth/2,avatar.pointY-avatar.bitmapData.height-6));
					}
				}
			}
			
			super.onUpdate();
		}
		
		override protected function onGameOver():void{
			if(_avatar.isDead){
				stop=true;
				if(!bitmapData)return;
				
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(0,0),new ColorMatrixFilter([
					0.5,0.5,0.0,0,0,
					0.5,0.5,0.0,0,0,
					0.5,0.5,0.0,0,0,
					0,0,0,1,0
				]));
				
				var overSp:Sprite=new Sprite();
				var tx:TextField=new TextField();
				tx.defaultTextFormat=new TextFormat("songti",30);
				tx.width=300;
				tx.height=300;
				tx.text="GAME OVER！！\n\r 按空格键重新开始!!!!";
				overSp.addChild(tx);
				var overBmp:Bitmap=new Bitmap(new BitmapData(overSp.width,overSp.height,true,0x00000000));
				overBmp.bitmapData.draw(overSp);
				
				bitmapData.copyPixels(overBmp.bitmapData, overBmp.bitmapData.rect, new Point(1000/2,600/2),null,null,true);
				
				globalMgr.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			}
		}
		
		
	}
}
