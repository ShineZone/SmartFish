package smartfish.robotlegs.extensions.popup.effects
{
	import flash.display.Bitmap;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import smartfish.robotlegs.extensions.popup.effects.Appear;
	import smartfish.robotlegs.extensions.popup.impl.PopUpInfo;
	import smartfish.utils.DrawUtil;

	public class AppearScale extends Appear
	{
		public function AppearScale()
		{
			super();
		}
		
		override public function appear(window:PopUpInfo,onOpenComplete:Function):void
		{
			super.appear(window, onOpenComplete);
			var bitmap:Bitmap = DrawUtil.draw(window.popUpData.owner.body);
			window.popUpData.owner.body.x				= (originalStageW - window.popUpData.owner.body.width)/2 - bitmap.x;
			window.popUpData.owner.body.y				= (originalStageH - window.popUpData.owner.body.height)/2 - bitmap.y;
			window.popUpData.owner.body.visible         = false;
			var end:Object = {
				time:.5,
				alpha:1,
				scaleX:1,
				scaleY:1,
				x:(originalStageW - bitmap.width)/2,
				y:(originalStageH - bitmap.height)/2,
				transition:Equations.easeOutBack,
				onComplete:onOpenComplete,
				onCompleteParams:[window,bitmap]};			
			bitmap.scaleX 								= bitmap.scaleY = 0.1;
			bitmap.alpha								= 0;
			bitmap.x = (originalStageW - bitmap.width)/2;
			bitmap.y = (originalStageH - bitmap.height)/2;
			mContainer.addChildAt(bitmap,mContainer.getChildIndex(window.popUpData.owner.body) + 1);
			Tweener.addTween(bitmap,end);
		}
		
		override public function disAppear(window:PopUpInfo,onCloseComplete:Function):void
		{
			super.disAppear(window, onCloseComplete);
			var bitmap:Bitmap 						= DrawUtil.draw(window.popUpData.owner.body);
			window.popUpData.owner.body.visible        	= false;
			var end:Object = {
				time:.4,
				alpha:0,
				scaleX:0.1,
				scaleY:0.1,
				x:originalStageW/2 - (bitmap.width * .1)/2,
				y:originalStageH/2 - (bitmap.height * .1)/2,
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