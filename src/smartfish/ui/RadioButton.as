/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午11:26:20
 **/
package smartfish.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class RadioButton extends EventDispatcher
	{
	
		private var _selectedEvent:Event;
		private var _radioStatus:Boolean;
		private var _skin:MovieClip;
		private var _groupName:String = "DefaultGroupName";
		private static var _group:Dictionary = new Dictionary();
		
		/**
		 * Constructor
		 **/
		public function RadioButton( skin:MovieClip, groupName:String = "DefaultGroupName" )
		{
			_selectedEvent = new Event(Event.SELECT);
			_groupName = groupName;
			
			_skin = skin;
			_skin.addEventListener(MouseEvent.MOUSE_UP, onClickRadioButton, false, int.MAX_VALUE);
			
			if (!_group[_groupName])
			{
				_group[_groupName] = [];
				setRadioSelected();
			}
			
			_group[_groupName].push(this);
			
		}
		
		public function relase():void
		{
			_skin.removeEventListener(MouseEvent.MOUSE_UP, onClickRadioButton);
			var _radioButtons:Array = _group[_groupName];
			if (_radioButtons)
			{
				var _index:int = _radioButtons.indexOf(this);
				if (_index != -1)
				{
					_radioButtons.splice(_index, 1);
				}
				if (_radioButtons.length)
				{
					_radioButtons[0].setRadioSelected();
				}
			}
		}
		
		private function onClickRadioButton(event:MouseEvent):void
		{
			setRadioSelected();
		}
		
		internal function setRadioSelected():void
		{
			if (!_radioStatus)
			{
				changeStatus(true);
				var _radioButtons:Array = _group[_groupName];
				for each (var button:RadioButton in _radioButtons)
				{
					if (button != this) 
						button.changeStatus(false);
				}
				dispatchEvent(_selectedEvent);
			}
		}
		
		private function changeStatus(value:Boolean):void
		{
			_radioStatus = value;
			_skin.mouseEnabled = !_radioStatus;
			_radioStatus ? _skin.gotoAndPlay("Selectd") : _skin.gotoAndPlay("NotSelectd");
		}
	}
}