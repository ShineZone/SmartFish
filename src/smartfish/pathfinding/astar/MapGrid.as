/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午10:18:00
 **/
package smartfish.pathfinding.astar
{

	/**
	 * 地图的网格数据 用于寻路等 
	 * @author rayyee
	 */	
	public class MapGrid
	{
		
		private var row:int;
		private var column:int;
		private var _grid : Vector.<Vector.<AStarNode>>;
		
		/**
		 * Constructor
		 **/
		public function MapGrid( x:int, y:int, cls:Class = null )
		{
			column = x;
			row = y;
			
			cls ||= AStarNode;
			
			_grid = new Vector.<Vector.<AStarNode>>(column);
			for (var i:int = 0; i < column; i += 1)
			{
				_grid[i] = new Vector.<AStarNode>(row);
				for (var j:int = 0; j < row; j += 1)
				{
					_grid[i][j] = new cls();
					_grid[i][j]._position.x = i;
					_grid[i][j]._position.y = j;
				}
			}
		}
		
		public function getNode( x:int, y:int ):AStarNode
		{
			if ( x < 0 || y < 0 || x >= column || y >= row ) throw new RangeError();
			return _grid[x][y];
		}

		public function get nodes():Vector.<Vector.<AStarNode>>
		{
			return _grid;
		}

	}
}