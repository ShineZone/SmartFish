package smartfish.robotlegs.extensions.popup.impl
{
	
	public class PopUpInfo{
		/**
		 * 是否是模式窗口 
		 */		
		public var modal:Boolean; 
		
		/**
		 * 0:队列,1:叠加 ,2:并行 
		 */		
		public var type:int;
		
		/**
		 * 参数 
		 */	
		public var params:Object;
		
		public var popUpData:PopUpData;
		
		public function PopUpInfo(modal:Boolean = false,type:int = 0,params:Object = null,popup:PopUpData = null)
		{
			this.modal  	= modal;
			this.type   	= type;
			this.params 	= params;
			this.popUpData 	= popup;
		}
	}
}