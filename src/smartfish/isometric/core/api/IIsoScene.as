/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午6:22:53
 **/
package smartfish.isometric.core.api
{
	import smartfish.pathfinding.astar.MapGrid;

	/**
	 * Isometric world scene 
	 * @author rayyee
	 */	
	public interface IIsoScene extends IIsoObject
	{
		function inSceneView( rect:Object ):Boolean
			
		function addChild( value : IIsoObject ):void;
		
		function removeChild( value : IIsoObject ):void
		
		function setChildIndex( obj:IIsoObject, depth:int ):void;
		
		function get displayListChildren():Array;

        function get viewRangeChildren():Array;
		
		function get grid():MapGrid;
		
	}
}