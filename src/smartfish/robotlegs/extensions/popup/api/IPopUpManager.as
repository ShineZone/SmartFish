package smartfish.robotlegs.extensions.popup.api
{
	import flash.display.DisplayObjectContainer;
	
	import smartfish.robotlegs.extensions.popup.effects.IAppear;
	import smartfish.robotlegs.extensions.popup.impl.PopUpData;
	
	public interface IPopUpManager
	{
		function initialize(container:DisplayObjectContainer,stageWidth:Number = -1,stageHeight:Number = -1):void;
		function registerPopUp(id:String,popup:IPopUpWindow,assetPath:String = "",theAppear:IAppear = null):PopUpData;
		function removePopUp(popup:IPopUpWindow):void;
		function open(idOrwindow:*,params:Object = null,modal:Boolean = true,type:int = 0):void
		function close(idOrwindow:*,params:Object = null):void
		function closeAllPopUp():void;
		function bringToFront(popUp:IPopUpWindow):void;
		function getPopupData(idOrWindow:Object):PopUpData;
	}
}