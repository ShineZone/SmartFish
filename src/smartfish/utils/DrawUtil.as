package smartfish.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DrawUtil
	{
		public function DrawUtil()
		{
		}
		
		public static function draw(source:DisplayObject, scale:Number = 1,transparent:Boolean = true, fillColor:uint = 0x00000000):Bitmap{
			var bitmap:Bitmap;
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
			
//			//剔除边缘空白像素
//			var realRect:Rectangle = bitData.getColorBoundsRect(0xFF000000, 0x00000000, false);
//			
//			if (!realRect.isEmpty() && (bitData.width != realRect.width || bitData.height != realRect.height))
//			{				
//				var realBitData:BitmapData = new BitmapData(realRect.width, realRect.height, transparent, fillColor);
//				realBitData.copyPixels(bitData, realRect, new Point());
//				
//				bitData.dispose();
//				bitData = realBitData;
//				x += realRect.x;
//				y += realRect.y;				
//			}
			bitmap   = new Bitmap(bitData);
			bitmap.x = x;
			bitmap.y = y;
			bitmap 	 = clearWhiteColor(bitmap);
			return bitmap;
		}
		
		/**
		 * 清除空白像素 
		 * @param bitData
		 * @return 
		 * 
		 */		
		public static function clearWhiteColor(bitmap:Bitmap):Bitmap{
			var bitData:BitmapData = bitmap.bitmapData; 
			var rect:Rectangle = bitData.getColorBoundsRect(0xFF000000, 0x00000000, false);			
			if (!rect.isEmpty() && (bitData.width != rect.width || bitData.height != rect.height))
			{				
				var realBitData:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
				realBitData.copyPixels(bitData, rect, new Point());				
				bitData.dispose();
				bitmap.bitmapData 	 = realBitData;	
				bitmap.x 			+= rect.x;
				bitmap.y 			+= rect.y;
			}	
			return bitmap;
		}
	}
}