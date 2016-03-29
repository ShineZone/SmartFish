package smartfish.robotlegs.extensions.popup.effects
{
	import flash.display.DisplayObjectContainer;
	
	import smartfish.robotlegs.extensions.popup.impl.PopUpInfo;

	public interface IAppear
	{
		function init(container:DisplayObjectContainer,stageW:Number,stageH:Number):void;
		function appear(window:PopUpInfo,onOpenComplete:Function):void
		function disAppear(window:PopUpInfo,onCloseComplete:Function):void;
	}
}