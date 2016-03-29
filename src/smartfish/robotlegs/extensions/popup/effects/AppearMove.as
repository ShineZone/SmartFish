package smartfish.robotlegs.extensions.popup.effects
{
	import flash.display.Bitmap;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import smartfish.robotlegs.extensions.popup.impl.PopUpInfo;
	import smartfish.utils.DrawUtil;

	public class AppearMove extends Appear
	{
		public function AppearMove()
		{
		}
				
		override public function appear(window:PopUpInfo,onOpenComplete:Function):void
		{
			super.appear(window, onOpenComplete);
			//绘制动画
			var bitmap:Bitmap = DrawUtil.draw(window.popUpData.owner.body);
			window.popUpData.owner.body.x				= (originalStageW - window.popUpData.owner.body.width)/2 - bitmap.x;
			window.popUpData.owner.body.y				= (originalStageH - window.popUpData.owner.body.height)/2 - bitmap.y;
			window.popUpData.owner.body.visible         = false;
			var end:Object = {time:.4,
				y:(originalStageH - bitmap.height)/2,
					transition:Equations.easeOutBack,
					onComplete:onOpenComplete,
					onCompleteParams:[window,bitmap]};		
			bitmap.x = (originalStageW - bitmap.width)/2;
			bitmap.y = originalStageH;
			mContainer.addChildAt(bitmap,mContainer.getChildIndex(window.popUpData.owner.body) + 1);
			Tweener.addTween(bitmap,end);
		}
		
		
		override public function disAppear(window:PopUpInfo,onCloseComplete:Function):void
		{
			super.disAppear(window, onCloseComplete);
			var bitmap:Bitmap 							= DrawUtil.draw(window.popUpData.owner.body);
			window.popUpData.owner.body.visible        	= false;
			var end:Object = {time:0.3,
				y:originalStageH,
				transition:Equations.easeInBack,
					onComplete:onCloseComplete,
					onCompleteParams:[window,bitmap]};			
			bitmap.x = window.popUpData.owner.body.x + bitmap.x;
			bitmap.y = window.popUpData.owner.body.y + bitmap.y;
			mContainer.addChild(bitmap);
			window.popUpData.owner.onClose(window.params);
			Tweener.addTween(bitmap,end);
		}
	}
}