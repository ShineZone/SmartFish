package smartfish.robotlegs.extensions.popup.api
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	public interface IPopUpWindow extends IEventDispatcher
	{
		function initilize():void
		function onOpen(params:Object = null):void;
		function onOpenComplete():void;
		function onClose(params:Object = null):void;
		function onCloseComplete():void;
		
		function set domain(value:ApplicationDomain):void;
		function get domain():ApplicationDomain;
		function getMovieClip(clsName:String):MovieClip;
		function getClass(clsName:String):Class;
		
		function get body():DisplayObject;
		
		function get parent():DisplayObjectContainer;
	}
}