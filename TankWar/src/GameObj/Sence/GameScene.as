package GameObj.Sence
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import GameObj.Global.GlobalMgr;
	import GameObj.Object.GameObject;

	public class GameScene extends Sprite
	{
		//对象分组使用的常量
		protected static const OBJECT_LIST_TYPE_0:int=0;
		protected static const OBJECT_LIST_TYPE_1:int=1;
		protected static const OBJECT_LIST_TYPE_2:int=2;
		protected static const OBJECT_LIST_TYPE_3:int=3;
		protected static const OBJECT_LIST_TYPE_4:int=4;
		protected static const OBJECT_LIST_TYPE_5:int=5;
		protected static const OBJECT_LIST_TYPE_6:int=6;
		protected static const OBJECT_LIST_TYPE_7:int=7;
		
		public static const OBJECT_LIST_TYPE_MAX:int=10;
		
		public static const CALLBACK_ADD_OBJECT:int=1;
		public static const CALLBACK_REMOVE_OBJECT:int=2;
	
		/**
		 * 舞台中的对象列表
		 */
		protected var objectList:Vector.<Array>;
		
		
		
		protected var LayerList:Vector.<Sprite>;
		
		/**
		 * 创建游戏基本场景需要传递基本舞台这个参数
		 * @param        _stage        舞台
		 */
		public function GameScene(_stage:Stage) 
		{
			GlobalMgr.stage = _stage;
			GlobalMgr.scene = this;
			
			LayerList  =  new  Vector.<Sprite>();
			objectList = new Vector.<Array>(OBJECT_LIST_TYPE_MAX,true);
			GlobalMgr.stage.addEventListener(Event.ENTER_FRAME, render);
		}
		
		
		/**
		 * 向游戏世界中增加新的游戏对象
		 * @param        obj
		 */
		public function addLayer(obj:Sprite):void
		{
			if (LayerList.indexOf(obj) != -1) return; // 不重复添加
			LayerList.push(obj);
			addChild(obj);
		}
		
		/**
		 * 从游戏世界中删除游戏对象
		 * @param        obj
		 */
		public function removeLayer(obj:Sprite):void
		{
			var id:int = LayerList.indexOf(obj);
			if (id == -1) return;
			LayerList.splice(id,1);
			removeChild(obj);
		}
		
		/**
		 * 向游戏世界中增加新的游戏对象
		 * @param        obj
		 */
		public function addObject(obj:GameObject,OBJECT_LIST_TYPE_INT:int=0):void
		{
			if(objectList[OBJECT_LIST_TYPE_INT]==null)
				objectList[OBJECT_LIST_TYPE_INT] = new Array;
						
			if (objectList[OBJECT_LIST_TYPE_INT].indexOf(obj) != -1) return; // 不重复添加
			objectList[OBJECT_LIST_TYPE_INT].push(obj);
			addChild(obj);
			
			GlobalMgr.callBackDispatcher.dispatchCallBack(CALLBACK_ADD_OBJECT,obj);
		}
		
		/**
		 * 从游戏世界中删除游戏对象
		 * @param        obj
		 */
		public function removeObject(obj:GameObject,OBJECT_LIST_TYPE_INT:int=0):void
		{
			if(objectList[OBJECT_LIST_TYPE_INT]==null)
				objectList[OBJECT_LIST_TYPE_INT] = new Array;
			
			var id:int = objectList[OBJECT_LIST_TYPE_INT].indexOf(obj);
			if (id == -1) return;
			objectList[OBJECT_LIST_TYPE_INT].splice(id,1);
			removeChild(obj);
			obj.Die();
			
			GlobalMgr.callBackDispatcher.dispatchCallBack(CALLBACK_REMOVE_OBJECT,obj);
		}
		
		/**
		 * 游戏对象列表
		 */
		public function  AllObject(OBJECT_LIST_TYPE_INT:int=0):Array{
			if(objectList[OBJECT_LIST_TYPE_INT]==null)
				objectList[OBJECT_LIST_TYPE_INT] = new Array;
			
			return objectList[OBJECT_LIST_TYPE_INT];
		}
		
		
		/**
		 * 游戏对象列表
		 */
		public function get AllLayer():Vector.<Sprite>{
			return LayerList;
		}
		
		
		/**
		 * 渲染函数，通过本函数逐个计算游戏中各对象的动作
		 */
		public function render(e:Event):void
		{
			for (var i:int = 0; i <OBJECT_LIST_TYPE_MAX; i++) 
			{
				var objList:Array =objectList[i];
				if(objList){
					for each(var obj:GameObject in objList) 
					obj.Do();
				}
			}
			
		}
	}
}