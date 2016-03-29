package smartfish.robotlegs.extensions.popup.effects
{
	import flash.display.DisplayObjectContainer;
	
	import smartfish.robotlegs.extensions.popup.effects.IAppear;
	import smartfish.robotlegs.extensions.popup.impl.PopUpData;
	import smartfish.robotlegs.extensions.popup.impl.PopUpInfo;
	
	public class Appear implements IAppear
	{
		
		protected var popUpData:PopUpData;
		protected var originalStageW:Number;
		protected var originalStageH:Number;
		protected var mContainer:DisplayObjectContainer;
		
		public function Appear()
		{
		}
		
		public function init(container:DisplayObjectContainer,stageW:Number,stageH:Number):void
		{
			mContainer = container;
			originalStageW = stageW;
			originalStageH = stageH;
		}
		
		public function appear(window:PopUpInfo, onOpenComplete:Function):void
		{
			window.popUpData.owner.body.visible = true;
		}
		
		public function disAppear(window:PopUpInfo, onCloseComplete:Function):void
		{
			window.popUpData.owner.body.visible = false;
		}
	}
}