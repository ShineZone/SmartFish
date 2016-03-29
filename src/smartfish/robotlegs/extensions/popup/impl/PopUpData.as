package smartfish.robotlegs.extensions.popup.impl
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import smartfish.robotlegs.extensions.popup.api.IPopUpWindow;
	import smartfish.robotlegs.extensions.popup.effects.IAppear;
	
	public class PopUpData
	{		
		
		public var id:String;
		
		public var owner:IPopUpWindow;
		
		public var modalWindow:Sprite;
		
		public var assetPath:String;
		
		public var appear:IAppear;
		
		/**
		 * 状态：0：未加载，1：正在加载，2：加载完成 
		 */		
		public var state:int;
		
		public function PopUpData()
		{
		}
		
		public function resizeHandler(event:Event):void
		{
			if (modalWindow && DisplayObject(owner).stage == DisplayObject(event.target).stage)
			{
				modalWindow.width  = DisplayObject(owner).stage.width;
				modalWindow.height = DisplayObject(owner).stage.height;
				modalWindow.x      = DisplayObject(owner).stage.x;
				modalWindow.y      = DisplayObject(owner).stage.y;
			}
		}
	}
}