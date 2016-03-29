package smartfish.ui.tabList
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class TabItem extends Sprite implements ITabItem
	{
		protected var skin:MovieClip;
		protected var _data:Object;
		public function TabItem()
		{
			super();
		}
		
		public function setSkin(mov:MovieClip):void {
			skin = mov;
			skin.gotoAndStop(1);
			this.addChild(skin);
		}
		
		public function set data(o:Object):void{
			_data = o;
			if(o){		
				initlize();					
			}else{
				
			}
		}
		
		public function get data():Object{
			return _data;
		}
		
		protected function initlize():void
		{
			
		}
		
		public function onMouseOver():void{
			if(skin){
				skin.gotoAndStop(2);
			}
		}
		public function onMouseOut():void{
			if(skin){
				skin.gotoAndStop(1);
			}
		}
		public function onSelect():void{
			if(skin){
				skin.gotoAndStop(3);
			}
		}
	}
}