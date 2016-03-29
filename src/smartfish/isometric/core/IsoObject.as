/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午3:50:00
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
	import smartfish.isometric.utils.IsoConfig;

	/**
	 * Isometric world object
	 * @author rayyee
	 */	
	public class IsoObject implements IIsoObject
	{
		/**
		 * 容器 
		 */		
		protected var _container:Sprite;
		/**
		 * 父级场景 
		 */		
		protected var _isoScene:IIsoScene;
		/**
		 * 是否阻碍地图通行</br>  true是可通行</br> false是不可 
		 */		
		protected var _walkable:Boolean;
		/**
		 * 对象的角度 </br> 90度  180度  270度  0度
		 */		
		protected var _angle:int;
		/**
		 * isometric 坐标 
		 * @private
		 */		
		public var isoPosition:IsoPoint;
		/**
		 * 场景坐标 
		 */		
		protected var _screenPosition:Point;
		/**
		 * sort depth 
		 */		
		protected var _depth:int;
		/**
		 * 同格子内层级 
		 */		
		protected var _layer:int;
		/**
		 * 父级现实对象容器 
		 */		
		protected var _parentContainer:Sprite;
		/**
		 * 矩形范围 
		 */		
		private var _range:Array;
		/**
		 * 有脏数据 
		 */		
		private var _dirty:Boolean;
		
		protected var _width:int;
		protected var _height:int;
		protected var _length:int;

		private var _isoNodes:Vector.<IsoNode>;
		
		/**
		 * Constructor
		 **/
		public function IsoObject()
		{
			_dirty = true;
			_angle = 0;
			_walkable = true;
		}
		
		public final function get x():Number
		{
			return isoPosition.x;
		}
		public function set x(value:Number):void
		{
			_dirty = true;
			isoPosition.x = value; 
//			verifyNode();
		}
		
		public final function get y():Number
		{
			return isoPosition.y;
		}
		public function set y(value:Number):void
		{
			_dirty = true;
			isoPosition.y = value; 
//			verifyNode();
		}
		
		public function get z():Number
		{
			return isoPosition.z;
		}
		public function set z(value:Number):void
		{
			_dirty = true;
			isoPosition.z = value; 
		}
		
//		public function get width():int
//		{
//			return _width;
//		}
//		public function set width(value:int):void
//		{
//			_width = value;
//		}
//		
//		public function get height():int
//		{
//			return _height;
//		}
//		public function set height(value:int):void
//		{
//			_height = value;
//		}
		
		public function get length():int
		{
			return _length;
		}
		public function set length(value:int):void
		{
			_dirty = true;
			_length = value;
		}
		
		public function get layer():int
		{
			return _layer;
		}
		public function set layer(value:int):void
		{
			_dirty = true;
			_layer = value;
		}
		
		public function get depth():int
		{
			return _depth;
		}
		public function set depth(value:int):void
		{
			_dirty = true;
			_depth = value;
		}
		
		public function set parentContainer( value:Sprite ):void
		{
			_dirty = true;
			_parentContainer = value;
		}
		
		/**
		 * 刷新坐标 
		 */		
		public function rendererPosition():void
		{
			_dirty = true;
			_screenPosition = IsoMath.isoToScreen( isoPosition );
			_container.x = _screenPosition.x >> 0;
			_container.y = _screenPosition.y >> 0;
		}
		
		public function get screenRange():Object
		{
			var _bounds:Rectangle = _container.getBounds( _container );
			var _obj:Object = {};
			_obj.left = _screenPosition.x + _bounds.x;
			_obj.right = _obj.left + _bounds.width;
			_obj.top = _screenPosition.y + _bounds.y;
			_obj.bottom = _obj.top + _bounds.height;
			return _obj;
		}
		
		public function get isoRange():Array
		{
			if ( _dirty )
			{
				var mtx:Array = IsoMath.rotate( _width, _height, _angle );
				var left:Number = Math.min( 0, mtx[0]) * IsoConfig.SIZE + x;
				var top:Number = Math.min( 0, mtx[1]) * IsoConfig.SIZE + y;
				_range =  [ 
					left,
					top,
					//right
					left + Math.abs(mtx[0]) * IsoConfig.SIZE, 
					//bottom
					top + Math.abs(mtx[1]) * IsoConfig.SIZE 
				];
				_dirty = false;
			}
			return _range;
		}
		
		public function renderer():void
		{
		}
		
		public function dispose():void
		{
			_isoScene = null;
		}

		public function get walkable():Boolean
		{
			return _walkable;
		}
		public function set walkable(value:Boolean):void
		{
			_dirty = true;
			_walkable = value;
			verifyNode();
		}
		
		protected function verifyMap():void
		{
			IsoMap.instance.remap( this );
		}
		
		/**
		 * 验证所占格子是否能通过 
		 */		
		protected function verifyNode():void
		{
			if ( _isoScene == null ) return;
			if ( !_walkable ) setNodesWall( true );
			else
			{
				var isWall:Boolean;
				var _isoObjects:Vector.<IIsoObject>;
				for each (var isoNode:IsoNode in isoNodes)
				{
					isWall = false;
					_isoObjects = IsoMap.instance.getObjects( isoNode.position.x, isoNode.position.y );
					for each (var i:IIsoObject in _isoObjects)
					{
						if ( !i.walkable )
						{
							isoNode.isWall = true;
							isWall = true;
							break;
						}
					}
					if ( !isWall ) 
						isoNode.isWall = false;
				}
			}
		}
		
		/**
		 * 获取所占格子 
		 * @return 
		 */		
		public function get isoNodes():Vector.<IsoNode>
		{
			//TODO:优化IsoObject脏处理后   cache该计算 直到有脏数据
			var indexX:int;
			var indexY:int;
			_isoNodes = new Vector.<IsoNode>;
			var k:int;
			var j:int;
			
			var mtx:Array = IsoMath.rotate( _width, _height, _angle );
			var wS:int = _width > 0 ? 1 : -1;
			var hS:int = _height > 0 ? 1 : -1;
			
			for (j = 0; j < Math.abs(mtx[0]); j += 1)
			{
				for (k = 0; k < Math.abs(mtx[1]); k += 1)
				{
					indexX = (x / IsoConfig.SIZE >> 0) + j * wS;
					indexY = (y / IsoConfig.SIZE >> 0) + k * hS;
					_isoNodes.push(_isoScene.grid.getNode( indexX, indexY ) as IsoNode);
				}
			}
			
			return _isoNodes;
		}
		
		private function setNodesWall( value : Boolean ):void
		{
			for each (var i:IsoNode in isoNodes)
			{
				i.isWall = value;
			}
		}

		public function get isoScene():IIsoScene
		{
			return _isoScene;
		}
		public function set isoScene(value:IIsoScene):void
		{
			_dirty = true;
			_isoScene = value;
			verifyNode();
		}
		
		public function get screenPosition():Point
		{
			return _screenPosition;
		}
		
		/**
		 * 容器 
		 */
		public function get container():Sprite
		{
			return _container;
		}

	}
}