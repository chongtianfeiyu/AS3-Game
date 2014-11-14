package FlixeGame.flixeGame0
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	/**
	 *游戏场景 
	 */	
	public class PlayState extends FlxState
	{
		
		/*
		* Tile地图格子的宽度
		*/
		private const TILE_WIDTH:int = 12;
		/*
		* Tile地图格子的高度
		*/
		private const TILE_HEIGHT:int = 12;
		
		/*
		* 动作状态运行
		*/
		private const ACTION_GO:int = 1;
		/*
		* 动作状态-停止
		*/
		private const ACTION_IDLE:int = 0;
		
		/*
		* 格子资源
		*/
		[Embed(source = 'assets/tiles.png')] private var _imgTiles:Class;
		/*
		* 格子地图Default配置
		*/
		[Embed(source = 'assets/pathfinding_map.txt', mimeType = "application/octet-stream")] private var _dataMap:Class;
		/*
		* 格子地图对象
		*/
		private var _map:FlxTilemap;
		
		/*
		* 全局的层
		*/
		private var _goal:FlxSprite;
		
		/*
		* 一个移动的单位
		*/
		private var _unit:FlxSprite;
		/*
		* Unit action
		*/
		private var _action:int;
		
		
		/////////////右侧操作栏///////////////////////
		/*
		* Button to move unit to Goal
		*/
		private var _btnFindPath:FlxButton;
		/*
		* Button to stop unit
		*/
		private var _btnStopUnit:FlxButton;
		/*
		* Button to reset unit to start point
		*/
		private var _btnResetUnit:FlxButton;
		/*
		* Button quit
		*/
		private var _btnQuit:FlxButton;
		/*
		* Legend
		*/
		private var _legends:FlxText;
		
		/////////////构造///////////////////////
		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{
			FlxG.framerate =35;
			FlxG.flashFramerate = 35;
			
			//设置地图对象
			_map = new FlxTilemap();
			_map.loadMap(new _dataMap, _imgTiles, TILE_WIDTH, TILE_HEIGHT, 0, 1);
			add(_map);
			
			//设置全局对象
			_goal = new FlxSprite(_map.width - TILE_WIDTH, _map.height - TILE_HEIGHT).makeGraphic(TILE_WIDTH, TILE_HEIGHT, 0xffffff00);
			add(_goal);
			
			//设置一个操作对象
			_unit  = new FlxSprite(0, 0).makeGraphic(TILE_WIDTH - 2, TILE_HEIGHT - 2, 0xffff0000);
			_action = ACTION_IDLE;
			add(_unit);
			
			//Add button move to goal to PlayState
			_btnFindPath = new FlxButton(320, 10, "Move To Goal", moveToGoal);
			add(_btnFindPath);
			
			//Add button stop unit to PlayState
			_btnStopUnit = new FlxButton(320, 30, "Stop Unit", stopUnit);
			add(_btnStopUnit);
			
			//Add button reset unit to PlayState
			_btnResetUnit = new FlxButton(320, 50, "Reset Unit", resetUnit);
			add(_btnResetUnit);
			
			//Add button quit to PlayState
			_btnQuit = new FlxButton(320, 70, "Quit", backToMenu);
			add(_btnQuit);
			
			//Add label for legend
			_legends = new FlxText(320, 90, 100, "Click in map to\nplace or\nremove tile\n\nLegends:\nRed:Unit\nYellow:Goal\nBlue:Wall\nWhite:Path");
			add(_legends);
			
			super.create();
		}
		
		override public function draw():void
		{
			super.draw();
			
			//To draw path
			if (_unit.path != null)
			{
				_unit.path.drawDebug();
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			_map = null;
			_goal = null;
			_unit = null;
			_btnFindPath = null;
			_btnStopUnit = null;
			_btnResetUnit = null;
			_btnQuit = null;
			_legends = null;
		}
		
		
		override public function update():void
		{
			super.update();
			
			//Set unit to collide with map
			FlxG.collide(_unit, _map);
			
			//Check mouse pressed and unit action
			if (FlxG.mouse.justPressed() && _action == ACTION_IDLE) 
			{
				//Get data map coordinate
				var mx:int = FlxG.mouse.screenX / TILE_WIDTH;
				var my:int = FlxG.mouse.screenY / TILE_HEIGHT;
				
				//Change tile toogle
				_map.setTile(mx, my, 1 - _map.getTile(mx, my), true);
			}
			
			//Check if reach goal
			if (_action == ACTION_GO)
			{
				if (_unit.pathSpeed == 0)
				{
					stopUnit();
				}
			}
		}
		
		////////////////////事件///////////////////////////////////////
		private function backToMenu():void
		{
			//Back to MenuState
			FlxG.switchState(new FlixeGame.flixeGame0.MenuState);
		}
		
		private function resetUnit():void
		{
			//Reset _unit position
			_unit.x = 0;
			_unit.y = 0;
			
			//Stop unit
			if (_action == ACTION_GO)
			{
				stopUnit();
			}
		}
		
		private function stopUnit():void
		{
			//Stop unit and destroy unit path
			_action = ACTION_IDLE;
			_unit.stopFollowingPath(true);
			_unit.velocity.x = _unit.velocity.y = 0;
		}
		
		private function moveToGoal():void
		{
			if(_action==ACTION_IDLE){
				//首先计算出路径
				var path:FlxPath=_map.findPath(new FlxPoint(_unit.x + _unit.width / 2, _unit.y + _unit.height / 2),new FlxPoint(_goal.x + _goal.width / 2, _goal.y + _goal.height / 2),true,false);
				//给予单位路径
				if(!path)return;
				_unit.followPath(path);
				_action = ACTION_GO;
			}
		}
		
	}
}