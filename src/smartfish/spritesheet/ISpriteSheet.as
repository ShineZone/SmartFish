package smartfish.spritesheet
{
	import flash.display.DisplayObject;

	/**
	 * Luke 
	 * @author chenyonghua
	 * 
	 */	
	public interface ISpriteSheet
	{
		function onFrame(deltaTime:Number):void
		function dispose():void;
		function get displayObject():DisplayObject;
		function get isComplete():Boolean;
		function get currentFrame():int;
		function get totalFrames():int;
		function get currentFrameLabel():String;
		function get interactiveActive():Boolean;
		function set interactiveActive(value:Boolean):void;
		function get alphaTolerance() : uint;
		function set alphaTolerance(value : uint) : void;
		function get fps():int;
		function set fps(value:int):void;
		
		function play():void;
		function stop():void;
		function gotoAndStop(frame:int,scene:String=null):void;
		function gotoAndPlay(frame:int,scene:String=null):void;
	}
}