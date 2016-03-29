package smartfish.ui.tabList
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;

	public interface ITabItem extends IEventDispatcher
	{
		function setSkin(mov:MovieClip):void
		function set data(o:Object):void;
		function get data():Object;
		
		function get x():Number;
		function get y():Number;
		function get width():Number;
		function get height():Number;
		function get visible():Boolean;
		
		function set x(value:Number):void;
		function set y(value:Number):void;
		function set width(value:Number):void;
		function set height(value:Number):void;
		function set visible(value:Boolean):void;
		function set buttonMode(value:Boolean):void;
		
		function onMouseOver():void;
		function onMouseOut():void;
		function onSelect():void;
	}
}