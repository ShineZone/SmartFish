/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午2:44:31
 **/
package smartfish.isometric.geometry
{
	import flash.geom.Point;

	/**
	 * Isometric 坐标系</br>
	 * 正交投影
	 * </br>
	 * -----------------Z						</br>
	 * -----------------#						</br>
	 * -----------------#						</br>
	 * -----------------#						</br>
	 * -----------------#						</br>
	 * --------------#-----#					</br>
	 * -----------#-----------#					</br>
	 * --------#-----------------#				</br>
	 * ----Y #----------------------# X			</br>
	 * @author rayyee
	 */	
	public class IsoMath
	{
		/**
		 * z纵深值
		 */
		public static const Z_CORRECT:Number = Math.cos( -Math.PI / 6 ) * Math.SQRT2;
		
		/**
		 * Constructor
		 **/
		public function IsoMath()
		{
			
		}
		
		/**
		 * 三维转二维
		 * @param    pos   三维点对象
		 */
		public static function isoToScreen(pos:IsoPoint):Point
		{
			var screenX:Number = pos.x - pos.y;
			var screenY:Number = pos.z * Z_CORRECT + (pos.x + pos.y) * .5;
			return new Point(screenX, screenY);
		}
		
		/**
		 * 二维转三维
		 * @param    pos   二维点对象
		 */
		public static function screenToIso(point:Point):IsoPoint
		{
			var xpos:Number = point.y + point.x / 2;
			var ypos:Number = point.y - point.x / 2;
			var zpos:Number = 0;
			return new IsoPoint(xpos, ypos, zpos);
		}
		
		/**
		 * rotate matrix
		 * cos(a), -sin(a)
		 * sin(a), cos(a)
		 * 
		 * x
		 * 
		 * isoObject matrix
		 * 1, 0
		 * 0, -1
		 * 
		 * @param radian
		 * @return 
		 */		
		public static function rotate( vx:int, vy:int, radian:Number ):Array
		{
			var cosA:Number = Math.cos( radian );
			var sinA:Number = Math.sin( radian );
			var m11:Number = vx * cosA + 0 * -sinA;
			var m12:Number = (vx * sinA) + (0 * cosA);
			var m21:Number = 0 * cosA + (vy * -sinA);
			var m22:Number = (0 * sinA) + (vy * cosA);
			return [
				Math.round(m11 + m21),
				Math.round(m12 + m22)
			];
		}
	}
}