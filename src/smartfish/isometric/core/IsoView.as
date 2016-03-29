/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午10:01:19
 **/
package smartfish.isometric.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import smartfish.isometric.core.api.IIsoScene;
	import smartfish.isometric.geometry.IsoMath;
	import smartfish.isometric.geometry.IsoPoint;
	import smartfish.isometric.utils.IsoConfig;
	import smartfish.isometric.utils.IsoViewDragger;
	
	/**
	 * Isometric视图</br>
	 * 可进行一些相机行为 
	 * @author rayyee
	 */	
	public class IsoView extends Sprite
	{
		private var _viewWidth:Number;
		private var _viewheight:Number;
		
		private var zoomContainer:Sprite;
		private var mContainer:Sprite;
		private var bgContainer:Sprite;
		private var sceneContainer:Sprite;
		private var _canMapDrag:Boolean;
		private var _isoViewDragger:IsoViewDragger;
		private var _currentPosition:Point;
		
		/**
		 * Constructor
		 **/
		public function IsoView( w:Number, h:Number )
		{
			_viewWidth = w;
			_viewheight = h;
			
			_currentPosition = new Point;
			
			sceneContainer = new Sprite();
			
			mContainer = new Sprite();
			mContainer.mouseChildren = false;
			mContainer.addChild( sceneContainer );
			
			zoomContainer = new Sprite();
			zoomContainer.addChild( mContainer );
			addChild( zoomContainer );
			
//			zoomContainer.x = _viewWidth / 2;
//			zoomContainer.y = _viewheight / 2;
			
			super();
		}
		
		public function localToIso( localPt:Point ):IsoPoint
		{
			localPt = localToGlobal( localPt );
			localPt = mContainer.globalToLocal( localPt );
			localPt.y += IsoConfig.SIZE >> 1;
			
			return IsoMath.screenToIso( localPt );
		}
		
		public function isoToLocal( isoPt:IsoPoint ):Point
		{
			var pt:Point = IsoMath.isoToScreen( isoPt );
			
			pt = mContainer.localToGlobal( pt );
			return globalToLocal( pt );
		}
		
		public function addScene( value:IIsoScene ):void
		{
			value.parentContainer = sceneContainer;
		}
		
		public function zoom( zFactor:Number ):void
		{
			IsoConfig.VIEW_ZOOM = zFactor;
			zoomContainer.scaleX = zoomContainer.scaleY = zFactor;
		}
		
		/**
		 * The container for background elements.
		 */
		public function get backgroundContainer():Sprite
		{
			if ( !bgContainer )
			{
				bgContainer = new Sprite();
				mContainer.addChildAt( bgContainer, 0 );
				bgContainer.mouseChildren = bgContainer.mouseEnabled = false;
			}
			
			return bgContainer;
		}
		
		public function panTo( x:Number, y:Number ):void
		{
			Tweener.removeTweens(mContainer);
			Tweener.addTween(mContainer, {time:.1, x:x, y:y, transition:Equations.easeOutQuad});
//			mContainer.x = x;
//			mContainer.y = y;
		}
		
		public function get currentX():Number
		{
			return mContainer.x;
		}
		
		public function get currentY():Number
		{
			return mContainer.y;
		}

		public function get canMapDrag():Boolean
		{
			return _canMapDrag;
		}

		public function set canMapDrag(value:Boolean):void
		{
			_canMapDrag = value;
			if ( _canMapDrag )
			{
				if ( _isoViewDragger )
				{
					_isoViewDragger.drag();
				}
				else
				{
					_isoViewDragger = new IsoViewDragger( this );
				}
			}
			else
			{
				if ( _isoViewDragger ) _isoViewDragger.stop();
			}
		}
		
	}
}