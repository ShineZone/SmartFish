/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午2:30:17
 **/
package smartfish.isometric.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import smartfish.isometric.core.api.IIsoObject;
	import smartfish.isometric.core.api.IIsoScene;
	import smartfish.isometric.geometry.IsoMath;
	import smartfish.isometric.geometry.IsoPoint;
	import smartfish.isometric.sort.DefaultSceneSort;
	import smartfish.isometric.utils.IsoConfig;
	import smartfish.isometric.utils.QuadTree;
	import smartfish.pathfinding.astar.MapGrid;

	public class IsoScene extends IsoObject implements IIsoScene
	{
		private var _isoObjects:Array;
		private var _sorter:DefaultSceneSort;
		private var _grid:MapGrid;
//		private var _quadTree:QuadTree;
		private var _allSceneRect:Rectangle;
		
		/**
		 * Constructor
		 **/
		public function IsoScene( maxWidth : int, maxHeight : int,  bPathfinding : Boolean = true )
		{
			_width = maxWidth;
			_height = maxHeight;
			if ( bPathfinding )
			{
				_grid = new MapGrid( maxWidth, maxHeight, IsoNode );
			}
			_container = new Sprite;
			
			var _pt:Point = IsoMath.isoToScreen(new IsoPoint(0, maxHeight * IsoConfig.SIZE, 0));
			var x:Number = _pt.x;
			var y:Number = 0;
			var width:Number = (maxWidth + maxHeight) * IsoConfig.SIZE;
			var height:Number = width >> 1;
			_allSceneRect = new Rectangle( x, y, width, height );
//			_quadTree = new QuadTree(_allSceneRect)
//			_quadTree.createChildren(5);
			
			_sorter = new DefaultSceneSort();
			_isoObjects = [];
		}
		
		override public function renderer():void
		{
			for each (var i:IIsoObject in _isoObjects)
			{
				i.renderer();
			}
			_sorter.renderScene(this);
		}
		
		public function setChildIndex( obj:IIsoObject, depth:int ):void
		{
			obj.depth = depth;
		}

        public function get viewRangeChildren() : Array
        {
            var _pt:Point = _container.globalToLocal(new Point(0, 0));
            //only search stage
            var _temp:Array = [];
            var _screenP:Point;
            var _screenSize:Array = [];
            var _bounds:Rectangle;
            var _sW:Number = (1 / IsoConfig.VIEW_ZOOM) * IsoConfig.VIEW_WIDTH;
            var _sH:Number = (1 / IsoConfig.VIEW_ZOOM) * IsoConfig.VIEW_HEIGHT;
            for each (var i:IIsoObject in _isoObjects)
            {
                _bounds = i.container.getBounds( i.container );
                _screenP = i.screenPosition;
                _screenP.x += _bounds.x;
                _screenP.y += _bounds.y;
                _screenSize[0] = _screenP.x + _bounds.width;
                _screenSize[1] = _screenP.y + _bounds.height;
                if
                (
                    _screenP.x < _pt.x + _sW &&	//leftA < rightB
                    _pt.x < _screenSize[0] &&	//leftB < rightA
                    _screenP.y < _pt.y + _sH && //topA < bottomB
                    _pt.y < _screenSize[1]		//topB < bottomA
                )
                    _temp.push( i );
            }

            return _temp;
        }
		
		public function get displayListChildren():Array
		{
			return _isoObjects;
		}
		
		public function addChild( value : IIsoObject ):void
		{
			value.isoScene = this;
			_isoObjects.push(value);
			value.parentContainer = _container;
			value.renderer();
			
//			_quadTree.add( value, value.screenPosition.x, value.screenPosition.y );
			IsoMap.instance.map( value );
		}
		
		public function removeChild( value : IIsoObject ):void
		{
			var _index:int = _isoObjects.indexOf( value );
			if ( _index > -1 )
			{
				_isoObjects.splice( _index, 1 );
			}
			value.dispose();
			
			IsoMap.instance.unmap( value );
		}

		override public function set parentContainer(value:Sprite):void
		{
			super.parentContainer = value;
			_parentContainer.addChild(_container);
		}
		
		/**
		 * 是否在场景的视图范围内
		 * 即可见区域内 
		 * @param rect
		 * @return 
		 */		
		public function inSceneView( rect:Object ):Boolean
		{
			var _pt:Point = _container.globalToLocal(new Point(0, 0));
			var _sceneRect:Object = {left:_pt.x, right:_pt.x + (1 / IsoConfig.VIEW_ZOOM) * IsoConfig.VIEW_WIDTH, top:_pt.y, bottom:_pt.y + (1 / IsoConfig.VIEW_ZOOM) * IsoConfig.VIEW_HEIGHT};
			return(
				rect.left < _sceneRect.right &&	//leftA < rightB
				_sceneRect.left < rect.right &&	//leftB < rightA
				rect.top < _sceneRect.bottom && //topA < bottomB
				_sceneRect.top < rect.bottom	//topB < bottomA
			);
		}

		public function get grid():MapGrid
		{
			return _grid;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_parentContainer.removeChild(_container);
		}

	}
}