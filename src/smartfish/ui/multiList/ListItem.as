package smartfish.ui.multiList
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import smartfish.utils.DisplayObjectUtils;
	
	/**
	 * 
	 * @author chenyonghua
	 * 
	 */		
	public class ListItem extends Sprite implements IListItem
	{
		protected var _itemId:int = -1;
		protected var _data:Object;
		protected var skin:MovieClip;
		public function ListItem()
		{			
			super();
		}
		
		public function setSkin(mov:MovieClip):void
		{
			skin = mov;
			this.addChild(skin);
			DisplayObjectUtils.mapSymbol(skin,this);
		}
		
		public function set itemId(value:int):void
		{
			_itemId = value;
		}
		
		public function get itemId():int
		{
			return _itemId;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			if(_data)
			{
				this.visible = true;
				initlize();
			}else{
				this.visible = false;
			}
		}
		
		public function get data():Object
		{
			
			return _data;
		}
		
		public function initlize():void
		{
			
		}
		
		public function get body():Object
		{
			
			return this;
		}
		
		public function update(object:Object):void
		{
			
		}
	}
}