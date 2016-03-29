package smartfish.managers.message
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public interface IMessageManager
	{
		function initlize(stage:DisplayObjectContainer,skin:MovieClip):void;
		function send(content:*,target:DisplayObject = null,distanceIn:Number = 80,distanceOut:Number = 100,skinWidth:int = 0,skinHeight:int = 0,transparent:Boolean = true):void;
		function play(dis:DisplayObject,target:DisplayObject,distanceIn:Number = 80,distanceOut:Number = 100):void;
	}
}