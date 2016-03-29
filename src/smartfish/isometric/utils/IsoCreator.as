/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午10:24:14
 **/
package smartfish.isometric.utils
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import smartfish.isometric.geometry.IsoMath;
	import smartfish.isometric.geometry.IsoPoint;
	import smartfish.utils.ColorUtil;
	import smartfish.utils.MathUtil;

	public class IsoCreator
	{
		/**
		 * Constructor
		 **/
		public function IsoCreator()
		{
			
		}
		
		/**
		 * 创建一个正方形平面的Isometric tile
		 * @param size
		 * @param color
		 * @param isFill
		 * @return 
		 */		
		public static function createSquarePlane( size:Number, color:uint = 0xee55ee, isFill:Boolean = false ):Shape
		{
			var _shape:Shape = new Shape();
			
			var halfSize:Number = size >> 1;
			if ( isFill ) _shape.graphics.beginFill( color );
			else _shape.graphics.lineStyle( 1, color );
			_shape.graphics.drawPath
			(
				Vector.<int>([
					GraphicsPathCommand.MOVE_TO, 
					GraphicsPathCommand.LINE_TO, 
					GraphicsPathCommand.LINE_TO, 
					GraphicsPathCommand.LINE_TO, 
					GraphicsPathCommand.LINE_TO]),
				Vector.<Number>([
					-size, 			0, 
					0, 		-halfSize, 		
					size, 	0, 	
					0, 		halfSize, 
					-size, 			0
				])
			);
			if ( isFill ) _shape.graphics.endFill();
			
			return _shape;
		}
		
		/**
		 * 创建一个立方体的 Isometric tile
		 * @param w
		 * @param h
		 * @param l
		 * @param color
		 * @param isFill
		 * @return 
		 */		
		public static function createBox( w:Number, h:Number, l:Number, color:uint = 0xee55ee, isFill:Boolean = false ):Shape
		{
			var _shape:Shape = new Shape();
			
			var p3:IsoPoint = new IsoPoint;

			var up:Point = IsoMath.isoToScreen( p3 );
			
			p3.y = h;
			var left:Point = IsoMath.isoToScreen( p3 );
			
			p3.y = 0; p3.x = w;
			var right:Point = IsoMath.isoToScreen( p3 );
			
			p3.x = w; p3.y = h;
			var down:Point = IsoMath.isoToScreen( p3 );
			
			var upFlag:Number = l * IsoMath.Z_CORRECT + IsoConfig.SIZE * .5;
			
			//up plane
			createBoxPlane(_shape.graphics, Vector.<Number>([
				up.x, 		up.y - upFlag, 
				left.x, 	left.y - upFlag, 		
				down.x, 	down.y - upFlag, 	
				right.x, 	right.y - upFlag, 
				up.x, 		up.y - upFlag,
			]), color, -1, isFill);
			
			//left plane
			createBoxPlane(_shape.graphics, Vector.<Number>([
				left.x, 	left.y - upFlag, 
				left.x, 	left.y - IsoConfig.SIZE * .5, 
				down.x, 	down.y - IsoConfig.SIZE * .5,
				down.x, 	down.y - upFlag,
				left.x, 	left.y - upFlag,
			]), color, 255, isFill);

			//right plane
			createBoxPlane(_shape.graphics, Vector.<Number>([
				right.x, 	right.y - upFlag, 
				right.x, 	right.y - IsoConfig.SIZE * .5,
				down.x, 	down.y - IsoConfig.SIZE * .5,
				down.x, 	down.y - upFlag,
				right.x, 	right.y - upFlag,
			]), color, 0, isFill);
			
			return _shape;
		}
		
		private static function createBoxPlane( g:Graphics, drawData:Vector.<Number>, color:uint, colorTrans:int = 0, isFill:Boolean = false ):void
		{
			var newColor:uint;
			var rgb:Array;
			if (colorTrans < 0)
			{
				newColor = color;
			}
			else
			{
				rgb = ColorUtil.toRGBArray(color);
				rgb[0] = MathUtil.lerp( rgb[0], colorTrans, .2 );
				rgb[1] = MathUtil.lerp( rgb[1], colorTrans, .2 );
				rgb[2] = MathUtil.lerp( rgb[2], colorTrans, .2 );
				newColor = ColorUtil.toRGBCode(rgb[0], rgb[1], rgb[2]);
			}
			
			if ( isFill ) g.beginFill( newColor, 1 );
			else g.lineStyle( 1, color );
			g.drawPath(
				Vector.<int>([
					GraphicsPathCommand.MOVE_TO,
					GraphicsPathCommand.LINE_TO,
					GraphicsPathCommand.LINE_TO,
					GraphicsPathCommand.LINE_TO,
					GraphicsPathCommand.LINE_TO]), 
				drawData, 
				GraphicsPathWinding.NON_ZERO
			);
			if ( isFill ) g.endFill();
		}
	}
}