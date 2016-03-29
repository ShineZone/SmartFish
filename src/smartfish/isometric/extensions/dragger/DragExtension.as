/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午4:25:20
 **/
package smartfish.isometric.extensions.dragger
{
	import smartfish.isometric.core.api.IIsoSprite;
	import smartfish.isometric.core.ext.IIsoSpriteExtension;
	import smartfish.isometric.extensions.dragger.api.IDragger;
	import smartfish.isometric.geometry.IsoMath;
	import smartfish.isometric.geometry.IsoPoint;
	import smartfish.isometric.utils.IsoConfig;
	
	public class DragExtension implements IIsoSpriteExtension, IDragger
	{
		private var _isoSprite:IIsoSprite;
		
		/**
		 * Constructor
		 **/
		public function DragExtension()
		{
			
		}
		
		public function extend(value:IIsoSprite):void
		{
			_isoSprite = value;
		}
		
		/**
		 * 拖拽 
		 */		
		public function drag():void
		{
			_isoSprite.container.startDrag();
		}
		
		/**
		 * 放下 
		 */		
		public function put():void
		{
			_isoSprite.container.stopDrag();
			_isoSprite.screenPosition.x = _isoSprite.container.x;
			_isoSprite.screenPosition.y = _isoSprite.container.y;
			var isoPos:IsoPoint = IsoMath.screenToIso( _isoSprite.screenPosition );
			_isoSprite.moveIndexTo( isoPos.x / IsoConfig.SIZE >> 0, isoPos.y / IsoConfig.SIZE >> 0 );
		}
	}
}