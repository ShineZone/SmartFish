/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午2:49:29
 **/
package smartfish.isometric.extensions.pathfinding
{
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	import smartfish.isometric.core.api.IIsoSprite;
	import smartfish.isometric.core.ext.IIsoSpriteExtension;
	import smartfish.isometric.extensions.pathfinding.api.IPathfinding;
	import smartfish.isometric.utils.IsoConfig;
	import smartfish.pathfinding.astar.AStarNode;
	import smartfish.utils.Direction;
	
	public class PathfindingExtension implements IIsoSpriteExtension, IPathfinding
	{
		
		private var _targetPathIndex:int;
		private var _isoSprite:IIsoSprite;
		private var _currentTargetNode:AStarNode;
		private var _targetPaths:Vector.<AStarNode>;
		
		private var _changeDirectionMsg:Signal;
		private var _pathToOverMsg:Signal;
		private var _inSceneViewMsg:Signal;
		private var _outSceneViewMsg:Signal;
		
		private var _isInSceneView:Boolean;
		private var _currentDirection:int;
		
		/**
		 * Constructor
		 **/
		public function PathfindingExtension()
		{
			_inSceneViewMsg = new Signal;
			_outSceneViewMsg = new Signal;
			_changeDirectionMsg = new Signal();
			_pathToOverMsg = new Signal();
		}
		
		public function extend( value : IIsoSprite ):void
		{
			_isoSprite = value;
		}
		
		/**
		 * 通过寻路去向目标点 
		 * @param x
		 * @param y
		 */		
		public function pathFindingTo( x:Number = 0, y:Number = 0 ):Boolean
		{
			_targetPaths = IsoConfig.ASTAR.search
				(
					_isoSprite.isoScene.grid.getNode( _isoSprite.x / IsoConfig.SIZE >> 0, _isoSprite.y / IsoConfig.SIZE >> 0 ),
//					_isoScene.grid.getNode( (x + (IsoConfig.SIZE >> 1)) / IsoConfig.SIZE  >> 0, (y + (IsoConfig.SIZE >> 1)) / IsoConfig.SIZE >> 0 ),
					_isoSprite.isoScene.grid.getNode( x / IsoConfig.SIZE  >> 0, y / IsoConfig.SIZE >> 0 ),
					_isoSprite.isoScene.grid.nodes 
				);
			
			if ( _targetPaths && _targetPaths.length )
			{
				_targetPathIndex = 0;
				_currentTargetNode = _targetPaths[0];
				_isoSprite.container.addEventListener(Event.ENTER_FRAME, onMoveRender);
				return true;
			}
			return false;
		}
		
		/**
		 * Normal move 
		 * @param event
		 */		
		private function onMoveRender(event:Event):void
		{
			var speed:Number = 3;
			
			var dx:Number = _currentTargetNode.position.x * IsoConfig.SIZE - _isoSprite.x;
			var dy:Number = _currentTargetNode.position.y * IsoConfig.SIZE - _isoSprite.y;
			
			if ( dx < 0 )
			{
				if ( _isoSprite.x - speed < _currentTargetNode.position.x * IsoConfig.SIZE ) _isoSprite.x = _currentTargetNode.position.x * IsoConfig.SIZE;
				else _isoSprite.x -= speed;
				
				if ( _currentDirection != Direction.NORTHWEST )
				{
					_currentDirection = Direction.NORTHWEST;
					_changeDirectionMsg.dispatch( _currentDirection );
				}
			}
			else if ( dx > 0 )
			{
				if ( _isoSprite.x + speed > _currentTargetNode.position.x * IsoConfig.SIZE ) _isoSprite.x = _currentTargetNode.position.x * IsoConfig.SIZE;
				else _isoSprite.x += speed;
				
				if ( _currentDirection != Direction.SOUTHEAST )
				{
					_currentDirection = Direction.SOUTHEAST;
					_changeDirectionMsg.dispatch( _currentDirection );
				}
			}
			
			if ( dy < 0 )
			{
				if ( _isoSprite.y - speed < _currentTargetNode.position.y * IsoConfig.SIZE ) _isoSprite.y = _currentTargetNode.position.y * IsoConfig.SIZE;
				else _isoSprite.y -= speed;	
				
				if ( _currentDirection != Direction.NORTHEAST )
				{
					_currentDirection = Direction.NORTHEAST;
					_changeDirectionMsg.dispatch( _currentDirection );
				}
					
			}
			else if ( dy > 0 )
			{
				if ( _isoSprite.y + speed > _currentTargetNode.position.y * IsoConfig.SIZE ) _isoSprite.y = _currentTargetNode.position.y * IsoConfig.SIZE;
				else _isoSprite.y += speed;
				
				if ( _currentDirection != Direction.SOUTHWEST )
				{
					_currentDirection = Direction.SOUTHWEST;
					_changeDirectionMsg.dispatch( _currentDirection );
				}
					
			}
			
			_isoSprite.rendererPosition();
			
			if ( _isoSprite.x == _currentTargetNode.position.x * IsoConfig.SIZE && _isoSprite.y == _currentTargetNode.position.y * IsoConfig.SIZE ) 
			{
				moveToNodeComplete();
			}
		}
		
		private function moveToNodeComplete():void
		{
			_targetPathIndex ++;
			
			if (_targetPathIndex < _targetPaths.length) 
			{
				_currentTargetNode = _targetPaths[_targetPathIndex];
			}
			else
			{
				_isoSprite.container.removeEventListener(Event.ENTER_FRAME, onMoveRender);
				_pathToOverMsg.dispatch();
			}
				
			if ( _isoSprite.isoScene.inSceneView( _isoSprite.screenRange ) ) 
			{
				if ( !_isInSceneView )
				{
					_inSceneViewMsg.dispatch();
					_isInSceneView = true;
				}
				_isoSprite.isoScene.renderer();
			}
			else
			{
				if ( _isInSceneView )
				{
					_outSceneViewMsg.dispatch();
					_isInSceneView = false;
				}
			}
		}

		public function get changeDirectionMsg():Signal
		{
			return _changeDirectionMsg;
		}

		public function get pathToOverMsg():Signal
		{
			return _pathToOverMsg;
		}

		public function get inSceneViewMsg():Signal
		{
			return _inSceneViewMsg;
		}

		public function get outSceneViewMsg():Signal
		{
			return _outSceneViewMsg;
		}

	}
}