package smartfish.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 滚动条 
	 * @author Ray Yee
	 */	
	public class ScrollBar
	{
		//滚动条的方向
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		private var _orientation:String;
		//滚轮
		private var _mWheel:Sprite;
		//滚动条整体
		private var _mBar:MovieClip;
		//滚动区域
		private var _barRect:Rectangle;
		//滚动触发
		private var _scrollListener:Function;
		
		/**
		 * Constructor 
		 * @param bar
		 * @param wheel
		 * @param orientation
		 */		
		public function ScrollBar(bar:MovieClip, wheel:Sprite, orientation:String = "vertical")
		{
			_mBar = bar;
			_barRect = _mBar.getBounds(_mBar);
			_orientation = orientation;
			_mWheel = wheel;
			_mWheel.mouseChildren = false;
			_mWheel.buttonMode = true;
			_mWheel.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			if (orientation == VERTICAL)
			{
				_barRect.width = 0;
				_barRect.height = _barRect.height - wheel.height;
				_mWheel.y = _barRect.y;
			}
			else
			{
				_barRect.height = 0;
				_barRect.width = _barRect.width - wheel.width;
				_mWheel.x = _barRect.x;
			}
			super();
		}
		
		/**
		 * 指定滚动条位置 
		 * @param value				比例值0-1
		 */		
		public function setScrollPostition(value:Number):void
		{
			if (_orientation == VERTICAL)
			{
				_mWheel.y = _barRect.y + _barRect.height * value >> 0;
			}
			else
			{
				_mWheel.x = _barRect.x + _barRect.width * value >> 0;
			}
		}
		
		/**
		 * 获取当前滚动条的位置 
		 * @return 				比例值0-1
		 */		
		public function getScrollPostition():Number
		{
			if (_orientation == VERTICAL)
			{
				return _mWheel.y / _barRect.height;
			}
			else
			{
				return _mWheel.x / _barRect.width;
			}
		}
		
		/**
		 * 添加一个在滚动条触发的时候侦听器 
		 * @param value
		 */		
		public function addScrollListener(value:Function):void
		{
			_scrollListener = value;
		}
		
		private function onDrag(event:MouseEvent):void
		{
			var _stage:Stage = _mWheel.stage;
			_mBar.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			_mBar.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			_mWheel.startDrag(false, _barRect);
		}
		
		private function onSlide(event:MouseEvent):void
		{
			if (_scrollListener == null) return;
			if (_orientation == VERTICAL)
			{
				_scrollListener(_mWheel.y / _barRect.height);
			}
			else
			{
				_scrollListener(_mWheel.x / _barRect.width);
			}
		}
		
		private function onDrop(event:MouseEvent):void
		{
			var _stage:Stage = _mWheel.stage;
			_mBar.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			_mBar.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			_mWheel.stopDrag();
		}
	}
}