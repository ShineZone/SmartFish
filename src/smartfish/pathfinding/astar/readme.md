### Astar寻路

> 基于二维网格的寻路*MapGrid*



+ AStarNode节点数据  用于记录寻路过程中的数据

+ Astar的使用

		var astar:AStar = new AStar;
		astar.search( start : AStarNode, end:AStarNode, g : Vector.<Vector.<AStarNode>> = null ) : Vector.<AStarNode> 
		
+ EvaluationAlgorithms存放Astar所需要的估价函数 可以根据项目具体情况来旋转不同的算法实现