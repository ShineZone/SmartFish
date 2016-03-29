package smartfish.spritesheet
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * Luke 
	 * @author chenyonghua
	 * 
	 */	
	public class SpriteSheetRender
	{
		protected static var _instance:SpriteSheetRender;		
		private var innerList:Vector.<ISpriteSheet>
		private var _tick:Sprite;
		private var _timeScale:Number = 1;
		private var lastTime:Number    = -1;
		private var dirtyList:Array;
		public function SpriteSheetRender(singleton:SingletonEnforcer)
		{
			innerList = new Vector.<ISpriteSheet>();
			
			_tick = new Sprite();
			dirtyList = [];
		}
		
		public function get timeScale():Number
		{
			return _timeScale;
		}

		public function set timeScale(value:Number):void
		{
			_timeScale = value;
		}

		/**
		 * 单例
		 * @return
		 */
		public static function getInstance():SpriteSheetRender {
			if (!_instance) {
				_instance = new SpriteSheetRender(new SingletonEnforcer());
			}
			return _instance;
		}
		
		private function enterFrameHandler(evt:Event):void{		
			var currentTime:Number = getTimer();
			if (lastTime < 0)
			{
				lastTime = currentTime;
				return;
			}
			var deltaTime:Number = Number(currentTime - lastTime) * _timeScale;
			var len:int = innerList.length;
			for (var i:int = 0; i < len; i++) 
			{
				innerList[i].onFrame(deltaTime/1000);
			}
			//remove the dirty list
			len = dirtyList.length;
			if(len>0)
			{
				for (var j:int = 0; j < len; j++) 
				{
					var index:int = innerList.indexOf(dirtyList[j]);
					if (index >= 0)	{
						innerList.splice(index, 1);
						if(innerList.length == 0){
							render = false;
						}
					}
				}
			}			
			lastTime = currentTime;
		}
		
		public function set render(value:Boolean):void	{
			if (value)	{
				if (!_tick.hasEventListener(Event.ENTER_FRAME))	{
					_tick.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
			}else 
			{
				_tick.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		public function add(inner:ISpriteSheet):void{
			if (innerList.indexOf(inner) >= 0)	{
				return;
			}
			innerList.push(inner);
			if(innerList.length > 0){
				render = true;
			}
		}
		
		public function remove(inner:ISpriteSheet):void	{
			dirtyList.push(inner);
		}		
	}
}
class SingletonEnforcer{
	
}