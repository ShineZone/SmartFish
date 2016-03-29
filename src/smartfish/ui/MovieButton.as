/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:19:34
 **/
package smartfish.ui
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class MovieButton extends EventDispatcher
	{
		
		private var _skin:MovieClip;
		
		/**
		 * Constructor
		 **/
		public function MovieButton( skin : MovieClip )
		{
			_skin = skin;
			_skin.stop();
			
			_skin.buttonMode 	= true;
			_skin.mouseChildren = false;
			_skin.tabChildren 	= false;
			_skin.tabEnabled 	= false;
			
			_skin.addEventListener(MouseEvent.ROLL_OVER, 	onMouseOverHandler);
			_skin.addEventListener(MouseEvent.ROLL_OUT, 	onMouseOutHandler);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDownHandler);
			_skin.addEventListener(MouseEvent.MOUSE_UP, 	onMouseUpHandler);
			
		}
		
		private function onMouseUpHandler(event:MouseEvent):void
		{
			if ( _skin.mouseEnabled )
			{
				_skin.gotoAndPlay("Over");
				dispatchEvent(event);
			}
		}
		
		private function onMouseDownHandler(event:MouseEvent):void
		{
			_skin.gotoAndPlay("Down");
		}
		
		private function onMouseOutHandler(event:MouseEvent):void
		{
			if ( _skin.mouseEnabled )
			{
				_skin.gotoAndPlay("Out");
			}
		}
		
		private function onMouseOverHandler(event:MouseEvent):void
		{
			_skin.gotoAndPlay("Over");
		}
	}
}