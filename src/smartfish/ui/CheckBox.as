/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午11:06:28
 **/
package smartfish.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class CheckBox extends EventDispatcher
	{
		
		private var _selectedEvent:Event;
		private var _skin:MovieClip;
		private var _checkStatus:Boolean;
		
		/**
		 * Constructor
		 **/
		public function CheckBox( skin : MovieClip )
		{
			_selectedEvent = new Event(Event.SELECT);
			_skin = skin;
			changeStatus(false);
			_skin.addEventListener(MouseEvent.CLICK, onClickCheckBox);
		}
		
		private function onClickCheckBox(event:MouseEvent):void
		{
			changeStatus(!_checkStatus);
			dispatchEvent(_selectedEvent);
		}
		
		private function changeStatus(value:Boolean):void
		{
			_checkStatus = value;
			_checkStatus ? _skin.gotoAndPlay("Selectd") : _skin.gotoAndPlay("Notselectd");
		}

		public function get checkStatus():Boolean
		{
			return _checkStatus;
		}
		
	}
}