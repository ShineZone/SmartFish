/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午9:40:18
 **/
package smartfish.isometric.utils
{
	import smartfish.pathfinding.astar.AStar;

	public class IsoConfig
	{
		
		public static const Rotation_Clockwise:int = 90;
		public static const Rotation_Counterclockwise:int = -90;
		
		public static var SIZE:int = 40;
		public static var VIEW_WIDTH:Number = 760;
		public static var VIEW_HEIGHT:Number = 650;
		public static var VIEW_ZOOM:Number = 1.0;
		public static const ASTAR:AStar = new AStar();
		
		/**
		 * Constructor
		 **/
		public function IsoConfig()
		{
		}
		
//		public static function inView():Boolean
//		{
//			return (
//				_screenP.x < _pt.x + _sW &&	//leftA < rightB
//				_pt.x < _screenSize[0] &&	//leftB < rightA
//				_screenP.y < _pt.y + _sH && //topA < bottomB
//				_pt.y < _screenSize[1]		//topB < bottomA
//				);
//		}
	}
}