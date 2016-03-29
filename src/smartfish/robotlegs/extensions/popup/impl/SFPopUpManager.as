package smartfish.robotlegs.extensions.popup.impl
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import smartfish.robotlegs.extensions.assets.api.IAssetsFactory;
	import smartfish.robotlegs.extensions.assets.api.IAssetsLoader;
	import smartfish.robotlegs.extensions.assets.impl.AssetInfo;
	import smartfish.robotlegs.extensions.popup.api.IPopUpManager;
	import smartfish.robotlegs.extensions.popup.api.IPopUpWindow;
	import smartfish.robotlegs.extensions.popup.effects.AppearMove;
	import smartfish.robotlegs.extensions.popup.effects.IAppear;

	/**
	 * 功能：
	 * 1.支持外部加载素材
	 * 2.支持队列弹窗
	 * 3.支持覆盖弹窗
	 * 4.支持并行弹窗
	 * @author Luke
	 * 
	 */	
	public class SFPopUpManager implements IPopUpManager
	{
		private static var instance:IPopUpManager;
		
		private var mPopupInfo:Vector.<PopUpData> = new Vector.<PopUpData>;
		private var mOpenList:Vector.<PopUpInfo>  = new Vector.<PopUpInfo>;
		private var mWaitList:Vector.<PopUpInfo>  = new Vector.<PopUpInfo>;
		
		private var mContainer:DisplayObjectContainer;
		private var stageW:Number;
		private var stageH:Number;
		private var originalStageW:Number;
		private var originalStageH:Number;
		private var mIsNeedAlign:Boolean = false;

		private var startDrawX:Number = 0;
		private var startDrawY:Number = 0;
		
		[Inject] public var classLibrary:IAssetsFactory;
		[Inject] public var assetsLoader:IAssetsLoader;
		
		public function SFPopUpManager()
		{
			
		}		
		
		public function initialize(container:DisplayObjectContainer,stageWidth:Number = -1,stageHeight:Number = -1):void{
			mContainer = container;
			if(stageWidth>0)
			{
				this.stageW = stageWidth;
			}
			else
			{
				this.stageW = mContainer.stage.stageWidth;
			}
			if(stageHeight>0)
			{
				this.stageH = stageHeight;
			}
			else
			{
				this.stageH = mContainer.stage.stageHeight;
			}
			
			originalStageW = stageW;
			originalStageH = stageH;
			
			mContainer.stage.addEventListener(Event.RESIZE,onResize);
		}
		
		protected function onResize(event:Event):void
		{
			stageW = mContainer.stage.stageWidth;
			stageH = mContainer.stage.stageHeight;
			
			startDrawX = -(stageW - originalStageW)/2;
			startDrawY = -(stageH - originalStageH)/2;
			
			if(mOpenList.length>0)
			{
				for (var i:int = 0, len:int = mOpenList.length; i < len; i++)
				{
					var window:IPopUpWindow = mOpenList[i].popUpData.owner;
					var maskSp:Sprite = mOpenList[i].popUpData.modalWindow;
					
					maskSp.graphics.clear();
					maskSp.graphics.beginFill(0,0.2);
					maskSp.graphics.drawRect(startDrawX,startDrawY,stageW,stageH);
					maskSp.graphics.endFill();
				}
			}
		}
		
		/**
		 * 注册窗口 
		 * @param popup
		 * @param assetPath
		 * @return 
		 * 
		 */		
		public function registerPopUp(id:String,popup:IPopUpWindow,assetPath:String = null,theAppear:IAppear = null):PopUpData{
			var o:PopUpData = getPopupData(popup);
			if(o == null){				
				o 				= new PopUpData();
				o.id			= id;
				o.owner 		= popup;
				o.assetPath 	= assetPath;
				o.state     	= 0;
				
				var appear:IAppear;
				if(theAppear == null)
				{
					appear = new AppearMove();	
				}
				else
				{
					appear = theAppear;
				}
				appear.init(mContainer,originalStageW,originalStageH);
				o.appear		= appear;
				
				mPopupInfo.push(o);
			}
			return o;
		}
		
		/**
		 * 删除窗口 
		 * @param popup
		 * 
		 */		
		public function removePopUp(popup:IPopUpWindow):void{
			var n:int = mPopupInfo.length;
			for (var i:int = n-1; i >=0; i--)
			{
				var o:PopUpData = mPopupInfo[i];
				if (o.owner == popup)
					mPopupInfo.splice(i,1);
			}
		}
		
		/**
		 * 打开窗口 
		 * @param popup
		 * @param modal
		 * @param type
		 * 
		 */		
		public function open(idOrwindow:*,params:Object = null,modal:Boolean = true,type:int = PopWindowType.QUEUE):void
		{
			if(findWindowInfoByOwner(idOrwindow) != null)
			{
				trace("【PopupManager】 窗口已打开。")
				return;
			}
			var o:PopUpData = getPopupData(idOrwindow);
			if(o){
				var window:PopUpInfo = createWindowInfo(modal,type,params,o);
				if(mOpenList.length == 0){
					startOpen(window);					
				}else{
					if(window.type == 0){
						mWaitList.push(window);
					}else{
						startOpen(window);
					}
				}				
			}
			else
			{
				throw Error("can't find the window" + idOrwindow);
			}
		}		
		
		/**
		 * 创建窗口数据对象 
		 * @param modal
		 * @param type
		 * @param params
		 * @return 
		 * 
		 */		
		private function createWindowInfo(modal:Boolean,type:int,params:Object,popup:PopUpData):PopUpInfo{
			return new PopUpInfo(modal,type,params,popup);
		}
		
		/**
		 * 关闭窗口 
		 * @param popup
		 * 
		 */		
		public function close(idOrwindow:*,params:Object = null):void{
			var o:PopUpInfo = findWindowInfoByOwner(idOrwindow);
			if(o){
				o.params   	     = params;
				startClose(o);
			}
		}
		
		/**
		 * 关闭所有窗口
		 */		
		public function closeAllPopUp():void{
			var n:int = mOpenList.length;
			for (var i:int = 0; i < n; i++) 
			{
				startClose(mOpenList[i]);
			}			
		}
		
		private function onLoadComplete(assetInfo:AssetInfo,window:PopUpInfo):void{
			window.popUpData.state = 2;
			if(assetInfo)
			{
				window.popUpData.owner.domain = assetInfo.content.loaderInfo.applicationDomain;
				classLibrary.addDomain(window.popUpData.id,assetInfo.content.loaderInfo.applicationDomain);
			}
			window.popUpData.owner.initilize();
			window.popUpData.owner.dispatchEvent(new PopUpEvent(PopUpEvent.INITALIZE));
			startOpen(window,1);
		}
		private function onLoadProgress(percentLoaded:Number,window:PopUpInfo):void{
			window.popUpData.owner.dispatchEvent(new PopUpEvent(PopUpEvent.PROGRESS,percentLoaded));
		}
		
		
		/**
		 *  准备打开窗口
		 * @param o
		 * 
		 */		
		private function startOpen(window:PopUpInfo,from:int = 0):void
		{	
			if(from == 0)
			{
				var containsOwner:Boolean = mContainer.contains(DisplayObject(window.popUpData.owner));
				createModalWindow(window.popUpData);
				if (window.modal)
				{
					if ( containsOwner )
					{
						trace("startOpen:", mContainer.getChildIndex(window.popUpData.owner.body));
						mContainer.addChildAt(window.popUpData.modalWindow, mContainer.getChildIndex(window.popUpData.owner.body));
					}
					else
					{
						mContainer.addChild(window.popUpData.modalWindow);
					}
					window.popUpData.modalWindow.visible = true;
				}
				window.popUpData.owner.body.visible         = false;
				if (!containsOwner)
				{
					mContainer.addChild(DisplayObject(window.popUpData.owner));	
				}
				mOpenList.push(window);	
			}
			//加载素材
			if (window.popUpData.state == 0)
			{
				if(window.popUpData.assetPath)
				{
					window.popUpData.state = 1;
					assetsLoader.load(window.popUpData.assetPath, "popup", int.MAX_VALUE)
						.addComplete(onLoadComplete, [window])
						.addProgress(onLoadProgress, [window]);
					return;
				}
				else
				{
					onLoadComplete(null,window);
				}
			}
			
				
			window.popUpData.owner.body.visible         = true;
			
			//处理打开窗口逻辑
			window.popUpData.owner.onOpen(window.params);
			window.params = null;
			window.popUpData.owner.dispatchEvent(new PopUpEvent(PopUpEvent.ON_OPEN));
			
			window.popUpData.appear.appear(window,onOpenComplete);
		}
		
		/**
		 * 打开结束
		 * @param o
		 * 
		 */		
		private function onOpenComplete(window:PopUpInfo,bitmap:Bitmap):void{
			if(checkAutoAlign()){
				mIsNeedAlign = true;
				autoAlignPopUp();
			}
			if(bitmap && bitmap.parent){
				bitmap.parent.removeChild(bitmap);
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
			window.popUpData.owner.body.visible        = true;
			window.popUpData.owner.onOpenComplete();
			window.popUpData.owner.dispatchEvent(new PopUpEvent(PopUpEvent.ON_OPEN_COMPLETE));
		}
		
		/**
		 * 只要有一个窗口的属性为多窗口并行。 
		 * @return 
		 * 
		 */		
		private function checkAutoAlign():Boolean{
			var len:int = mOpenList.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(mOpenList[i].type == PopWindowType.PARALLEL){
					return true;
					break;
				}
			}
			return false;
		}
		
		/**
		 * 定位各个并行窗口的位置 
		 * 
		 */		
		private function autoAlignPopUp():void{
			var n:int = mOpenList.length;
			if(n == 0){
				return;
			}
			var totalWidth:Number = 0;
			var maxH:Number       = 0;
			for (var i:int = 0; i < n; i++) 
			{
				var owner:IPopUpWindow = mOpenList[i].popUpData.owner;
				totalWidth += DisplayObject(owner).width;
				maxH = Math.max(DisplayObject(owner).height,maxH);
			}
					
			var startX:Number = (originalStageW - totalWidth)/2;
			var startY:Number = (originalStageH - maxH)/2;
			
			var targetX:Number = 0;
			var targetY:Number = 0;
			for (i = 0; i < n; i++) 
			{
				owner   	  	= mOpenList[i].popUpData.owner;
				var rect:Rectangle = owner.body.getBounds(owner.body);
				targetY       	= startY - rect.y;
				if(i >0){
					var dis:DisplayObject = DisplayObject(mOpenList[i-1].popUpData.owner);
					var rp:Rectangle      = dis.getBounds(dis);
					targetX     += dis.width + rp.x - rect.x;
				}else{
					targetX 	= startX - rect.x;
				}
				Tweener.addTween(owner,{time:0.7,x:targetX,y:targetY,transition:Equations.easeOutExpo});
			}		
		}
				
		/**
		 * 准备关闭窗口 
		 * @param o
		 * 
		 */		
		private function startClose(o:PopUpInfo):void
		{	
			o.popUpData.owner.dispatchEvent(new PopUpEvent(PopUpEvent.ON_OPEN));
			
			o.popUpData.appear.disAppear(o,onCloseComplete);
			
//			var bitmap:Bitmap 						= DrawUtil.draw(o.popUpData.owner.body);
//			o.popUpData.owner.body.visible        	= false;
//			var end:Object = {time:0.3,
//							  y:originalStageH,
//							  transition:Equations.easeInBack,
//							  onComplete:onCloseComplete,
//							  onCompleteParams:[o,bitmap]};			
//			bitmap.x = o.popUpData.owner.body.x + bitmap.x;
//			bitmap.y = o.popUpData.owner.body.y + bitmap.y;
//			mContainer.addChild(bitmap);
//			o.popUpData.owner.onClose(o.params);
//			Tweener.addTween(bitmap,end);
		}
		
		/**
		 * 关闭结束
		 * @param o
		 * 
		 */		
		private function onCloseComplete(o:PopUpInfo,bitmap:Bitmap):void{
			if(o.modal){
				o.popUpData.modalWindow.visible = false;
				mContainer.removeChild(o.popUpData.modalWindow);
			}
			o.popUpData.owner.onCloseComplete();
			o.popUpData.owner.dispatchEvent(new PopUpEvent(PopUpEvent.ON_CLOSE_COMPLETE));
//			mContainer.removeChild(DisplayObject(o.popUpData.owner));
			
			removeWindowData(mOpenList,o);
			
			if(mIsNeedAlign)
			{
				autoAlignPopUp();
			}
			if(bitmap && bitmap.parent){
				bitmap.parent.removeChild(bitmap);
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
			//查找并打开下一个队列
			if(mOpenList.length == 0 && mWaitList.length > 0){
				mIsNeedAlign = false;
				startOpen(mWaitList.shift());
			}
		}
		
		/**
		 * 创建模式窗口 
		 * @param o
		 * 
		 */		
		private function createModalWindow(o:PopUpData):void{
			if(o.modalWindow == null || (o.modalWindow.width != stageW || o.modalWindow.height != stageH)){
				var sp:Sprite = new Sprite();
				sp.graphics.beginFill(0,0.2);
				sp.graphics.drawRect(startDrawX,startDrawY,stageW,stageH);
				sp.graphics.endFill();
				o.modalWindow = sp;
			}
		}
		
		/**
		 * 查找窗口数据 
		 * @param owner
		 * @return 
		 * 
		 */		
		public function getPopupData(idOrWindow:Object):PopUpData
		{
			var n:int = mPopupInfo.length;
			for (var i:int = 0; i < n; i++)
			{
				var o:PopUpData = mPopupInfo[i];
				if (o.owner == idOrWindow || o.id == idOrWindow)
					return o;
			}
			return null;
		}
		
		/**
		 * 查找已打开的窗口数据 
		 * @param owner
		 * @return 
		 * 
		 */		
		private function findWindowInfoByOwner(idOrwindow:Object):PopUpInfo{
			var len:int = mOpenList.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(idOrwindow == mOpenList[i].popUpData.owner || idOrwindow == mOpenList[i].popUpData.id){
					return mOpenList[i];
				}
			}	
			return null;
		}
		
		/**
		 * 切换至最上层 
		 * @param popUp
		 * 
		 */		
		public function bringToFront(popUp:IPopUpWindow):void{
			if (popUp && popUp.parent)
			{
				var o:PopUpData = getPopupData(popUp);
				if (o && findWindowInfoByOwner(popUp))
				{
					popUp.parent.setChildIndex(DisplayObject(popUp), popUp.parent.numChildren - 1);
				}
			}
		}
		
		/**
		 * 删除窗口数据 
		 * @param vector
		 * @param o
		 * 
		 */		
		private function removeWindowData(vector:Vector.<PopUpInfo>,o:PopUpInfo):void{
			var n:int = vector.length;
			for (var i:int = n-1; i >=0; i--)
			{
				var pd:PopUpInfo = vector[i];
				if (pd == o)
					vector.splice(i,1);
			}
		}
	}
}