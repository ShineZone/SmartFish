/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午4:30:24
 **/
package smartfish.isometric.extensions.pathfinding.api
{
	import org.osflash.signals.Signal;

	public interface IPathfinding
	{
		/**
		 * 通过寻路去向目标点 
		 * @param x
		 * @param y
		 */		
		function pathFindingTo( x:Number = 0, y:Number = 0 ):Boolean;
		
		/**
		 * 改变方向 
		 * @return 
		 */		
		function get changeDirectionMsg():Signal;
		
		/**
		 * 移动结束 
		 * @return 
		 */		
		function get pathToOverMsg():Signal;
		
		/**
		 * 进入场景可见区域 
		 * @return 
		 */		
		function get inSceneViewMsg():Signal;
		
		/**
		 * 离开场景可见区域 
		 * @return 
		 */		
		function get outSceneViewMsg():Signal;
	}
}