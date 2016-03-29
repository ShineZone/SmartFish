package smartfish.spritesheet  
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import smartfish.utils.DisplayObjectUtils;
	
	public class SpriteSheetFactory
	{
		protected static var _instance:SpriteSheetFactory;
		private var cacheDict:Dictionary = new Dictionary();
		private var pot:Point = new Point();
		
		private var _forceGcTimer:Timer;
		public function SpriteSheetFactory(singleton:SingletonEnforcer)
		{
		}
		
		
		/**
		 * 单例
		 * @return
		 */
		public static function getInstance():SpriteSheetFactory {
			if (!_instance) {
				_instance = new SpriteSheetFactory(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/**
		 * cache movie's info 
		 * @param id
		 * @param mov
		 * @param scale
		 * @param fillColor
		 * @param transparent
		 * 
		 */		
		public function cacheMovieClip(id:String
									  ,mov:MovieClip
									  ,scale:Number = 1
									  ,fillColor:uint = 0x00000000
									  ,transparent:Boolean = true
									):SpriteSheetInfo
		{
			if(cacheDict[id] != null)
			{
				return cacheDict[id];
			}
			var info:SpriteSheetInfo = new SpriteSheetInfo();
			info.id 			= id;
			info.movie 			= mov;
			info.fillColor 		= fillColor;
			info.transparent	= transparent;
			info.scale 			= scale;
			info.movie.gotoAndStop(1);
			info.totalFrames 	= mov.totalFrames;
			cacheDict[info.id]  = info;
			return info;
		}	
		
		/**
		 * cache SpriteSheetInfo from Bitmap texture
		 * @param id
		 * @param totalFrames
		 * @param scale
		 * @param fillColor
		 * @param transparent
		 * @return 
		 */		
		public function cahcheBitmap( source:Bitmap, cellWidth:int, cellHeight:int, id:String, scale:Number = 1, fillColor:uint = 0x00000000, transparent:Boolean = true ):SpriteSheetInfo
		{
			var bitVector:Vector.<SpriteSheetFrameObject> = cacheDict[id];			
			if (bitVector == null)
			{
				bitVector       = new Vector.<SpriteSheetFrameObject>;				
			}
			
			var row:int = Math.floor( source.height / cellHeight);
			var col:int = Math.floor( source.width / cellWidth);
			var i:int = 0;
			var j:int = 0;
			var x:Number = 0;
			var y:Number = 0;
			var time:int = getTimer();
			while (i<row)
			{
				j = 0;
				while (j<col)
				{									
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
			
			var info:SpriteSheetInfo = new SpriteSheetInfo();
			info.id 			= id;
			info.movie 			= null;
			info.fillColor 		= fillColor;
			info.transparent	= transparent;
			info.scale 			= scale;
			info.totalFrames 	= bitVector.length;
			info.frames 		= bitVector;
			cacheDict[info.id]  = info;
			return info;
		}
		
		/**
		 * cacheFrame 
		 * @param info
		 * @return 
		 * 
		 */		
		public function getFrame(id:String):SpriteSheetFrameObject
		{
			var info:SpriteSheetInfo = cacheDict[id];
			if(info == null || info.isDrawComplete)
			{
				return null;
			}
			var time:int = getTimer();
			var bitInfo:SpriteSheetFrameObject = drawBitmap(info.movie, info.transparent, info.fillColor, info.scale);	
			//trace("花费时间:",getTimer() - time ,"ms,绘制"+id+"第"+info.movie.currentFrame+"张位图");
			var movChildren:Array = DisplayObjectUtils.searchChild(info.movie, MovieClip);	
			bitInfo.frameLabel = info.movie.currentFrameLabel;		
			var i:int = 0;
			var len:int = movChildren.length;
			while (i < len) 
			{					
				var childMC:MovieClip = movChildren[i];
				if(childMC.currentFrameLabel){
					bitInfo.frameLabel = childMC.currentFrameLabel;
				}
				childMC.nextFrame();					
				i++;
			}		
			if(info.frames == null)
			{
				info.frames = new Vector.<SpriteSheetFrameObject>;
			}
			info.frames.push(bitInfo);
			if(info.movie.currentFrame >= info.movie.totalFrames)
			{
				info.isDrawComplete = true;
			}
			else
			{
				info.movie.nextFrame();
			}
			return bitInfo;
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
		 * 回收包含此字符串的id的animation
		 * @param idStr
		 * 
		 */		
		public function disposeConstainsId(idStr:String):void{
			for(var key:String in cacheDict) 
			{
				if(key.indexOf(idStr) >=0)
				{
					dispose(key,false);
				}
			}
			

			if(!_forceGcTimer){
				_forceGcTimer = new Timer(30000);
				_forceGcTimer.addEventListener(TimerEvent.TIMER,timeUp);
			}
			if(!_forceGcTimer.running) _forceGcTimer.start();
			
		}
		
		private function timeUp(e:TimerEvent):void
		{
			try{
				new LocalConnection().connect("bitmapEngine");
				new LocalConnection().connect("bitmapEngine");
			}catch(error : Error){
				
			}
			_forceGcTimer.stop();
		}
		/**
		 * 回收单个动画的内存 
		 * @param id
		 * @param isGC
		 * 
		 */		
		public function dispose(id:String,isGC:Boolean = true):void{
			var spriteInfo:SpriteSheetInfo = cacheDict[id];
			if(spriteInfo)
			{
				var bfo:SpriteSheetFrameObject;
				if(spriteInfo.frames){
					for (var j:int = spriteInfo.frames.length -1; j >= 0; j--) 
					{
						if(!spriteInfo.frames[j]) continue;
						bfo				= spriteInfo.frames[j];
						bfo.bitmapData.dispose();
						bfo.bitmapData  = null;
						spriteInfo.frames.splice(j,1);
					}	
				}
				spriteInfo.movie			= null;
				cacheDict[id] = null;
				delete cacheDict[id];
				if(isGC)
				{
					try{
						new LocalConnection().connect("bitmapEngine");
						new LocalConnection().connect("bitmapEngine");
					}catch(error : Error){
						
					}
				}
			}
		}
		
		/**
		 * 回收所有动画内存 
		 * 
		 */		
		public function gc():void
		{
			for each (var info:SpriteSheetInfo in cacheDict)
			{	
				dispose(info.id,false);
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