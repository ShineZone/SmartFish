/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:41:15
 **/
package smartfish.pathfinding.astar
{
	import flash.geom.Point;

	public class AStarNode
	{
		//该点到终点的损耗
		internal var h : int;
		//F=G+H
		internal var f : int;
		//启点到该点的损耗
		internal var g : int;
		
		internal var parent : AStarNode;
		internal var next : AStarNode;
		
		internal var visited : Boolean;
		internal var closed : Boolean;
		
		internal var _position : Point;
		
		public var isWall : Boolean;
		
		public var debug : String;
		
		/**
		 * Constructor
		 **/
		public function AStarNode()
		{
			_position = new Point;
		}
		
		private function reset():void
		{
			h = f = g = 0;
			visited = closed = isWall = false;
			parent = next = null;
		}

		public function get position():Point
		{
			return _position;
		}

	}
}