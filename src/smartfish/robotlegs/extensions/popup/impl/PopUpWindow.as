package smartfish.robotlegs.extensions.popup.impl
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import smartfish.robotlegs.base.View;
	import smartfish.robotlegs.extensions.popup.api.IPopUpManager;
	import smartfish.robotlegs.extensions.popup.api.IPopUpWindow;
	
	public class PopUpWindow extends View implements IPopUpWindow
	{
		public var popupManager:IPopUpManager;
		
		private var _domain:ApplicationDomain;
		private var _closeBtn:DisplayObject;
		
		public function PopUpWindow()
		{
			super();
		}
		
		public function set closeButton(value:DisplayObject):void
		{
			if(_closeBtn){
				_closeBtn.removeEventListener(MouseEvent.CLICK,close);
			}
			_closeBtn = value;
			if(_closeBtn){
				_closeBtn.addEventListener(MouseEvent.CLICK,close);
			}
		}
		
		[Deprecated]
		override public function initialization():void
		{
			
		}
		
		/**
		 * 初始化窗口
		 * @param	object
		 */
		public function initilize():void
		{
			
		}
		
		/**
		 * 当窗口打开执行
		 * @param	params
		 */
		public function onOpen(params:Object=null):void
		{
			
		}
		
		/**
		 * 当窗口打开效果结束后执行
		 */
		public function onOpenComplete():void
		{
			
		}
		
		protected function close(params:Object = null):void
		{
			popupManager.close(this);
		}
		
		/**
		 * 当窗口关闭执行
		 * @param	params
		 */
		public function onClose(params:Object=null):void
		{
			
		}
		
		/**
		 * 当窗口关闭效果结束后执行
		 */
		public function onCloseComplete():void
		{
			
		}
		
		public function set domain(value:ApplicationDomain):void{
			_domain = value;
		}
		
		public function get domain():ApplicationDomain {
			return _domain;
		}
		
		public function getMovieClip(clsName:String):MovieClip{
			var cls:Class = getClass(clsName);
			if(cls != null){
				return new cls();
			}
			return null;
		}
		
		public function getClass(clsName:String):Class{
			if(domain.hasDefinition(clsName)){
				return domain.getDefinition(clsName) as Class;	
			}
			return null;
		}
		
		public function get body():DisplayObject{
			return this;
		}
	}
}