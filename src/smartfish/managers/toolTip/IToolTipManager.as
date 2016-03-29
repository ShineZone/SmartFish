/*
 * Copyright (c) 2013 rayyee. All rights reserved.
 * @author rayyee
 * Created 13-7-18 下午2:46
 */
package smartfish.managers.toolTip
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public interface IToolTipManager
	{
		function init(container:DisplayObjectContainer):void;
		function show(target:DisplayObject, content:*,direction:String = "top",duration:Number = 0, marginX:Number = 0,marginY:Number = 0,contentOffetX:Number = 0, contentOffetY:Number = 0):void;
		function setSkin(mov:MovieClip):void;
		function setStyle(bgColor:uint = 0xffffff,bgAlpha:Number = 1,borderColor:uint=0xffffff,borderAlpha:Number=1,borderThickNess:Number=1,ellipsSize:Number = 5,arrowSize:Number = 7):void;
		function hide():void;
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
	}
}