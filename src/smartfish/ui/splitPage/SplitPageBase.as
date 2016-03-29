package smartfish.ui.splitPage
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import smartfish.ui.multiList.IListItem;
	
	/**
	 * ...
	 * @author Luke 563723791@qq.com
	 */
	public class SplitPageBase extends Sprite
	{
		private var _container:Sprite
		
		//显示列表
		private var _list:Array;
		//垃圾列表
		private var _listTrash:Array;
		//遮罩
		private var _mask:Shape;
		
		private var colNum:int = 1;
		private var rowNum:int = 1;
		
		private var _data:Array;
		
		private var _itemCls:Class;
		private var _spaceW:Number;
		private var _spaceH:Number;
		private var itemInstance:DisplayObject;
		
		private var _page:int = 1;
		private var _totalPage:int = 1;
		private var _startIndex:int = 0;
		private var curBitmap:Bitmap;
		private var isToggle:Boolean   = true;
		
		private var points:Array = [];
		
		public var pageUpdate:Function = null;
		public var checkPageStatusFun:Function = null;
		/**
		 *  
		 * @param item        children's item class
		 * @param width       whole sprite's width
		 * @param height      whole sprite's height
		 * @param space       interval between two items
		 * @param skinClass   skin class
		 * @param isDrawMask  whether mask or not
		 * 
		 */		
		public function SplitPageBase(itemCls:Class, row:int, col:int, spaceW:int,spaceH:int,skinCls:Class = null,isToggle:Boolean = true) 
		{
			colNum              = col;
			rowNum              = row;
			_spaceW				= spaceW;
			_spaceH				= spaceH;
			_itemCls			= itemCls;			
			this.isToggle		= isToggle;
						
			itemInstance        = new _itemCls();
			if((itemInstance.width == 0 || itemInstance.height == 0 ) && skinCls != null){
				itemInstance        = new skinCls();
			}
			
			this.childSkin      = skinCls;
			
			this.initilize();
			
			drawMask(0,0,(itemInstance.width + spaceW)*row - spaceW,(itemInstance.height + spaceH)*col-spaceH);
		}
		
		/**
		 * init
		 */
		private function initilize():void
		{
			_list				= [];
			_listTrash			= [];
			
			_container			= new Sprite();
			
			addChild(_container);
			
			curBitmap = new Bitmap();
			this.addChild(curBitmap);
			
			refreshListDisplayItems();
		}
		
		/**
		 * 刷新显示对象中的元素
		 */
		private function refreshListDisplayItems():void
		{
			var i:int
			var max:int	= childrenNumber;
			var item:IListItem;
			
			for (i = 0; i < max; i++)
			{
				item		= getNewItem();
				item.alpha 		= 1;
				item.visible = false;
				if(childSkin){
					item.setSkin(new _childSkin());
				}				
				item.x      = (this.itemWidth + this._spaceW) * (i % this.rowNum);
				item.y      = (this.itemHeight + this._spaceH) * Math.floor(i / this.rowNum);		
				points.push(new Point(item.x,item.y));
				_list.push(item);
			}
		}
		
		/**
		 * 获取新的子项
		 * @return
		 */
		protected function getNewItem():IListItem
		{
			var item:IListItem;
			if (_listTrash.length > 0)
			{
				item	= _listTrash.shift() as IListItem;
			}else
			{
				item	= _container.addChild(new _itemCls()) as IListItem;
			}
			return item;
		}
		
		
		
		
		/**
		 * 刷新列表数据
		 */		
		public function refreshListData():void {
			var i:uint;
			var item:IListItem
			var len:int = this._list.length;
			for (i = 0; i < len;i++ ){
				item                = this._list[i];
				item.alpha 			= 1;
				item.itemId			= this._startIndex + i;
				item.x				= points[i].x;
				item.y				= points[i].y;
				item.data           = this._data[item.itemId];
				if (_params)
					item.update(_params);
			}			
		}
		
		/**
		 * 更新参考值 
		 * @param params
		 * 
		 */		
		private var _params:Object;
		public function updateReference(params:Object = null,isRefresh:Boolean = false):void{
			_params = params;
			if(isRefresh){
				var i:uint;
				var item:IListItem;
				var len:int = this._list.length;
				for (i = 0; i < len;i++ ){
					item                = this._list[i];
					if(_params)item.update(_params);
				}
			}
		}
		
		/**
		 * 查找ITEM
		 * @param searchField
		 * @param value
		 * @return 
		 * 
		 */		
		public function searchItem(searchField:String,filedValue:Object):IListItem{
			var item:IListItem;
			var len:int = this._list.length;
			var i:int;
			for (i = 0; i < len;i++ ){
				item                = this._list[i];
				if(item.data && item.data[searchField] == filedValue){
					return item;
					break;
				}
			}
			return null;
		}
		
		/**
		 * update single item 
		 * @param searchField
		 * @param filedValue
		 * @param value
		 * 
		 */		
		public function updateItem(searchField:String,filedValue:Object,value:Object):void{
			var item:IListItem = searchItem(searchField,filedValue);
			if(item){
				item.data = value;
			}
			updateItemData(searchField,filedValue,value);
		}
		
		/**
		 *  查找数据池里面的数据
		 * @param searchField
		 * @param filedValue
		 * @return 
		 * 
		 */		
		public function searchItemData(searchField:String,filedValue:Object):Object{
			var o:Object;
			var len:int = data.length;
			var i:int;
			for (i = 0; i < len;i++ ){
				o = this.data[i];
				if(o && o[searchField] == filedValue){
					return o;
					break;
				}
			}
			return null;
		}
		
		/**
		 * 只更新数据 
		 * @param searchField
		 * @param filedValue
		 * @param value
		 * 
		 */		
		public function updateItemData(searchField:String,filedValue:Object,value:Object):void{
			var o:Object;
			var len:int = data.length;
			var i:int;
			for (i = 0; i < len;i++ ){
				o = this.data[i];
				if(o && o[searchField] == filedValue){
					data[i] = value;
					break;
				}
			}
		}
		
		/**
		 * 删除某个对象 
		 * @param value
		 * 
		 */		
		public function removeItem(searchField:String,filedValue:Object):void{
			
			//先在_list里面找到ItemList，删除后，再删除data里面的数据。
			var item:IListItem;
			var index:int = -1;
			var targetX:Number;
			var targetY:Number;
			var lastX:Number;
			var lastY:Number;
			lastX = (itemWidth + _spaceW) *  (rowNum-1);
			lastY = (itemHeight + _spaceH) * (colNum - 1);
			var removeItem:IListItem = null;
			for (var i:int = 0, len:int = list.length; i < len; i++)
			{
				item = list[i];
				if(item && item.data)
				{
					if(item.data[searchField] == filedValue)
					{
						targetX = points[i].x;
						targetY = points[i].y;
						_container.setChildIndex(item.body as DisplayObject,0);
						removeItem = item;
						item.x      = lastX + item.width + _spaceW;
						item.y      = lastY;
						item.alpha	= 0;
						index = i;
					}else if(index != -1)
					{
						Tweener.addTween(item,{time:.5,delay:0.2+0.2*(i-index-1),x:targetX,y:targetY,transition:Equations.easeOutExpo});
						targetX = points[i].x;
						targetY = points[i].y;
					}
				}
			}
			
			//把删除的对象放到最后面
			list.push(list.splice(index,1)[0]);
			
			//删除数据
			var o:Object;
			len = data.length;
			for (i = 0; i < len;i++ ){
				o = this.data[i];
				if(o && o[searchField] == filedValue){
					data.splice(i,1);
				}
			}
			
			//重新计算总页数
			totalPage  = Math.ceil(_data.length / this.childrenNumber);
			if(startIndex >= data.length)
			{
				page--;
			}
			else
			{
				if(removeItem)
				{
					//给它赋值
					removeItem.data = data[startIndex + childrenNumber-1];
					if(removeItem.data)
					{
						Tweener.addTween(removeItem,{time:.5,x:lastX,delay:0.2+0.2*(points.length-index-1),alpha:1});
					}
				}	
				if(null != pageUpdate)
				{
					pageUpdate.apply(null,[_page]);
				}
			}
			if(null != checkPageStatusFun)
			{
				checkPageStatusFun.apply(null);
			}
		}
		
		/**
		 * 设置列表数据
		 * @param value
		 * 
		 */		
		public function set data(value:Array):void
		{
			if(isClearing)
			{
				isClearing = false;
			}
			_data	         = value;
			reset();
			refreshListData();
			appear();
		}
		
		private function reset():void
		{
			this._page       = 1;
			this._startIndex = 0;
			this._totalPage  = Math.ceil(_data.length / this.childrenNumber);
			if(this._totalPage <1){
				this._totalPage = 1;
			}
			if(null != pageUpdate)
			{
				pageUpdate.apply(null,[_page]);
			}
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		public function set startIndex(value:int):void
		{
			_startIndex	= value;			
			refreshListData();
		}
		
		public function get startIndex():int
		{
			return _startIndex;
		}
		
		public function get childrenNumber():int {
			return rowNum * colNum;
		}
				
		/**
		 * 页码
		 */
		private var targetX:int;
		public function set page(value:int):void {
			if(isTransition) return;
			value = checkPage(value);			
			if (this._page != value) {				
				if(this.isToggle){
//					if (this._page > value) {
//						targetX           = _container.width;
//						this._container.x = - _container.width;
//					}else {
//						targetX           = - _container.width;
//						this._container.x = _container.width;
//					}	
//					togglePage();
				}
				this._page	= value;
				startIndex  = (this._page-1) * childrenNumber;
				appear();
				if(null != pageUpdate)
				{
					pageUpdate.apply(null,[_page]);
				}
			}			
		}
		
		public function get page():int {
			return this._page;
		}
		
		public function checkPage(value:int):int {
			if (value >= this.totalPage) {
				value = this.totalPage;
			}else if (value <= 1){
				value = 1;
			}
			if(value == 0) return 1;
			return value;
		}
		
		public function togglePage():void {
			drawBitmap(_container, curBitmap);	
			toggleEffect();
		}
		
		private var isTransition:Boolean = false;
		/**
		 * 出现效果，后期有时间记得把这块提出来做为组件，由外部提供。
		 * 
		 */	
		public function appear():void
		{
			isTransition = true;
			var item:IListItem;
			var bitmap:Bitmap;
			var offsetX:Number;
			var offsetY:Number;
			for (var i:int = 0, len:int = list.length; i < len; i++)
			{
				item 			= list[i];				
				if(item.data == null)
				{
					continue;
				}
				item.alpha 		= 0;
				bitmap			= new Bitmap(); 
				drawBitmap(item.body as Sprite,bitmap);
				offsetX			= bitmap.x;
				offsetY			= bitmap.y;
				bitmap.x 		= points[i].x + bitmap.width/2 + offsetX;
				bitmap.y 		= points[i].y + bitmap.height/2 + offsetY;
				bitmap.scaleX   = .1;
				bitmap.scaleY 	= .1;
				bitmap.alpha	= 0;
				_container.addChild(bitmap);
				isTransition = true;
				Tweener.addTween(bitmap,{time:0.4,alpha:1,delay:0.08*i,scaleX:1,scaleY:1,x:points[i].x + offsetX,y:points[i].y + offsetY,transition:Equations.easeOutBack,onComplete:function (bit:Bitmap,theItem:IListItem):void{
					_container.removeChild(bit);
					theItem.alpha 		= 1;
					isTransition 		= false;
				},onCompleteParams:[bitmap,item]});
			}
		}
		
		private var isClearing:Boolean = false;
		/**
		 * 清除数据 
		 * 
		 */		
		public function clear():void
		{
			isClearing = true;
			var item:IListItem;
			var bitmap:Bitmap;
			for (var i:int = 0, len:int = list.length; i < len; i++)
			{
				item 			= list[i];				
				Tweener.removeTweens(item,alpha);
				if(item.data == null)
				{
					continue;
				}
				item.alpha 		= 0;
				bitmap			= new Bitmap(); 
				drawBitmap(item.body as Sprite,bitmap);
				bitmap.x 		= points[i].x;
				bitmap.y 		= points[i].y;
				_container.addChild(bitmap);
				Tweener.addTween(bitmap,{time:0.4,alpha:0,delay:0.1*i,x:item.x+bitmap.width/2,y:item.y+bitmap.height/2,scaleX:.1,scaleY:.1,x:item.x,y:item.y,transition:Equations.easeOutBack,onComplete:function (bit:Bitmap,theItem:IListItem):void{
					_container.removeChild(bit);
					if(isClearing)
					{
						data 				= [];
					}
				},onCompleteParams:[bitmap,item]});
			}
		}
		
		private function toggleEffect():void {						
			curBitmap.x      = 0;
			curBitmap.alpha  = 1;
			
			Tweener.addTween(curBitmap, { alpha:0,x:targetX, time:.5,transition:Equations.easeOutExpo,onComplete:function ():void{curBitmap.x = 0}} );
			Tweener.addTween(_container, { x:0, time:.5,transition:Equations.easeOutExpo,onComplete:function ():void{curBitmap.x = 0}} );
		}
		
		/**
		 * draw a bitmap for the toggleEffect 
		 * @param mc
		 * @param bitmap
		 * 
		 */		
		private function drawBitmap(mc:Sprite, bitmap:Bitmap,targetCoordinateSpace:DisplayObject = null):void {			
			if(mc.width == 0 || mc.height ==0){
				return;
			}
			var rect:Rectangle;			
			var matrix:Matrix;
			var bmp:BitmapData;
			rect		= mc.getBounds(targetCoordinateSpace == null?mc:targetCoordinateSpace);
			matrix		= new Matrix();
			matrix.translate( -rect.x, -rect.y);			
			bmp		= new BitmapData(mc.width, mc.height, true, 0);
			bmp.draw(mc, matrix, null, null, null, true);
			bitmap.bitmapData	= bmp;
			bitmap.width		= rect.width;
			bitmap.height		= rect.height;
			bitmap.x			= rect.x;
			bitmap.y			= rect.y;
		}
		
		/**
		 * total page
		 */
		public function get totalPage():int {
			return this._totalPage
		}
		public function set totalPage(value:int):void {
			this._totalPage	= value;
		}
		/**
		 * if there need a mask,it will do this
		 */
		public function drawMask(targetX:Number, targetY:Number, mWidth:Number, mHeight:Number):void
		{
			if(_mask == null){
				_mask = new Shape();
				this.mask = _mask;
				addChild(_mask);
			}
			var rect:Rectangle = this.itemInstance.getBounds(itemInstance as DisplayObject);
			_mask.graphics.clear();
			_mask.graphics.beginFill(0, 1);
			_mask.graphics.drawRect(targetX+rect.x, targetY+rect.y, mWidth, mHeight);
			_mask.graphics.endFill();
		}
		
		/**
		 * the single child's width
		 */
		public function get itemWidth():Number {	
			return this.itemInstance.width;
		}
		
		/**
		 * the single child's height
		 */
		public function get itemHeight():Number {
			return this.itemInstance.height;
		}
		
		/**
		 * children's skin
		 */
		private var _childSkin:Class;
		public function set childSkin(value:Class):void {
			_childSkin = value;
		}
		public function get childSkin():Class {
			return this._childSkin;
		}
		
		public function get list():Array{
			return _list;
		}
	}
	
}