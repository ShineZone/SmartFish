/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午12:33:44
 **/
package smartfish.isometric.utils
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import smartfish.isometric.core.IsoView;

	public class IsoViewDragger
	{
		private var _initialized:Boolean;
		private var _view:IsoView;
		private var _isDown:Boolean;
		private var _downMouseX:Number;
		private var _downMouseY:Number;
		private var _downViewX:Number;
		private var _downViewY:Number;
		private var _tolerantDragSize:Number;
		
		/**
		 * Constructor
		 **/
		public function IsoViewDragger( view:IsoView, tds:Number = 5 )
		{
			_tolerantDragSize = tds;
			_view = view;
			if ( _view.stage )
			{
				initializationListener();
			}
			else
			{
				_view.addEventListener(Event.ADDED_TO_STAGE, initializationListener);
			}
		}
		
		private function initializationListener( e : Event = null ):void
		{
			_initialized = true;
			_view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//			_view.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseOut);
			_view.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		public function drag():void
		{
			if ( !_initialized ) initializationListener();
		}
		
		public function stop():void
		{
			_initialized = false;
			_view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//			_view.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			_view.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseOut);
			_view.removeEventListener(Event.ENTER_FRAME, onRender);			
		}
		
		private function onRender(event:Event):void
		{
			if ( _isDown )
			{
				var movex : Number = _view.mouseX - _downMouseX;
				var movey : Number = _view.mouseY - _downMouseY;
				if ( Math.abs( movex ) > _tolerantDragSize || Math.abs( movey ) > _tolerantDragSize )
				{
					_view.panTo( _downViewX + movex, _downViewY + movey );
				}
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_downViewX = _view.currentX;
			_downViewY = _view.currentY;
			_downMouseX = _view.mouseX;
			_downMouseY = _view.mouseY;
			_isDown = true;
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			_isDown = false;
		}
	}
}