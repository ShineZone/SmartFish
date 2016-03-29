/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午10:20:33
 **/
package smartfish.robotlegs.extensions.popup
{
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import smartfish.robotlegs.extensions.assets.api.IAssetsFactory;
	import smartfish.robotlegs.extensions.popup.api.IPopUpManager;
	import smartfish.robotlegs.extensions.popup.api.IPopUpWindow;
	import smartfish.robotlegs.extensions.popup.impl.PopUpData;
	import smartfish.robotlegs.extensions.popup.impl.PopUpEvent;
	
	public class PopupMediator extends Mediator
	{
		
		[Inject] 
		public var popupManager:IPopUpManager;
		[Inject] 
		public var assetsFactory:IAssetsFactory;
		
		protected var popupData:PopUpData;
		
		/**
		 * Constructor
		 **/
		public function PopupMediator()
		{
			super();
		}
		
		override public function set viewComponent(view:Object):void
		{
			if ( view )
			{
				var viewClass:Class = view["constructor"];
				var _id:String = String(viewClass).substr(7).slice(0, -1);
				var _url:String = assetsFactory.configCache.getAssetsConfigByID(_id).path;
				popupData = popupManager.registerPopUp( _id, view as IPopUpWindow, _url );
				super.viewComponent = view;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():void
		{
			popupData.owner.addEventListener( PopUpEvent.ON_CLOSE, onClose );
			popupData.owner.addEventListener( PopUpEvent.ON_OPEN, onOpen );
			popupData.owner.addEventListener( PopUpEvent.ON_OPEN_COMPLETE, onOpenDone );			
			popupData.owner.addEventListener( PopUpEvent.ON_CLOSE_COMPLETE, onCloseDone );
			popupData.owner.addEventListener( PopUpEvent.PROGRESS, onUpdate );
			popupData.owner.addEventListener( PopUpEvent.INITALIZE, onInitalize );
			popupData.owner.addEventListener( PopUpEvent.CLOSE, onClosePopup );
		}
		
		private function onClosePopup( e:PopUpEvent ):void
		{
			close();
		}
		
		private function onInitalize( e:PopUpEvent ):void
		{
			e.currentTarget.removeEventListener(PopUpEvent.PROGRESS, onUpdate);
			e.currentTarget.removeEventListener(PopUpEvent.INITALIZE, onInitalize);
		}
		
		private function onUpdate( e:PopUpEvent ):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onCloseDone( e:PopUpEvent ):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onOpenDone( e:PopUpEvent ):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onOpen( e:PopUpEvent ):void
		{
			
		}
		
		private function onClose( e:PopUpEvent ):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			
		}
		
		public function close( params:Object = null ):void
		{
			popupManager.close( popupData.id, params );
		}
		
		protected function open( params:Object = null, modal:Boolean = true, type:int = 0 ):void
		{
			popupManager.open( popupData.id, params, modal, type );
		}
		
	}
}