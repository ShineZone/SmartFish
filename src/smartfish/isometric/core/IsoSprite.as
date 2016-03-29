/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午3:05:50
 **/
package smartfish.isometric.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import smartfish.isometric.core.api.IIsoSprite;
	import smartfish.isometric.core.ext.IIsoSpriteExtension;
	import smartfish.isometric.geometry.IsoPoint;
	import smartfish.isometric.utils.IsoConfig;

	public class IsoSprite extends IsoObject implements IIsoSprite
	{
		
		/**
		 * 所有的插件 
		 */		
		private var _allExtensions:Dictionary;
		
		/**
		 * 材质 
		 */		
		private var _sprites:Array;
		
		/**
		 * Constructor
		 **/
		public function IsoSprite( width:int = 0, height:int = 0, length:int = 0, l:int = 0 )
		{
			_allExtensions = new Dictionary();
			_layer = l;
			_depth = -1;
			_container = new Sprite();
			_sprites = [];
			isoPosition = new IsoPoint();
			setSize( width, height, length );
		}
		
		/**
		 * 安装插件 
		 * @param value
		 */		
		public function install( value : IIsoSpriteExtension, mapTo : * ):void
		{
			value.extend( this );
			_allExtensions[ mapTo ] = value;
		}
		
		/**
		 * 获取插件 
		 * @param key
		 * @return 
		 */		
		public function getExtension( key : * ):*
		{
			return _allExtensions[key];
		}
		
		override public function renderer():void
		{
			rendererPosition();
		}
		
		/**
		 * Sprite旋转 
		 * @param degree
		 */		
		public function rotation( degree:Number = 90 ):Boolean
		{
			if ( degree == IsoConfig.Rotation_Clockwise || degree == IsoConfig.Rotation_Counterclockwise )
			{
				_angle += degree;
				if ( _angle == 360 ) _angle = 0;
				else if ( _angle == -90 ) _angle = 270;
			}
			else
			{
				throw new Error("旋转的角度值不在允许范围内。");
			}
			
			return false;
		}
		
		public function setSize( width:int, height:int, length:int ):void
		{
			_width = width;
			_height = height;
			_length = length;
		}
		
		public function moveTo( x:Number, y:Number ):Boolean
		{
			if ( IsoMap.instance.verifyMapRelationship( x, y ) )
			{
				this.x = x;
				this.y = y;
				rendererPosition();
				return true;
			}
			return false;
		}
		
		public function moveIndexTo( x:int = 0, y:int = 0 ):Boolean
		{
			var nX:Number = x * IsoConfig.SIZE;
			var nY:Number = y * IsoConfig.SIZE;
			
			var bMove:Boolean = moveTo( nX, nY );
			verifyMap();
			verifyNode();
			return bMove;
		}
		
		override public function set parentContainer( value:Sprite ):void
		{
			super.parentContainer = value;
			if (_depth > 0) value.addChildAt( _container, depth );
			else value.addChild( _container );
		}
		
		override public function set depth(value:int):void
		{
			super.depth = value;
			_parentContainer.setChildIndex( _container, depth );
		}
		
		/**
		 * 设置Spite材质贴图 
		 * @param value
		 */		
		public function set sprites( value:Array ):void
		{
			_sprites = value;
			rendererChild();
		}
		
		/**
		 * 刷新材质 
		 */		
		private function rendererChild():void
		{
			for each ( var i:* in _sprites )
			{
				if ( i is DisplayObject )
				{
					_container.addChild( i );
				}
				else if ( i is BitmapData )
				{
					var b:Bitmap = new Bitmap( i );
					_container.addChild( b );
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_parentContainer.removeChild(_container);
		}

	}
}