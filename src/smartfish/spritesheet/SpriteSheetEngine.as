package smartfish.spritesheet 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import smartfish.utils.DisplayObjectUtils;
	
	/**
	 * Luke 
	 * @author chenyonghua
	 * 
	 */	
	public class SpriteSheetEngine
	{
		protected static var _instance:SpriteSheetEngine;
		private var drawDict:Dictionary 				= new Dictionary();
		private var cacheDict:Dictionary 				= new Dictionary();
				
		private var waitDic:Dictionary 					= new Dictionary();
		private var waitCallbackList:Dictionary    		= new Dictionary();
		private var waitCallbackParamsList:Dictionary   = new Dictionary();
		private var pot:Point = new Point();
		
		public function SpriteSheetEngine(singleton:SingletonEnforcer){
			
		}
		
		/**
		 * 单例
		 * @return
		 */
		public static function getInstance():SpriteSheetEngine {
			if (!_instance) {
				_instance = new SpriteSheetEngine(new SingletonEnforcer());
			}
			return _instance;
		}
		
		private function checkStatus(dis:DisplayObject,name:String,callback:Function = null,callbackParams:Array=null):Boolean{
			if(callbackParams == null){
				callbackParams =[];
			}
			
			if (isInWaitList(name))	{
				if(callback != null){
					waitCallbackList[name].push(callback);
					waitCallbackParamsList[name].push(callbackParams);
				}
				return false;
			}
			if (cacheDict[name]){
				if(callback != null){
					waitCallbackList[name].push(callback);
					waitCallbackParamsList[name].push(callbackParams);
					completeCallback(name);
				}
				return false;
			}
			
			waitDic[name] = dis;
			
			if(waitCallbackList[name] == null){
				waitCallbackList[name]       = [];
				waitCallbackParamsList[name] = [];
			}	
			if(callback != null){
				waitCallbackList[name].push(callback);
				waitCallbackParamsList[name].push(callbackParams);	
			}
			return true;
		}
		
		/**
		 * 切割位图序列 
		 * @param source
		 * @param name
		 * @param cellWidth
		 * @param cellHeight
		 * @param scale
		 * @param callback
		 * @param callbackParams
		 * 
		 */		
		public function cacheBitmap(source:Bitmap,name:String,cellWidth:int, cellHeight:int, scale:Number = 1,callback:Function = null,callbackParams:Array=null):void{
			if(!checkStatus(source,name,callback,callbackParams)){
				return;
			}
			var bitVector:Vector.<SpriteSheetFrameObject> = cacheDict[name];			
			if(bitVector == null){
				bitVector       = new Vector.<SpriteSheetFrameObject>;				
			}
			
			var row:int = Math.floor( source.height / cellHeight);
			var col:int = Math.floor( source.width / cellWidth);
			var i:int = 0;
			var j:int = 0;
			var x:Number = 0;
			var y:Number = 0;
			var time:int = getTimer();
			while(i<row){
				j = 0;
				while(j<col){									
					var bitData:BitmapData = new BitmapData(Math.ceil(cellWidth * scale), Math.ceil(cellHeight * scale), true, 0x00000000);
					bitData.draw(source, new Matrix(scale, 0, 0, scale, -cellWidth * j * scale, -cellHeight * i * scale), null, null, null, true);
															
					var bitInfo:SpriteSheetFrameObject = new SpriteSheetFrameObject();
					bitInfo.x = x;
					bitInfo.y = y;
					bitInfo.bitmapData = bitData;
					bitVector.push(bitInfo);
					j++;
				}
				i++;
			}			
			trace("花费时间:",getTimer() - time ,"ms,把"+name+"绘制成了" + i*j +"张位图");
			cacheDict[name] = bitVector;
			completeCallback(name);
			delete waitDic[name];
		}
		
		/**
		 * 缓存影片动画 
		 * @param name
		 * @param mov
		 * @param callback
		 * @param callbackParams
		 * 
		 */		
		public function cacheMovieClip(name:String,mov:MovieClip,fillColor:uint = 0x00000000, scale:Number = 1,callback:Function = null,callbackParams:Array=null):void{
			if(checkStatus(mov,name,callback,callbackParams)){
				makeBitmapMovie(name,mov,true,fillColor,scale);
			}
		}		
		/**
		 * 判断是否在等待列表 
		 * @param name
		 * @return 
		 * 
		 */		
		private function isInWaitList(name:String):Boolean{
			return waitDic[name] != null;
		}
		
		
		/**
		 * 转换位图数据
		 * @param	mc				影片剪辑
		 * @param	transparent	          是否透明
		 * @param	fillColor		填充色
		 * @param	scale			缩放
		 * @return
		 */
		private function makeBitmapMovie(name:String,mov:MovieClip, transparent:Boolean = true, fillColor:uint = 0x00000000, scale:Number = 1):Vector.<SpriteSheetFrameObject>
		{
			
			var bitVector:Vector.<SpriteSheetFrameObject> = cacheDict[name];
			
			if(bitVector == null){
				bitVector       = new Vector.<SpriteSheetFrameObject>;				
			}
			
			var i:int = 0;
			var c:int = mov.totalFrames;
			
			mov.gotoAndStop(1);
			var time:int = getTimer();
			while (i < c)
			{				
				var bitInfo:SpriteSheetFrameObject = drawBitmap(mov, transparent, fillColor, scale);					
				var movChildren:Array = DisplayObjectUtils.searchChild(mov, MovieClip);	
				bitInfo.frameLabel = mov.currentFrameLabel;
				mov.nextFrame();				
				var j:int = 0;
				var k:int = movChildren.length;
				while (j < k) 
				{					
					var childMC:MovieClip = movChildren[j];
					if(childMC.currentFrameLabel){
						bitInfo.frameLabel = childMC.currentFrameLabel;
					}
					childMC.nextFrame();					
					j++;
				}	
//				trace("bitInfo.frameLabel =" + bitInfo.frameLabel);
				bitVector.push(bitInfo);
				i++;
			}
			cacheDict[name] = bitVector;
			completeCallback(name);
			delete waitDic[name];
			trace("花费时间:",getTimer() - time ,"ms,把"+name+"绘制成了"+c+"张位图");
			return bitVector;
		}
		
		/**
		 * 绘制位图 
		 * @param source
		 * @param transparent
		 * @param fillColor
		 * @param scale
		 * @return 
		 * 
		 */		
		private function drawBitmap(source:MovieClip, transparent:Boolean = true, fillColor:uint = 0x00000000, scale:Number = 1):SpriteSheetFrameObject
		{
			
			var rect:Rectangle = source.getBounds(source);
			var x:int = Math.round(rect.x * scale);
			var y:int = Math.round(rect.y * scale);
			
			if (rect.isEmpty())
			{
				rect.width = 1;
				rect.height = 1;
			}
			
			var bitData:BitmapData = new BitmapData(Math.ceil(rect.width * scale), Math.ceil(rect.height * scale), transparent, fillColor);
			bitData.draw(source, new Matrix(scale, 0, 0, scale, -x, -y), null, null, null, true);
			
			//查找非空白区域
			var colorBoundsRect:Rectangle = bitData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			
			if (!colorBoundsRect.isEmpty() && (bitData.width != colorBoundsRect.width || bitData.height != colorBoundsRect.height))
			{				
				var colorBoundsBitmapData:BitmapData = new BitmapData(colorBoundsRect.width, colorBoundsRect.height, transparent, fillColor);
				colorBoundsBitmapData.copyPixels(bitData, colorBoundsRect, pot);
				
				bitData.dispose();
				bitData = colorBoundsBitmapData;
				x += colorBoundsRect.x;
				y += colorBoundsRect.y;				
			}
			
			var bitInfo:SpriteSheetFrameObject = new SpriteSheetFrameObject();
			bitInfo.x = x;
			bitInfo.y = y;
			bitInfo.bitmapData = bitData;
			return bitInfo;
		}
		
		
		/**
		 * 执行回调函数 
		 * @param name
		 * 
		 */		
		private function completeCallback(name:String):void	{
			var arr:Array    = this.waitCallbackList[name];
			var params:Array = this.waitCallbackParamsList[name];			
			var len:int   = arr.length;
			for(var i:uint;i<len;i++){
				if(arr[i]){
					params[i].push(cacheDict[name]);
					(arr[i] as Function).apply(null,params[i]);
				}
			}
			this.waitCallbackList[name]       = [];
			this.waitCallbackParamsList[name] = [];
		}
				
		
		public function gc():void{
			var bfo:SpriteSheetFrameObject;
			var bitVector:Vector.<SpriteSheetFrameObject>;
			for ( var item:String in cacheDict) 
			{
				bitVector = cacheDict[item];
				for (var j:int = bitVector.length -1; j >= 0; j--) 
				{
					bfo				= bitVector[j];
					bfo.bitmapData.dispose();
					bfo.bitmapData  = null;
					bitVector.splice(j,1);
				}	
				cacheDict[item] = null;
				delete cacheDict[item];
			}			
			try{
				new LocalConnection().connect("bitmapEngine");
				new LocalConnection().connect("bitmapEngine");
			}catch(error : Error){
				
			}
			
		}
		
	}
}
class SingletonEnforcer{
	
}