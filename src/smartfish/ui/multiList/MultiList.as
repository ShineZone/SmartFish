package smartfish.ui.multiList
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import smartfish.utils.Direction;

	/**
	 * QQ:563723791 
	 * @author Luke.Chen
	 * 多行列表滚动
	 * 支持动态行列
	 * 
	 * eg.  
	 * 	var list = new MultiList(MultiListDemoItem,classLibrary.getClass("PageItemUI"),3,5,10,10,Direction.HORIZONTAL);
	 */	
	public class MultiList extends Sprite
	{
		private var itemClazz:Class;
		private var skinClazz:Class;
		private var row:int;
		private var col:int;
		private var rowSpace:int;
		private var colSpace:int;
		private var _direction:String;
		
		private var mContainer:Sprite;
		private var mList:Array;
		
		private var _data:Array;
		private var _currentPoint:Number = 0;
		private var _index:int;
		private var _mask:Sprite;
		private var itemInstance:IListItem;
		
		/**
		 * 构造方法
		 * @param clazz     	单个item的类，必须得继承于MultiListItem.
		 * @param skinClazz		item所用到的皮肤的素材类，可以为null;
		 * @param row			行
		 * @param col			列
		 * @param rowSpace		行间距
		 * @param colSpace		列间距
		 * @param direction		方向：Direction.HORIZONTAL 或 Direction.VERTICAL
		 * 
		 */		
		public function MultiList(clazz:Class,skinClazz:Class, row:int, col:int, rowSpace:int,colSpace:int,direction:String = Direction.HORIZONTAL)
		{
			this.itemClazz 		= clazz;	
			this.skinClazz 		= skinClazz;	
			this.row 			= row;	
			this.col 			= col;	
			this.rowSpace 		= rowSpace;	
			this.colSpace 		= colSpace;		
			this.direction		= direction;
			itemInstance		= new clazz();
			
			if(skinClazz != null)
			{
				itemInstance.setSkin(new skinClazz());
			}
			
			//容器
			mContainer			= new Sprite();
			this.addChild(mContainer);
			
			//遮罩层
			_mask				= new Sprite();
			this.addChild(_mask);
			
			mContainer.mask 	= _mask;
			
			make();
			drawMask();
		}
		
		/**
		 * 设置跳转控制器 
		 * @param skin
		 * 
		 */		
		public function setController(skin:MovieClip):void
		{
			var controller:MultiListController = new MultiListController(this,skin);
		}
		
		/**
		 * 绘制遮罩 
		 * @param drawX
		 * @param drawY
		 * @param drawWidth
		 * @param drawHeight
		 * 
		 */		
		public function drawMask(drawX:int =0, drawY:int=0, drawWidth:int =0, drawHeight:int=0):void
		{
			var rect:Rectangle = this.itemInstance.getBounds(itemInstance.body as DisplayObject);
			_mask.graphics.clear();
			_mask.graphics.beginFill(0, 0.5);
			_mask.graphics.drawRect(drawX + rect.x, drawY + rect.y, drawWidth ==0?((rect.width + this.colSpace) * this.col - this.colSpace):drawWidth, drawHeight == 0?((rect.height + this.rowSpace) * this.row - this.rowSpace):drawHeight);
			_mask.graphics.endFill();
		}
		
		/**
		 * 刷新显示对象中的元素
		 */
		private function make():void
		{
			mList = [];
			
			var len_1:int;
			var len_2:int;
			if(_direction == Direction.HORIZONTAL){
				len_1 = row;
				len_2 = col;
			}
			else
			{
				len_1 = col;
				len_2 = row;
			}
			
			var item:IListItem;
			for (var i:int = 0; i < len_1 + 1; i++)
			{
				if(mList[i] == null)
					mList[i] = [];
				for (var j:int = 0; j < len_2; j++)
				{
					item		= getNewItem();
					item.itemId	= -1;
					mList[i].push(item);
				}
			}
		}
		
		/**
		 * 获取新的子项
		 * @return
		 */
		protected function getNewItem():IListItem
		{
			var item:IListItem = mContainer.addChild(new itemClazz()) as IListItem;
			if(skinClazz != null)
			{
				item.setSkin(new skinClazz());
			}
			return item;
		}
		
		/**
		 * 设置滚动方向 
		 * @param value
		 * 
		 */		
		protected function set direction(value:String):void
		{
			_direction = value;
		}

		/**
		 * 获取列表数据 
		 * @return 
		 * 
		 */		
		public function get data():Array
		{
			return _data;
		}
 
		/**
		 * 设置列表数据 
		 * @return 
		 * 
		 */
		public function set data(value:Array):void
		{
			_data 			= value;
			_currentPoint   = 0;
			_index		= 0;
			fill(true);
		}
		
		/**
		 * 执行滚动时的数据更新 
		 * @param isAll
		 * 
		 */		
		public function fill(isAll:Boolean = false):void
		{
			var i:int
			var j:int;
			var len:int			= mList.length;
			var item:IListItem;			
			var isNeed:Boolean;
			var needList:Array	= [];
			var outList:Array	= [];
			var rowNum:int = -1;
			if(isAll){
				for (i = 0; i < len; i++)
				{
					rowNum = int((_currentPoint + (i * itemSize)) / itemSize);
					for (j = 0; j < mList[i].length; j++)
					{
						item							= mList[i][j];
						if(_direction == Direction.HORIZONTAL){
							item.itemId						= rowNum * col + j;
							item.data						= _data[item.itemId-col];						
							item.x							= j * (itemInstance.width + colSpace);
							item.y							= (rowNum * itemSize)-_currentPoint - itemSize;
						}
						else
						{
							item.itemId						= rowNum * row + j;
							item.data						= _data[item.itemId-row];						
							item.x							= (rowNum * itemSize)-_currentPoint - itemSize;
							item.y							= j * (itemInstance.height + rowSpace);
						}						
					}
				}
			}
			else
			{
				for (i = 0; i < len; i++)
				{
					needList.push(Math.ceil((_currentPoint + (i* itemSize)) / itemSize));
				}
				//找到显示区域外的子项
				for (i = 0; i < len; i++)
				{
					if(_direction == Direction.HORIZONTAL){
						rowNum		= int(mList[i][0].itemId / col);						
					}
					else
					{
						rowNum		= int(mList[i][0].itemId / row);
					}
					isNeed		= false;
					for (j = 0; j < needList.length; j++)
					{
						if (rowNum == needList[j])
						{
							isNeed	= true;
							needList.splice(j, 1);
							break;
						}
					}
					if (!isNeed)
					{
						outList.push(mList[i]);
					}else
					{
						for (var k:int = 0, llen:int = mList[i].length; k < llen; k++)
						{
							item 	= mList[i][k];
							
							if(_direction == Direction.HORIZONTAL){
								item.y	= (int(item.itemId / col) * itemSize) - _currentPoint - itemSize;						
							}
							else
							{
								item.x	= (int(item.itemId / row) * itemSize) - _currentPoint - itemSize;
							}
						}						
					}
				}
				//列表外的子项修正到显示区域内
				len	= outList.length;
				var temp:Array;
				var tlen:int;
				for (i = 0; i < len; i++)
				{
					temp 	= outList[i];
					rowNum 	= needList[i];
					for (j = 0, tlen = temp.length; j < tlen; j++)
					{
						item				= temp[j];
						
						if(_direction == Direction.HORIZONTAL){
							item.itemId			= rowNum * col + j;
							item.data			= _data[item.itemId-col];
							item.y				= (int(item.itemId / col) * itemSize) - _currentPoint - itemSize;
						}
						else
						{
							item.itemId			= rowNum * row + j;
							item.data			= _data[item.itemId-row];
							item.x				= (int(item.itemId / row) * itemSize) - _currentPoint - itemSize;
						}					
					}					
				}
			}
		}
		
		/**
		 * 获取行列的索引 
		 * @return 
		 * 
		 */		
		public function get index():int
		{
			return _index;
		}
		
		/**
		 * 设置行列的索引 
		 * @return 
		 * 
		 */	
		public function set index(value:int):void
		{
			if(value <=0)
			{
				value = 0;
			}
			else if(value >= totalIndex)
			{
				value = totalIndex;
			}
			if(Math.floor(_index - value) >= 5)
			{
				if(_index < value)
				{
					currentPoint = (value - 5) * itemSize;
				}
				else
				{
					currentPoint = (value + 5) * itemSize;
				}
			}
			_index = value;
			Tweener.addTween(this,{time:.5,currentPoint:index * itemSize,transition:Equations.easeOutExpo});
		}
		
		/**
		 * 获取列表位置 
		 * @return 
		 * 
		 */		
		public function get currentPoint():Number
		{
			return _currentPoint;
		}

		/**
		 * 设置列表位置 
		 * @return 
		 * 
		 */	
		public function set currentPoint(value:Number):void
		{
			_currentPoint = value;
			if(_currentPoint >= totalIndex * itemSize)
			{
				_currentPoint 	= totalIndex * itemSize;
			}else if(_currentPoint<=0){
				_currentPoint = 0;
			}
			fill();
		}
		
		/**
		 * 单页的行或列数 
		 * @return 
		 * 
		 */		
		public function get pageNum():int
		{
			if(_direction == Direction.HORIZONTAL)
			{
				return row;
			}
			return col;
		}
		
		/**
		 * 总索引数 
		 * @return 
		 * 
		 */		
		public function get totalIndex():int
		{
			var num:int;
			if(_direction == Direction.HORIZONTAL)
			{
				num = Math.ceil(data.length / col) - row;
			}
			else if(_direction == Direction.VERTICAL)
			{
				num = Math.ceil(data.length / row) - col;
			}
			
			return num <0?0:num;
		}
		
		/**
		 * 行或列的间距 
		 * @return 
		 * 
		 */		
		private function get itemSize():int
		{
			if(_direction == Direction.HORIZONTAL)
			{
				return itemInstance.height + rowSpace;
			}
			return itemInstance.width + colSpace;
		}
		
		// --------------------------------------------------------
		// -------------------- 对数据的查询操作 --------------------
		// --------------------------------------------------------
		
		/**
		 * 查找ITEM
		 * @param searchField
		 * @param value
		 * @return 
		 * 
		 */		
		public function searchItem(searchField:String,filedValue:Object):IListItem{
			var item:IListItem;
			var len:int = this.mList.length;
			var i:int;
			for (i = 0; i < len;i++ ){
				for (var j:int = 0, lenj:int = mList[i].length; j < lenj; j++)
				{
					item                = this.mList[i][j];
					if(item.data && item.data[searchField] == filedValue){
						return item;
						break;
					}
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
		 * 执行所有ITEM的update方法 
		 * @param object
		 * 
		 */		
		public function updateItems(object:Object):void
		{
			var item:IListItem;
			var len:int = this.mList.length;
			var i:int;
			for (i = 0; i < len;i++ ){
				for (var j:int = 0, lenj:int = mList[i].length; j < lenj; j++)
				{
					item                = this.mList[i][j];
					if(item.data){
						item.update(object);
					}					
				}
			}
		}
		
		/**
		 * 只更新数据池里的数据 
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
	}
}