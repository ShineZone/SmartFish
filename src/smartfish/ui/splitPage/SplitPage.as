package smartfish.ui.splitPage
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class SplitPage extends SplitPageBase
	{
		private var nextPage:DisplayObject;
		private var prevPage:DisplayObject;
		private var lastPage:DisplayObject;
		private var firstPage:DisplayObject;
		private var tfPage:TextField;
		
		/**
		 * eg.var splitPage = new SplitPage(SplitPageDemoItem,4,2,10,5,classLibrary.getClass("PageItemUI")); 
		 * @param item
		 * @param row
		 * @param col
		 * @param spaceW
		 * @param spaceH
		 * @param skinClass
		 * @param isToggle
		 * 
		 */		
		public function SplitPage(item:Class, row:int, col:int, spaceW:int, spaceH:int, skinClass:Class=null, isToggle:Boolean=true)
		{
			super(item, row, col, spaceW, spaceH, skinClass, isToggle);
		}
		
		override public function set data(value:Array):void{
			super.data = value;
			checkPageStatus();
		}
		
		public function setControl(nextButton:DisplayObject=null,prevButton:DisplayObject=null,fistButton:DisplayObject=null,lastButton:DisplayObject=null,tf:TextField = null):void{
			nextPage   = nextButton;
			prevPage   = prevButton;
			firstPage  = fistButton;
			lastPage   = lastButton;
			tfPage     = tf;
			if(tfPage){
				tfPage.mouseEnabled = false;
				tfPage.selectable   = false;
			}		
			
			if(nextPage) {
				nextPage.addEventListener(MouseEvent.CLICK,pageHandler);
				if(nextButton is MovieClip){
					nextPage.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
					nextPage.addEventListener(MouseEvent.MOUSE_OUT,overHandler);
					nextPage.addEventListener(MouseEvent.MOUSE_DOWN,downHandle);					
					(nextPage as MovieClip).buttonMode = true;
					(nextPage as MovieClip).gotoAndStop(1);
					
				}
			}
			if(prevPage) {
				prevPage.addEventListener(MouseEvent.CLICK,pageHandler);
				if(nextButton is MovieClip){					
					prevPage.addEventListener(MouseEvent.MOUSE_DOWN,downHandle);
					prevPage.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
					prevPage.addEventListener(MouseEvent.MOUSE_OUT,overHandler);	
					(prevPage as MovieClip).buttonMode = true;
					(prevPage as MovieClip).gotoAndStop(1);
				}
			}
			if(firstPage) {
				firstPage.addEventListener(MouseEvent.CLICK,pageHandler);
				if(firstPage is MovieClip){
					firstPage.addEventListener(MouseEvent.MOUSE_DOWN,downHandle);
					firstPage.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
					firstPage.addEventListener(MouseEvent.MOUSE_OUT,overHandler);						
					(firstPage as MovieClip).buttonMode = true;		
					(firstPage as MovieClip).gotoAndStop(1);	
					
				}
			}
			if(lastPage) {
				lastPage.addEventListener(MouseEvent.CLICK,pageHandler);	
				if(lastPage is MovieClip){					
					lastPage.addEventListener(MouseEvent.MOUSE_DOWN,downHandle);
					lastPage.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
					lastPage.addEventListener(MouseEvent.MOUSE_OUT,overHandler);						
					(lastPage as MovieClip).buttonMode = true;		
					(lastPage as MovieClip).gotoAndStop(1);
				}
			}
			
			this.checkPageStatusFun = checkPageStatus;
		}
		
		private function overHandler(evt:MouseEvent):void{
			var mov:MovieClip = evt.currentTarget as MovieClip;
			if(evt.type == "mouseOver"){
				mov.gotoAndStop(2);
			}else{
				mov.gotoAndStop(1);
			}
		}
		
		private function downHandle(evt:MouseEvent):void{
			var mov:MovieClip = evt.currentTarget as MovieClip;
			mov.gotoAndStop(1);
		}
		
		private function pageHandler(evt:MouseEvent):void{
			if(evt.currentTarget is MovieClip){
				var mov:MovieClip = evt.currentTarget as MovieClip;
				mov.gotoAndStop(2);
			}			
			switch(evt.currentTarget){
				case nextPage:
					this.page++;
					break;
				case prevPage:
					this.page--;
					break;
				case firstPage:
					this.page = 1;
					break;
				case lastPage:
					this.page = this.totalPage;
					break;
			}
			checkPageStatus();
		} 		
		private function checkPageStatus():void {
			if(prevPage){
				if (this.page ==1) {				
					if(prevPage is MovieClip){
						(prevPage as MovieClip).gotoAndStop(3);
						(prevPage as MovieClip).mouseEnabled = false;
					}else{
						(prevPage as SimpleButton).mouseEnabled = false;
					}
					//FilterUtil.applyblack(prevPage);
				}else {
					prevPage.filters = [];
					if(prevPage is MovieClip){
						(nextPage as MovieClip).gotoAndStop(1);
						(prevPage as MovieClip).mouseEnabled = true;
					}else{
						(prevPage as SimpleButton).mouseEnabled = true;
					}
				}
			}
			if(nextPage){
				if (this.page ==this.totalPage || this.totalPage == 0){				
					if(nextPage is MovieClip){
						(nextPage as MovieClip).gotoAndStop(3);
						(nextPage as MovieClip).mouseEnabled = false;
					}else{
						(nextPage as SimpleButton).mouseEnabled = false;
					}
					//FilterUtil.applyblack(nextPage);
				}else {
					nextPage.filters = [];
					if(nextPage is MovieClip){
						(nextPage as MovieClip).gotoAndStop(1);
						(nextPage as MovieClip).mouseEnabled = true;
					}else{
						(nextPage as SimpleButton).mouseEnabled = true;
					}
				}
			}
			
			if(firstPage){
				if (this.page ==1) {				
					if(firstPage is MovieClip){
						(firstPage as MovieClip).gotoAndStop(3);
						(firstPage as MovieClip).mouseEnabled = false;
					}else{
						(firstPage as SimpleButton).mouseEnabled = false;
					}
				}else {
					if(firstPage is MovieClip){
						(firstPage as MovieClip).gotoAndStop(1);
						(firstPage as MovieClip).mouseEnabled = true;
					}else{
						(firstPage as SimpleButton).mouseEnabled = true;
					}
				}
			}
			
			if(lastPage){
				if (this.page ==this.totalPage || this.totalPage == 0){				
					if(lastPage is MovieClip){
						(lastPage as MovieClip).gotoAndStop(3);
						(lastPage as MovieClip).mouseEnabled = false;
					}else{
						(lastPage as SimpleButton).mouseEnabled = false;
					}
				}else {
					if(lastPage is MovieClip){
						(lastPage as MovieClip).gotoAndStop(1);
						(lastPage as MovieClip).mouseEnabled = true;
					}else{
						(lastPage as SimpleButton).mouseEnabled = true;
					}
				}
			}
			
			if(tfPage){
				if(this.totalPage>0){
					tfPage.text = this.page + "/" + this.totalPage;
				}else{
					tfPage.text = "0/0";
				}
			}
		}
	}
}