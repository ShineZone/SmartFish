package smartfish.robotlegs.extensions.assets.impl
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class AssetInfo extends Object
	{
		public var content:*      				= null;
		
		internal var onCompletes:Array	   		= [];
		
		internal var onCompleteParams:Array		= [];
		
		internal var onUpdates:Array       		= [];
		
		internal var onUpdateParams:Array       = [];
		
		public function AssetInfo()
		{
			super();
		}
		
		public function getClass(clsName:String):Class{
			if(content && content is DisplayObject){				
				if(content.loaderInfo.applicationDomain.hasDefinition(clsName)){
					return content.loaderInfo.applicationDomain.getDefinition(clsName) as Class;				
				}
			}
			return null;
		}
		
		public function getBitmap():Bitmap{
			if(content && content is Bitmap){				
				return new Bitmap(Bitmap(content).bitmapData);
			}else{
				return null;
			}
			
		}
		
		public function getXML():XML{
			return XML(content);
		}
		
		public function getMovieClip(clsName:String):MovieClip{
			var cls:Class = getClass(clsName);
			if(cls){
				return new cls();
			}
			return null;
		}		
	}
}