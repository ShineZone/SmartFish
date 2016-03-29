/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午6:17:23
 **/
package smartfish.isometric.sort
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import smartfish.isometric.core.IsoObject;
	import smartfish.isometric.core.api.IIsoObject;
	import smartfish.isometric.core.api.IIsoScene;
	import smartfish.isometric.geometry.IsoPoint;

	public class DefaultSceneSort
	{
		
		// It's faster to make class variables & a method, rather than to do a local function closure
		private var depth:uint;
		private var visited:Dictionary = new Dictionary();
		private var scene:IIsoScene;
		private var dependency:Dictionary;
		
		/**
		 * Constructor
		 **/
		public function DefaultSceneSort()
		{
			
		}

        /*
        * 判断2个矩形是否有相交碰撞
        */
		private function intersect( a : Array, b:Array ):Boolean
		{
			return (
					a[0] < b[2] &&
					b[0] < a[2] &&
					a[1] < b[3] &&
					b[1] < a[3]
				);
		}
		
		public function renderScene(scene:IIsoScene):void
		{
			this.scene = scene;
			var startTime:uint = getTimer();
			dependency = new Dictionary();
			
			var children:Array = scene.viewRangeChildren;
			
			var max:uint = children.length;
			var rangeA:Array;
			var rangeB:Array;
			var layerA:int;
			for (var i:uint = 0; i < max; ++i)
			{
				//找出在objA后面的对象
				var behind:Array = [];
				var objA:IIsoObject = children[i];
//				var objAPosition:IsoPoint = ( objA as IsoObject ).isoPosition;
				
				rangeA = objA.isoRange;
				layerA = objA.layer;
				
//				var rightA:Number = objAPosition.x + (rangeA[0] + rangeA[2]) * IsoConfig.SIZE;
				var rightA:Number = rangeA[2];
//				var frontA:Number = objAPosition.y + (rangeA[1] + rangeA[3]) * IsoConfig.SIZE;
				var frontA:Number = rangeA[3];
//				var topA:Number = -objAPosition.z + objA.length;
				
				for (var j:uint = 0; j < max; ++j)
				{
					var objB:IIsoObject = children[j];
					var objBPosition:IsoPoint = (objB as IsoObject).isoPosition;
					rangeB = objB.isoRange;
					if ( i !== j )
					{
						if ( intersect(rangeA, rangeB) )
						{
							if ( objB.layer < layerA )
							{
								behind.push(objB);
							}
						}
						//非重叠情况
						else if 
						(
							(rangeB[2] <= rightA) 
							&&
							(rangeB[3] <= frontA)
//							&&
//							(-objBPosition.z < topA)
						)
						{
							behind.push(objB);
						}
					}
				}
				
				dependency[objA] = behind;
			}
			
			//trace("dependency scan time", getTimer() - startTime, "ms");
			
			// TODO - set the invalidated children first, then do a rescan to make sure everything else is where it needs to be, too?  probably need to order the invalidated children sets from low to high index
			
			// Set the childrens' depth, using dependency ordering
			depth = 0;
			for each (var obj:IIsoObject in children)
			if (true !== visited[obj])
				place(obj);
			
			// Clear out temporary dictionary so we're not retaining memory between calls
			visited = new Dictionary();
			
			// DEBUG OUTPUT
			
			//trace("--------------------");
			//for (i = 0; i < max; ++i)
			//	trace(dumpBounds(sortedChildren[i].isoBounds), dependency[sortedChildren[i]].length);
			
			//trace("scene layout render time", getTimer() - startTime, "ms (manual sort)");
		}
		
		/**
		 * Dependency-ordered depth placement of the given objects and its dependencies.
		 */
		private function place(obj:IIsoObject):void
		{
			visited[obj] = true;
			
			for each(var inner:IIsoObject in dependency[obj])
			if (true !== visited[inner])
				place(inner);
			
//			if (depth != obj.depth)
//			{
				scene.setChildIndex(obj, depth);
//			}
//			if (depth == obj.depth) trace("...........>>>", obj.x, obj.y, depth);
			
			++depth;
		}
	}
}