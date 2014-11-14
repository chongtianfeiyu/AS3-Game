package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import UI.MCMapEditor;
	
	import loader.ResInfo;
	[SWF(width = "1280", height = "620", backgroundColor = "#000000")]
	public class MapEditor extends Sprite
	{
		private var _display:MovieClip;
		private var _topLayer:Sprite;
		
		public function MapEditor()
		{
			_topLayer = new Sprite();
			
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			GlobalMgr.stage =stage;
			stage.scaleMode= StageScaleMode.NO_SCALE;
			
			GlobalMgr.loderMgr.preload(new ResInfo("editor","../res/swc/mapEditor.swf",ResInfo.TYPE_SWF,function(data:*):void{

				_display =new UI.MCMapEditor();
				onLoaded();
			}))
		}
		
		private function onLoaded():void{
			addChild(_display);
			layout();
		}	
		
		private function layout():void{
	
		}
		
	}
}