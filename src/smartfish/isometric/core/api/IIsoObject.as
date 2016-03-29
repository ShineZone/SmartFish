/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午3:40:45
 **/
package smartfish.isometric.core.api
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import smartfish.isometric.core.IsoNode;

	public interface IIsoObject
	{
		function get x():Number;
		function set x( value:Number ):void;
		
		function get y():Number;
		function set y( value:Number ):void;
		
		function get z():Number;
		function set z( value:Number ):void;
		
//		function get width():int;
//		function set width( value:int ):void;
		
//		function get height():int;
//		function set height( value:int ):void;
		
		function get length():int;
//		function set length( value:int ):void;
		
		function get layer():int;
		function set layer(value:int):void;
		
		function get isoScene():IIsoScene;
		function set isoScene(value:IIsoScene):void;
		
		function get screenPosition():Point;
		
		/**
		 * @private 
		 */			
		function get depth():int;
		function set depth(value:int):void;
		
		function get walkable():Boolean;
		function set walkable(value:Boolean):void;
		
		function get isoNodes():Vector.<IsoNode>;
		
		function get screenRange():Object;
		function get isoRange():Array;
		
		function set parentContainer( value:Sprite ):void;
		
		function renderer():void;
		
		function dispose():void;
		
		/**
		 * 渲染坐标 
		 */		
		function rendererPosition():void;
		
		/**
		 * 贴图容器 
		 * @return 
		 */		
		function get container():Sprite;
	}
}