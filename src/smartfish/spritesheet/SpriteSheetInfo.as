package smartfish.spritesheet
{
	import flash.display.MovieClip;

	/**
	 * SpriteSheet 信息 
	 * @author chenyonghua
	 * 
	 */	
	public class SpriteSheetInfo
	{
		public var id:String;
		
		public var totalFrames:int;
		
		public var isDrawComplete:Boolean = false;
		
		public var movie:MovieClip;
		
		public var transparent:Boolean;
		
		public var fillColor:int;
		
		public var scale:Number;
		
		public var frames:Vector.<SpriteSheetFrameObject>;
		
		public var drawing:Boolean = false;
		
		public var callbacks:Array = [];
		public function SpriteSheetInfo()
		{
			
		}
	}
}