package smartfish.managers.message
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import smartfish.utils.DrawUtil;

	/**
	 * 消息管理器 Luke 
	 * @author chenyonghua
	 * 
	 */	
	public class MessageManager implements IMessageManager
	{
		private static var _instance:IMessageManager = null;
		private var mContainer:DisplayObjectContainer;
		private var mSkin:MovieClip;
		
		//symbol
		private var mTf:TextField;
		private var mFrame:MovieClip;
		private var orginX:Number;
		private var orginY:Number;
		public function MessageManager(single:SingletonEnforcer)
		{
			if (_instance != null) throw Error("error");
			_instance = this;
			
		}
		
		/**
		 * 单例
		 * @return
		 */
		public static function getInstance():IMessageManager {
			if (!_instance) {
				_instance = new MessageManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/**
		 * 初始化 
		 * @param stage
		 * @param skin
		 * 
		 */		
		public function initlize(stage:DisplayObjectContainer,skin:MovieClip):void{			
			mContainer    	= stage;
			mSkin	      	= skin;
			mTf			  	= mSkin.tf;
			mFrame		  	= mSkin.frame;
			mTf.autoSize  	= TextFieldAutoSize.LEFT;
			mTf.selectable	= false;
			mTf.multiline 	= true;
			mTf.wordWrap 	= false;
			
			orginX = mTf.x;
			orginY = mTf.y;
		}
		
		/**
		 * 组织皮肤 
		 * @param content
		 * @param target
		 * @param distanceIn
		 * @param distanceOut
		 * 
		 */			
		public function send(content:*,target:DisplayObject = null,distanceIn:Number = 80,distanceOut:Number = 100,skinWidth:int = 0,skinHeight:int = 0,transparent:Boolean = false):void{
			if(mFrame)
				mFrame.visible 	= !transparent;
			if(content is String){
				mTf.text 	  	= content;
				if(skinWidth != 0 || skinHeight != 0){
					mFrame.width  = skinWidth;
					mFrame.height  = skinHeight;
					mTf.x		  = (mFrame.width - mTf.width)/2;
					mTf.y		  = (mFrame.height - mTf.height)/2;
				}else{
					mFrame.width  = mTf.width + 10;
					mFrame.height = mTf.height + 10;
					mTf.x		  = orginX;
					mTf.y		  = orginY;
				}
			}else if(content is DisplayObject){
				var rect:Rectangle = (content as DisplayObject).getBounds((content as DisplayObject));
				mSkin.addChild(content);
				if(skinWidth != 0 || skinHeight != 0){
					mFrame.width  = skinWidth;
					mFrame.height  = skinHeight;
					content.x = (mFrame.width - rect.width)/2 - rect.x;
					content.y = (mFrame.height - rect.height)/2 - rect.y;
				}else{
					mFrame.width  = (content as DisplayObject).width + 10;
					mFrame.height = (content as DisplayObject).height + 10;
					content.x = 5 - rect.x;
					content.y = 5 - rect.y;
				}				
			}else {
				return;
			}
			play(mSkin,target,distanceIn,distanceOut);
			mTf.text = "";
			if(content is DisplayObject){
				mSkin.removeChild(content);
			}
		}
		
		/**
		 * 发送消息 
		 * @param dis
		 * @param target
		 * @param distanceIn
		 * @param distanceOut
		 * 
		 */		
		public function play(dis:DisplayObject,target:DisplayObject,distanceIn:Number = 80,distanceOut:Number = 100):void{
			var bitmap:Bitmap 	= DrawUtil.draw(dis);
			var targetX:Number;
			var targetY:Number;
			if(target != null){
				var rect:Rectangle 	= target.getRect(mContainer);
				bitmap.x			= rect.x+(target.width - bitmap.width)/2;
				bitmap.y			= rect.y - 10;
			}else{
				bitmap.x			= (mContainer.stage.stageWidth - bitmap.width)/2;
				bitmap.y			= (mContainer.stage.stageHeight - bitmap.height)/2;
			}
			var ty:Number 	= bitmap.y - distanceIn;
			bitmap.alpha 	= 0;
			targetX			= bitmap.x;
			targetY			= bitmap.y;
			bitmap.x += bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			bitmap.scaleX = bitmap.scaleY = 0.1;
			mContainer.addChild(bitmap);
			Tweener.addTween(bitmap,{time:0.5,y:ty,alpha:1,scaleX:1,scaleY:1,x:targetX,y:targetY,transition:Equations.easeOutBack,onComplete:function ():void{
				ty = bitmap.y - distanceOut;
				Tweener.addTween(bitmap,{time:3,delay:.3,y:ty,alpha:0,transition:Equations.easeOutExpo,onComplete:function ():void{
					Tweener.removeTweens(bitmap);
					mContainer.removeChild(bitmap);
					bitmap.bitmapData.dispose();
					bitmap.bitmapData = null;
					bitmap            = null;
				}});
			}});
		}
	}

}

class SingletonEnforcer
{
	
}
