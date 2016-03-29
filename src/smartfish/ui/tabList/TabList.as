package smartfish.ui.tabList
{	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import smartfish.utils.DepthUtil;
	
	public class TabList extends Sprite
	{		
		private var _direction:String;
		private var _point:String;
		private var _size:String;
		
		private var _quantity:uint;
		private var _space:int;
		private var itemCls:Class;
		private var skinCls:Class;
		private var _list:Array;
		private var _container:Sprite;
		private var _instance:ITabItem;
		
		private var _data:Array;
		private var _currentItem:ITabItem;

		public function get currentItem():ITabItem
		{
			return _currentItem;
		}

		public function set currentItem(value:ITabItem):void
		{
			if(_currentItem){
				_currentItem.onMouseOut();
			}
			_currentItem = value;			
			_currentItem.onSelect();
			refreshButtonDepth(_currentItem as DisplayObject);
		}

		/**
		 * 查找ITEM
		 * @param searchField
		 * @param value
		 * @return 
		 * 
		 */		
		public function setCurrentItem(searchField:String,filedValue:Object):void{
			var item:ITabItem;
			var len:int = this._list.length;
			var i:int;
			for (i = 0; i < len;i++ ){
				item                = this._list[i];
				if(item.data && item.data[searchField] == filedValue){
					currentItem = item;
					break;
				}
			}
		}
		
		public function TabList(cls:Class,skinCls:Class, quantity:uint, space:int, direction:String ="horizontal")
		{			
			_space				= space;
			itemCls			    = cls;
			_quantity           = quantity;
			this.direction      = direction;	
			this.skinCls        = skinCls;
			_instance           = new cls() as ITabItem;
			initlize();
		}
		
		/**
		 * 设置列表数据
		 * @param value
		 * 
		 */		
		public function set data(value:Array):void
		{
			_data	= value;			
			refreshListData();
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		private function refreshListData():void{
			var i:int;
			var item:ITabItem;			
			for (i = 0; i < _quantity; i++)
			{
				item      = _list[i];
				item.data = _data[i];
				if(item.data){
					item.buttonMode = true;
					item.addEventListener(MouseEvent.CLICK,onClick);
					item.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					item.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				}else{
					item.buttonMode = false;
					item.removeEventListener(MouseEvent.CLICK,onClick);					
					item.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					item.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				}
			}
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			var target:ITabItem = evt.currentTarget as ITabItem;
			if(currentItem == target){
				return;
			}
			target.onMouseOut();
		}
		
		protected function onMouseOver(evt:MouseEvent):void
		{
			var target:ITabItem = evt.currentTarget as ITabItem;
			if(currentItem == target){
				return;
			}
			target.onMouseOver();
		}
		
		private function onClick(evt:MouseEvent):void
		{
			var target:ITabItem = evt.currentTarget as ITabItem;
			if(currentItem == target){
				return;
			}
			currentItem = target;
		}
		
		private function refreshButtonDepth(value:DisplayObject):void{	
			_list.forEach(changeDepth);		
			DepthUtil.bringToTop(value);
		}
		
		private function changeDepth(item:*, index:int, array:Array):void{
			DepthUtil.bringToBottom(item);
		}
		
		private function initlize():void
		{
			_list				= [];
			_container			= new Sprite();
			addChild(_container);
			refreshListDisplayItems();
		}
		
		/**
		 * 刷新显示对象中的元素
		 */
		private function refreshListDisplayItems():void
		{
			var i:int
			var item:ITabItem;
			
			for (i = 0; i < _quantity; i++)
			{
				item		 = _container.addChild(new itemCls()) as ITabItem;
				if(skinCls != null){
					item.setSkin(new skinCls());
				}
				item[_point] = (item[_size] + _space) * i;
				_list.push(item);
			}
		}
		
		/**
		 * 设置方向
		 * @param value
		 * 
		 */		
		protected function set direction(value:String):void
		{
			if(_direction!=value)
			{
				_direction	= value;
				
				if(_direction == "horizontal")
				{
					this._point			= 'x';
					this._size			= 'width';
				}else if(_direction == "vertical")
				{
					this._point			= 'y';
					this._size			= 'height';
				}
			}
		}
	}
}