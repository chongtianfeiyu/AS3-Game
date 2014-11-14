package Core.Sence
{

	import flash.display.Stage;
	
	import Core.Object.BaseMent.BaseMentObject;
	import Core.Object.Map.GrassObject;
	import Core.Object.Map.WallObject;
	import Core.Object.Monster.EnmeyObject;
	import Core.Object.Player.PlayerObject;
	
	import GameObj.Sence.GameScene;
	
	import TANK_UI.BaseMent;
	import TANK_UI.Tank0;
	import TANK_UI.Tank1;
	import TANK_UI.Tank2;
	import TANK_UI.Tank3;
	
	
	public class TankSence extends GameScene
	{
		
		
		public static const OBJECT_LIST_TYPE_ENEMY:int =OBJECT_LIST_TYPE_0;
		public static const OBJECT_LIST_TYPE_PLAYER:int =OBJECT_LIST_TYPE_1;
		public static const OBJECT_LIST_TYPE_BULLET:int =OBJECT_LIST_TYPE_2;
		public static const OBJECT_LIST_TYPE_MAP_ACTIONOBJ:int =OBJECT_LIST_TYPE_3; //可以互动的对象
		public static const OBJECT_LIST_TYPE_MAP_OTHEROBJ:int =OBJECT_LIST_TYPE_4;
		
		
		public static const OBJECT_CAMP_1:int=1;
		public static const OBJECT_CAMP_2:int=2;
		public static const OBJECT_CAMP_3:int=3;
		

		
		private var _basePosition:Array=[16,11]; //基地默认位置 [row,colum]
		private var _player0Postion:Array=[16,9]; //玩家默认位置 [row,colum]
		
		private var _mapConfig:Vector.<Array>;
		
		public function TankSence(_stage:Stage)
		{
			super(_stage);
		}
		
		//创建战场
		public function SetupBattleFiled():void{
			
			_mapConfig=SetupRandomMapConfig();
			
			AddObjectToMap(1,int.MAX_VALUE);//贴砖块
			AddObjectToMap(0,10);//贴敌人
			
			AddObjectToMap(9,1);//贴基地
			AddObjectToMap(8,1);//贴自己
			
			AddObjectToMap(2,int.MAX_VALUE);//贴草丛
		}
		
		/**
		 *随机地图 
		 * @return 
		 * 
		 */	
		private function SetupRandomMapConfig():Vector.<Array>{
			
			//自动创建12*12的数组
			var maxRows:int=16;
			var maxCloum:int=20;
			
			var mapConfig:Vector.<Array>=new Vector.<Array>(maxRows,true);
			
			//格子宽度
			var cellWidth:Number =32;
			var cellHeight:Number=32;
			
			for (var i:int = 0; i < mapConfig.length; i++) 
			{
				var row:Array = new Array();
				mapConfig[i] =row;
				
				for (var j:int = 0; j < maxCloum; j++) 
				{
					//0,无|1,铁格子|2.冰块|3.墙壁/4.河流	
					var objType:int =int(Math.random()*3);//0-4随机数
					
					if(i+1==_basePosition[0]&&j+1==_basePosition[1]){//强制指定为基地位置
					  objType=9;
					}
					
					if(i+1==_player0Postion[0]&&j+1==_player0Postion[1]){//强制指定为玩家位置
						objType=8;
					}
					
					row.unshift(
						{
							type:objType,
							x:cellHeight*j,
							y:cellWidth*i
						}
					);
				}
			}
			
		
			return mapConfig;
		}
		
		//贴图
		private function AddObjectToMap(type:int,max:int):void{
			
			var row:int=1;
			var k:int=1;
			
			for (var i:int = 0; i < _mapConfig.length; i++) 
			{
				for (var j:int = 0; j < _mapConfig[i].length; j++) 
				{
					var cell:Object = _mapConfig[i][j];
					if(cell.type==type){
						
						if(max<=0){
							return;
						}
						
						switch(cell.type)
						{
							case 1: //墙壁
							{
								if(Math.random()>0.61){
								  break;
								}
								
								var wall:WallObject =new  WallObject();
								wall.x = cell.x;
								wall.y=cell.y;
								wall.Group=OBJECT_CAMP_1;
								wall.objectListType =OBJECT_LIST_TYPE_MAP_ACTIONOBJ;
								addObject(wall,OBJECT_LIST_TYPE_MAP_ACTIONOBJ);
								
								max--;
								break;
							}
								
							case 2: //草地
							{
									var grass:GrassObject =new  GrassObject();
									grass.x = cell.x;
									grass.y=cell.y;
									
									//草地，不加入对象列表
									grass.objectListType =OBJECT_LIST_TYPE_MAP_OTHEROBJ;
									addObject(grass,OBJECT_LIST_TYPE_MAP_OTHEROBJ);
							
								max--;
								break;
							}
								
							case 8://玩家
							{
								
								var player0:PlayerObject =new  PlayerObject(new Tank0);
							
								player0.x = cell.x;
								player0.y=cell.y;
								
								player0.Group=OBJECT_CAMP_2;
								player0.objectListType =OBJECT_LIST_TYPE_PLAYER;
							
								addObject(player0,OBJECT_LIST_TYPE_PLAYER);
								max--;
								break;
							}
								
							case 9://基地
							{
								
								var baseMent:BaseMentObject =new  BaseMentObject(new BaseMent());
								
								baseMent.x = cell.x;
								baseMent.y=cell.y;
								
								baseMent.Group=OBJECT_CAMP_2;
								baseMent.objectListType =OBJECT_LIST_TYPE_PLAYER
								
								addObject(baseMent,OBJECT_LIST_TYPE_PLAYER);
							
								max--;
								break;
							}
								
							case 0: //空地
							{
								var r:Number =Math.random();
								
								if(r>0.3){
									var t:int =int(randRange(0,4));
									var enmey:EnmeyObject;
									
									switch(t){
										case 1:enmey =new EnmeyObject(new TANK_UI.Tank1());break;
										case 2:enmey =new EnmeyObject(new TANK_UI.Tank2());break;
										case 3:enmey =new EnmeyObject(new TANK_UI.Tank3());
								
											break;
										default:
											enmey =new EnmeyObject(new TANK_UI.Tank1());
											break;
									}
									
									enmey.x =cell.x;;
									enmey.y = cell.y;
									enmey.Group=OBJECT_CAMP_3;
									enmey.objectListType =OBJECT_LIST_TYPE_ENEMY
									
									addObject(enmey,OBJECT_LIST_TYPE_ENEMY);
						
									max--;
								}
							}
							default:
							{
								break;
							}
						}
					
					}
					
				}
			}
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
	}
}