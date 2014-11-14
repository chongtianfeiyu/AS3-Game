package dqWorld.core.game0.avatar.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	
	import dqWorld.core.game0.ResConfig;
	import dqWorld.core.game0.globalMgr;
	
	import loader.ResInfo;
	
	/**
	 *位图形象加载器[加载器基本上都是根据游戏要求定制的]
	 * 加载方案，把信息存放于xml,把序列图(swf.png.jpg)存放在动作文件夹中
	 */	
	public class AvatarLoader extends EventDispatcher
	{
		
		//最大游戏动作
		private static const MAX_ACTION_TYPE:uint=11;
		
		//是否已加载完毕
		private var _isLoad:Boolean=false;
		private var _url:String;
		private var _actIdx:int;
		
		private var _wNum:uint;
		private var _hNum:uint;
		
		/**
		 *记录配置数据 
		 */		
		private var _matrixDatas:Array;
		public function get matrixDatas():Array{
			return _matrixDatas;
		}
		
		/**
		 *bitmap列表
		 */	
		private var _matrixBitmaps:Array;
		public function get matrixBitmaps():Array
		{
			return _matrixBitmaps;
		}

	
		private var _xmlUrl:String;
		private var _xmlLoader:URLLoader;
		private var _xml:XML;
		private var _bmd:BitmapData;

		public function set xml(value:XML):void
		{
			_xml = value;
		}
		

		public function AvatarLoader(avatarName:String,autoLoadRes:Boolean=true,onComplteFn:Function=null)
		{
			_url = ResConfig.resPath+avatarName;
			_matrixDatas=new Array();
			_matrixBitmaps=new Array();
			
			if(autoLoadRes){
				globalMgr.loderMgr.preload(new ResInfo("actonXml",_url+"/action.xml",ResInfo.TYPE_URL,onXmlLoadComplte));
			}
		}
		

		
		/*********************************/
		//XML处理[动作序列]
		/*********************************/
		private function onXmlLoadComplte(data:String):void
		{
			_xml =new XML(data);
			
			var imgPath:String = _xml.attribute("imagePath");
			var loaderInfo:LoaderInfo;
			
			globalMgr.loderMgr.preload(new ResInfo("actonPNG",_url+"/"+imgPath,ResInfo.TYPE_SWF,onSwfLoadComplte));
		}
		
		
		/*********************************/
		//动作资源处理
		/*********************************/
	
		protected function onSwfLoadComplte(data:*):void
		{
			fillArr((data as Bitmap).bitmapData);
		}
		
		protected function onResLoadProgress(event:Event):void
		{
			trace("loding");
		}
		
		public function fillArr(bmd:BitmapData):void{

			var mx:Matrix=new Matrix();
			var xmlList:XMLList = _xml.descendants("SubTexture");
			for each (var item:XML in xmlList) 
			{
				var idxs:Array =String(item.attribute("name")).split(' ');
				//受击区域
				var bittenArea:Array =item.attribute("bittenArea")?String(item.attribute("bittenArea")).split('|'):null;
				//攻击区域
				var hitArea:Array =item.attribute("hitArea")?String(item.attribute("hitArea")).split('|'):null;
				var cPoint:Array=[0,0];
				if(item.attribute("cX"))
					cPoint[0]=Number(item.attribute("cX"));
				if(item.attribute("cY"))
					cPoint[1]=Number(item.attribute("cY"));
				
				if(idxs.length!=2)return;
				
				 _bmd=new BitmapData(int(item.attribute("width")),int(item.attribute("height")),true,0);
				mx.tx=-1 *int(item.attribute("x"));
				mx.ty=-1 * int(item.attribute("y"));
				_bmd.draw(bmd, mx);
				
				if(_matrixDatas.length<=idxs[0]){
					_matrixDatas[idxs[0]]=new Array();
				}
				
				if(_matrixBitmaps.length<=idxs[0]){
					_matrixBitmaps[int(idxs[0])]=new Array();
				}
				
				_matrixDatas[int(idxs[0])][int(idxs[1])-10000]={width:_bmd.width,height:_bmd.height,bittenAreas:bittenArea,hitAreas:hitArea,cPoint:cPoint};
				_matrixBitmaps[int(idxs[0])][int(idxs[1])-10000]=_bmd;
			}
		}
	}
}