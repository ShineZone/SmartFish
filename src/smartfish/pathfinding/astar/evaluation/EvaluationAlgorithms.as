/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午9:47:34
 **/
package smartfish.pathfinding.astar.evaluation
{
	import flash.geom.Point;

	public class EvaluationAlgorithms
	{
		/**
		 * Constructor
		 **/
		public function EvaluationAlgorithms()
		{
		}
		
		//曼哈顿算法
		public static function manhattan(node:Point, endNode:Point):Number 
		{
			return Math.abs(node.x - endNode.x) + Math.abs(node.y - endNode.y);
		}
		
		//曼哈顿算法2
		public static function manhattan2(node:Point, endNode:Point):Number 
		{
			var dx:Number = Math.abs(node.x - endNode.x);
			var dy:Number = Math.abs(node.y - endNode.y);
			return dx + dy + Math.abs(dx - dy) / 1000;
		}
		
		//欧几里得算法
		public static function euclidian(node:Point, endNode:Point):Number 
		{
			var dx:Number = node.x - endNode.x;
			var dy:Number = node.y - endNode.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		//欧几里德算法2
		public static function euclidian2(node:Point, endNode:Point):Number 
		{
			var dx:Number = node.x - endNode.x;
			var dy:Number = node.y - endNode.y;
			return dx * dx + dy * dy;
		}
		
		private static var TwoOneTwoZero:Number = 2 * Math.cos(Math.PI / 3);
		//跳棋式欧几里德算法
		public static function chineseCheckersEuclidian2(node:Point, endNode:Point):Number 
		{
			var y:int = node.y / TwoOneTwoZero;
			var x:int = node.x + node.y / 2;
			var dx:Number = x - endNode.x - endNode.y / 2;
			var dy:Number = y - endNode.y / TwoOneTwoZero;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private static var _straightCost:Number = 1.0;
		private static var _diagCost:Number = Math.SQRT2;
		//对角线算法 
		public static function diagonal(node:Point, endNode:Point):Number 
		{
			var dx:Number = Math.abs(node.x - endNode.x);
			var dy:Number = Math.abs(node.y - endNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
	}
}