/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:39:39
 **/
package smartfish.pathfinding.astar
{
	import smartfish.pathfinding.astar.evaluation.EvaluationAlgorithms;

	public class AStar
	{
		private var _openHeap : BinaryHeap;
		private var _touched : Vector.<AStarNode>;
		private var _grid : Vector.<Vector.<AStarNode>>;
		
		/**
		 * Constructor
		 **/
		public function AStar( grid : Vector.<Vector.<AStarNode>> = null )
		{
			_touched = new Vector.<AStarNode>();
			_grid = grid;
		}
		
		/**
		 * 
		 * DEBUG ONLY.
		 */
		public function get evaluatedTiles () : Vector.<AStarNode> 
		{
			return _touched;
		}
		
		public function search( start : AStarNode, end:AStarNode, g : Vector.<Vector.<AStarNode>> = null ) : Vector.<AStarNode> 
		{
			if ( g ) grid = g;
			
			if ( _openHeap )
			{
				var k : int = _touched.length-1;
				while ( k > -1 )
				{
					_touched[k].f=0;
					_touched[k].g=0;
					_touched[k].h=0;
					_touched[k].closed = false;
					_touched[k].visited = false;
					_touched[k].debug = "";
					_touched[k].parent = null;
					k--;
				}
				
				_touched = new Vector.<AStarNode>();
				_openHeap.reset();
			}
			else
			{
				_openHeap = new BinaryHeap( function(node:AStarNode):Number{return node.f;} );
			}
			
			_openHeap.push(start);
			
			
			while ( _openHeap.size > 0 )
			{
				// Grab the lowest f(x) to process next.  Heap keeps this sorted for us.
				var currentNode : AStarNode = _openHeap.pop();
				
				// End case -- result has been found, return the traced path
				if (currentNode.position.x == end.position.x && currentNode.position.y == end.position.y) 
				{
					var curr : AStarNode = currentNode;
					var ret : Vector.<AStarNode> = new Vector.<AStarNode>();
					while (curr.parent) 
					{
						ret.push(curr);
						curr = curr.parent;
					}
					return ret.reverse();
				}
				
				// Normal case -- move currentNode from open to closed, process each of its neighbors
				currentNode.closed = true;
				_touched.push(currentNode);
				
				var neighbors : Vector.<AStarNode> = neighbors(_grid, currentNode);
				var il : uint = neighbors.length;
				var neighbor : AStarNode;
				for (var i: int =0; i < il; i++) 
				{
					neighbor = neighbors[i];
					// not a valid node to process, skip to next neighbor
					if (neighbor.closed || neighbor.isWall) continue;
					
					// g score is the shortest distance from start to current node, we need to check if
					//   the path we have arrived at this neighbor is the shortest one we have seen yet
					// 1 is the distance from a node to it's neighbor.  This could be variable for weighted paths.
					var gScore : Number = currentNode.g + 1;
					var beenVisited : Boolean = neighbor.visited;
					if ( !beenVisited )
					{
						_touched.push(neighbor);
					}
					if ( beenVisited == false || gScore < neighbor.g) 
					{
						
						// Found an optimal (so far) path to this node.  Take score for node to see how good it is.
						neighbor.visited = true;
						neighbor.parent = currentNode;
						neighbor.h = neighbor.h || EvaluationAlgorithms.manhattan2(neighbor.position, end.position);
						neighbor.g = gScore;
						neighbor.f = neighbor.g + neighbor.h;
						//neighbor.debug = "F: " + neighbor.f + "<br />G: " + neighbor.g + "<br />H: " + neighbor.h;
						
						if (!beenVisited) 
						{
							// Pushing to heap will put it in proper place based on the 'f' value.
							_openHeap.push(neighbor);
						}
						else 
						{
							// Already seen the node, but since it has been rescored we need to reorder it in the heap
							_openHeap.rescoreElement(neighbor);
						}
					}
				}
			}
			
			// No result was found -- empty array signifies failure to find path
			return new Vector.<AStarNode>();
		}
		
		
		
		private function neighbors( grid : Vector.<Vector.<AStarNode>> , node : AStarNode, allowDiagonal : Boolean = false ) : Vector.<AStarNode> 
		{
			var ret : Vector.<AStarNode> = new Vector.<AStarNode>();
			var x : Number = node.position.x;
			var y : Number = node.position.y;
			
			try{
				if( grid[x-1] && grid[x-1][y]) {
					ret.push(grid[x-1][y]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			try{
				if(grid[x+1] && grid[x+1][y]) {
					ret.push(grid[x+1][y]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			try{
				if(grid[x] && grid[x][y-1]) {
					ret.push(grid[x][y-1]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			try{
				if(grid[x] && grid[x][y+1]) {
					ret.push(grid[x][y+1]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			
			//diags
			//diags
			if ( allowDiagonal ){
				try{
					if ( !grid[x][y-1].isWall || !grid[x+1][y].isWall ){		
						ret.push(grid[x+1][y-1]); //up right
					}
				}catch(e:ReferenceError){}catch(e:RangeError){}
				try{
					if ( !grid[x+1][y].isWall || !grid[x][y+1].isWall ){
						ret.push(grid[x+1][y+1]); //down right
					}
				}catch(e:ReferenceError){}catch(e:RangeError){}
				try{
					if ( !grid[x-1][y].isWall || !grid[x][y+1].isWall ){
						ret.push( grid[x-1][y+1]  ); //down left
					}
					
				}catch(e:ReferenceError){}catch(e:RangeError){}
				try{
					if ( !grid[x-1][y].isWall || !grid[x][y-1].isWall ){
						ret.push( grid[x-1][y-1] );//up left
					}
				}catch(e:ReferenceError){}catch(e:RangeError){}
			}
			return ret;
		}

		public function set grid(value:Vector.<Vector.<AStarNode>>):void
		{
			_grid = value;
		}


	}
}