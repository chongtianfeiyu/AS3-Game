package dqWorld.core.game0.sence
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import dqWorld.core.game0.ResConfig;
	import dqWorld.core.game0.globalMgr;
	import dqWorld.core.game0.avatar.BaseAvatarPic;
	
	import loader.ResInfo;
	
	public class BaseSence extends Bitmap
	{
		//逻辑格子
		public var cellWidth:Number=36;
		public var cellHeight:Number=36;
		//需要体格TITLMAP;
		public var _titlMap:Array;
		private var _senceAvatars:Vector.<BaseAvatarPic>;

		public function get senceAvatars():Vector.<BaseAvatarPic>
		{
			return _senceAvatars;
		}
		
		private var _fps:int=60;
		public function set fps(value:int):void
		{
			if(value>60)value=60;
			if(value<20)value=24;

			_fps=value;
			_timer.delay=1000/value;
		}

		
		private var _time:int;
		private var _count:int;
		private var _lastTime:int;
		
		
		
		private var _timer:Timer;
		private var _fpsSp:Sprite;
		private var _tx:TextField;
		private var _fpsBmd:Bitmap;
		
		private var _bgBmp:Bitmap;
		
		public function BaseSence(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			_senceAvatars=new Vector.<BaseAvatarPic>();
			super(bitmapData, pixelSnapping, smoothing);
			
			createTitlMap();
			_time =0;
			_count=0;
			
			_lastTime=getTimer();
			_timer =new Timer(1000/60);
			_timer.addEventListener(TimerEvent.TIMER,onEnterFrame);
			_timer.start();
			
			_fpsSp=new Sprite();
			_tx=new TextField();
			_tx.text="fps...";
			_fpsSp.addChild(_tx);
			_fpsBmd=new Bitmap(new BitmapData(_fpsSp.width,_fpsSp.height,true,0x00000000));
			
		}
		
		protected function loadMapBG(mapName:String):void{
			globalMgr.loderMgr.preload(new ResInfo("actonXml",ResConfig.RES_MAP+mapName+".jpg",ResInfo.TYPE_SWF,function(data:*):void{
				_bgBmp=data;
			}));
		}
		
		private function createTitlMap():void{
			_titlMap=new Array();
			
//			//组织逻辑地图
//			var rows:uint =bitmapData.rect.width/cellWidth;
//			var cols:uint =bitmapData.rect.height/cellHeight;
//			
//			//具体格子也可以延迟创建
//			for (var i:int = 0; i < rows; i++) 
//			{
//				_titlMap[i]=new Array();
//				for (var j:int = 0; j < cols; j++) 
//				{
//					_titlMap[i][j]=new Array();
//				}
//			}
		}
		
		/**
		 *更新数据 
		 * 
		 */		
		protected function resetTitlMapData():void{
			
			var c:Number =new Date().time;
			createTitlMap();
			
			for each (var avatar:BaseAvatarPic in _senceAvatars) 
			{
				//计算现在的逻辑位置
				var row:int= avatar.pointX/cellWidth;
				var col:int= avatar.pointY/cellHeight;
				
				var oldRow:int=row;
				var oldCol:int=col;
				
				//1.在数据基础上做替换
				if(row<0||col<0)continue;
				if(!_titlMap[String(row)])
					_titlMap[String(row)]=new Array();
				if(!_titlMap[String(row)][String(col)])
					_titlMap[String(row)][String(col)]=new Array();
				//if(row>=_titlMap.length||col>=_titlMap[row].length)continue;
				
				//avatar在哪个格子里
				if(!avatar.logicPos){
					avatar.logicPos=[row,col];
				}
				else{
					oldRow=avatar.logicPos[0];
					oldCol=avatar.logicPos[1];
				}
				
			
				
				_titlMap[String(row)][String(col)].push(avatar);
				avatar.logicPos=[row,col];
//				
//				if(row!=oldRow||col!=oldCol){
//					//位置发生变化才变动数据
//					var oldIdx:int =_titlMap[oldRow][oldCol].indexOf(avatar);
//					if(oldIdx!=-1){
//						_titlMap[oldRow][oldCol].splice(oldIdx,1);
//					}
//					_titlMap[row][col].push(avatar);
//					avatar.logicPos=[row,col];
//				}
			}
		}
		
		public var stop:Boolean=false;
		
		private function onEnterFrame(event:Event):void
		{	
			if(stop)return;
		
			if(getTimer()- _lastTime>1000){
				_tx.text = String("fps:"+_count+",num:"+_senceAvatars.length);
				_lastTime= getTimer();
				_count=0;
			}
			_count++;
			bitmapData.lock();
			
			//清理画布
			bitmapData.fillRect(bitmapData.rect, 0x0AAAAAFFF);
			//绘制背景
			if(_bgBmp)
				bitmapData.copyPixels(_bgBmp.bitmapData,_bgBmp.bitmapData.rect,new Point(0,0),null,null,true);
			
			onUpdate();
			
			_fpsBmd.bitmapData.fillRect(bitmapData.rect, 0x0AAAAAFFF);
			_fpsBmd.bitmapData.draw(_fpsSp);
			bitmapData.copyPixels(_fpsBmd.bitmapData,_fpsBmd.bitmapData.rect,new Point(0,0),null,null,true);
			
			onGameOver();
			
			bitmapData.unlock();
		}
		
		protected function onGameOver():void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function onUpdate():void
		{
	
		}
		
		/**
		 *添加avatar到场景中 
		 * @param set
		 * 
		 */		
		public function addAvatarToSence(set:BaseAvatarPic):void{
			if(_senceAvatars.indexOf(set)!=-1)return;
			_senceAvatars.push(set);
		}
		
		/**
		 *获取有效范围内的可碰撞对手 
		 * @param set
		 * @param range
		 * @return 
		 */
		public function setHitAvatars():void
		{
			if(!_titlMap)return;

			var row:uint=0;
			var col:uint=0;
			
			var nextCells:Array=new Array;
			var hitAvatars:Vector.<BaseAvatarPic>
	
			for each (var avatar:BaseAvatarPic in _senceAvatars) 
			{
				if(!avatar.logicPos)continue;
				
				hitAvatars=new Vector.<BaseAvatarPic>();
				row=avatar.logicPos[0];col=avatar.logicPos[1];
				//8方位格子的索引 0:自己,1:上,2:右上,3:右,4:右下,5:下,6:左下,7:左,8:左上
				nextCells=[
					getNextLogicCell(row,col),
					getNextLogicCell(row-1,col),
					getNextLogicCell(row-1,col+1),
					getNextLogicCell(row,col+1),
					getNextLogicCell(row+1,col),
					getNextLogicCell(row+1,col-1),
					getNextLogicCell(row,col-1),
					getNextLogicCell(row-1,col-1),
				]
					
				for (var i:int = 0; i < nextCells.length; i++) 
				{
					if(nextCells[i]&&nextCells[i].length>0){
					
						for (var j:int = 0; j < nextCells[i].length; j++) 
						{
							if(nextCells[i][j].checkHitTest)
								hitAvatars.push(nextCells[i][j]);
						}
					}
				}
				
				if(hitAvatars.length>0)
					avatar.hitObjects=hitAvatars;
			}
		}
		
		private function getNextLogicCell(nextRow:int,nextCol:int):Array{
			if(nextRow<0||nextCol<0)return null;
			if(_titlMap[String(nextRow)]&&_titlMap[String(nextRow)][String(nextCol)])
				return _titlMap[String(nextRow)][String(nextCol)];
			return null;
		}
	}
}