/*
 * Copyright (c) 2013 rayyee. All rights reserved.
 * @author rayyee
 * Created 13-7-18 下午2:46
 */
package smartfish.managers.toolTip
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	/**
	 * 
	 * @author chenyh
	 * 
	 */	
	public class ToolTipManager implements IToolTipManager
	{
		private static var _instance:ToolTipManager = null;
		public var toolTip:ToolTip;
		private var _enabled:Boolean;
		public function ToolTipManager(singleMode:SingletonEnforcer) 
		{
			if (_instance != null) throw Error("error");
			_instance = this;
			
			toolTip = new ToolTip();
			toolTip.mouseChildren = false;
			toolTip.mouseEnabled  = false;
			toolTip.visible = false;
			enabled         = true;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(!_enabled){
				hide();
			}
		}

		/**
		 * 单例
		 * @return
		 */
		public static function getInstance():IToolTipManager {
			if (!_instance) {
				_instance = new ToolTipManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function init(container:DisplayObjectContainer):void {			
			container.addChild(toolTip);
		}
		
		public function setSkin(mov:MovieClip):void{
			toolTip.setSkin(mov);
		}
		
		public function setStyle(bgColor:uint = 0xffffff,bgAlpha:Number = 1,borderColor:uint=0xffffff,borderAlpha:Number=1,borderThickNess:Number=1,ellipsSize:Number = 5,arrowSize:Number = 7):void{
			toolTip.setStyle(bgColor, bgAlpha, borderColor, borderAlpha, borderThickNess,ellipsSize,arrowSize);
		}
		
		public function setFormat(format:TextFormat):void{
			toolTip.setFormat(format);
		}
		
		public function show(target:DisplayObject, content:*,direction:String = "top",duration:Number = 0, marginX:Number = 0,marginY:Number = 0,contentOffetX:Number = 0, contentOffetY:Number = 0):void
		{
			if(!enabled){
				return;
			}
			toolTip.init(target, content, direction,marginX,marginY, contentOffetX, contentOffetY);
			toolTip.visible = true;
			toolTip.alpha   = 0;
			Tweener.removeTweens(toolTip);
			Tweener.addTween(toolTip, {alpha:1, transition:Equations.easeOutExpo, onComplete:function():void
			{
				if (duration > 0)
				{
					toolTip.visible = false;
				}
			}});
//			TweenLite.killTweensOf(toolTip);
//			TweenLite.to(toolTip, 0.5, { alpha:1 ,ease:Expo.easeOut,onComplete:function ():void{
//				if(duration>0){
//					TweenLite.to(toolTip,duration,{onComplete:function ():void{
//						hide();
//					}})
//				}
//			}} );
		}
		
		public function hide():void
		{
			Tweener.removeTweens(toolTip);
//			TweenLite.killTweensOf(toolTip);
//			TweenLite.to(toolTip, 0.5, { alpha:0 ,ease:Expo.easeOut,onComplete:function ():void{
//				toolTip.visible = false;
//			}} );
			toolTip.visible = false;
		}
	}
}
class SingletonEnforcer{

}