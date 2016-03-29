package smartfish.spritesheet
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	/**
	 *  Eample:
	 *  	var spriteSheet:SpriteSheet = new SpriteSheet(mc,1,"name");
	 *		bitmapClip.x = 500;
	 *		bitmapClip.y = 400;
	 *		addChild(spriteSheet);
	 * 		
	 * 		或者:
	 * 		
	 * 		var spriteSheet:SpriteSheet = new SpriteSheet();
	 * 		spriteSheet.initMovieClip(mc,1,"name");
	 * 		//spriteSheet.initBitmap(bitmap,cellWidth,cellHeight,tname,scale)
	 *		spriteSheet.x = 500;
	 *		spriteSheet.y = 400;
	 *		addChild(spriteSheet);
	 * 
	 * */
	
	/**
	 * 位图引擎
	 * @author Luke
	 * 
	 */	
	public class SpriteSheet extends Sprite implements ISpriteSheet
	{		
		private var spriteSheetInfo:SpriteSheetInfo;
		
		private var _currentFrame:int = 1;//不使用setter,getter,函数会降低效率		
		private var bitmap:Bitmap;
		private var _pause:Boolean = false;
		
		protected var _mousePoint:Point;
		protected var _basePoint:Point;
		protected var _threshold:uint = 128;
		protected var _bitmapHit:Boolean = false;
		protected var _interactiveActive:Boolean;
		protected var _transparentMode : Boolean = false;

		private var _curFrameTime:Number = 0;
		private var _fps:int = 30;
		
		public static const SPRITE_ONCE_COMPLETE:String = "sprite_once_complete";

		/**
		 * 帧频 
		 * @return 
		 * 
		 */		
		public function get fps():int
		{
			return _fps;
		}

		public function set fps(value:int):void
		{
			_fps = value;
		}

		/**
		 * 获取当前帧 
		 * @return 
		 * 
		 */		
		public function get currentFrame():int
		{
			return _currentFrame;
		}

		/**
		 * 获取总帧数 
		 * @return 
		 * 
		 */		
		public function get totalFrames():int
		{
			if(spriteSheetInfo){
				return spriteSheetInfo.totalFrames;				
			}else{
				return 1;
			}
		}
		
		/**
		 * 是否全部帧绘制完成
		 * @return 
		 * 
		 */		
		public function get isComplete():Boolean
		{
			return spriteSheetInfo.isDrawComplete;
		}

		
		/**
		 * 构造函数 
		 * @param mov
		 * @param scale
		 * @param name
		 * 
		 */		
		public function SpriteSheet(mov:MovieClip = null,scale:Number=1,name:String=null)
		{					
			interactiveActive = true; 
			
			_basePoint = new Point();
			_mousePoint = new Point();
			
			bitmap = new Bitmap();
			bitmap.pixelSnapping = PixelSnapping.ALWAYS;
			this.addChild(bitmap);
			if(mov){
				initMovieClip(mov,name,scale);
			}
//			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
//			dispose();
		}
		
		/**
		 * 绘制影片
		 * @param mov   所要绘制的影片
		 * @param tname 别名
		 * @param scale 缩放
		 * 
		 */		
		public function initMovieClip(mov:MovieClip,tname:String,scale:Number=1):void{
			if(null == mov)
			{
				trace("[initMovieClip] the movie is null!");
				return;
			}
			if(!tname){				
				tname = getQualifiedClassName(mov)  +  "_" + scale;
			}
			spriteSheetInfo 	= null;
			_currentFrame 		= 1;
			spriteSheetInfo 	= factory.cacheMovieClip(tname,mov,scale,0x00000000);
			bitmapRender.add(this);
			updateFrame();
		}
		
		/**
		 * 裁剪贴图 
		 * @param bitmap
		 * @param cellWidth
		 * @param cellHeight
		 * @param tname
		 * @param scale
		 */		
		public function initBitmap(bitmap:Bitmap, cellWidth:Number, cellHeight:Number, tname:String=null, scale:Number=1):void
		{
			if ( !tname ) 
			{				
				tname = getQualifiedClassName(bitmap) + "_" + scale;
			}
			spriteSheetInfo 	= null;
			_currentFrame 		= 1;
			spriteSheetInfo = factory.cahcheBitmap(bitmap, cellWidth, cellHeight, tname, scale );
			bitmapRender.add(this);
			updateFrame();
		}
				
		public function gotoAndPlay(frame:int,scene:String=null):void{
			var f:int = frame;
			if(f<0){
				f = 0;
			}
			_currentFrame = f;
		}
		public function gotoAndStop(frame:int,scene:String=null):void{
			stop();
			var f:int = frame;
			if(f<0){
				f = 0;
			}
			if(spriteSheetInfo.frames == null)
			{
				return;
			}
			_currentFrame = Math.min(f,spriteSheetInfo.frames.length);
			updateFrame();
		}
		
		public function play():void{
			_pause = false;
		}
		public function stop():void{
			_pause = true;
		}
		
		public function get currentFrameLabel():String{
			if(spriteSheetInfo && spriteSheetInfo.frames && spriteSheetInfo.totalFrames >= _currentFrame){
				return spriteSheetInfo.frames[_currentFrame-1].frameLabel;
			}
			return null;
		}
		
		public function onFrame(deltaTime:Number):void{	
			if(_pause)
				return;
//			_curFrameTime -= deltaTime;
//			while (_curFrameTime <= .0001 && null != spriteSheetInfo) //TODO: should this be proportional to frame length (1 / fps)?
//			{
//				_curFrameTime += 1 / fps;
//				updateFrame();
//			}
			updateFrame();
		} 
		
		private function updateFrame():void
		{
			if(spriteSheetInfo){
				if (_currentFrame > spriteSheetInfo.totalFrames){
					_currentFrame = 1;
					dispatchEvent(new Event(SPRITE_ONCE_COMPLETE));
				}
				
				//todo: should we stop the render when it's position outside the stage??
				var frame:SpriteSheetFrameObject;
				if (spriteSheetInfo.frames && spriteSheetInfo.frames.length >= _currentFrame)
				{					
					frame				= spriteSheetInfo.frames[_currentFrame-1];
				}
				else
				{
					frame 				= factory.getFrame(spriteSheetInfo.id);
				}		
				if(null != frame)
				{
					bitmap.bitmapData 	= frame.bitmapData;
					bitmap.x 			= frame.x;
					bitmap.y 			= frame.y;
					_currentFrame++;
				}	
				dispatchEvent(new Event("SpritesheetEnterFrame"));
			}	
		}
		
		public function dispose():void
		{
			if(this.hasEventListener(Event.ADDED_TO_STAGE))
			{
				this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			}
			interactiveActive 		= false;
			bitmapRender.remove(this);
			if (spriteSheetInfo == null)
			{
				return;
			}
			this.spriteSheetInfo 	= null;	
			bitmap.bitmapData 		= null;
		}
		
		public function get displayObject():DisplayObject{
			return this;
		}
		
		private function get factory():SpriteSheetFactory{
			return SpriteSheetFactory.getInstance();
		}
		private function get bitmapRender():SpriteSheetRender{
			return SpriteSheetRender.getInstance();
		}
		
		// ------------------------------------------------
		// ---------------   mouse interactive ---------------
		// ------------------------------------------------
		
		// it will be expensive in performance,so if we don't need to interactive with the animation,then set "interactiveActive" to false
		/**
		 * 是否开启精确鼠标交互（开启后在影片空白区域，不会响应鼠标事件，如果动画不需要交互，需要禁用以减少CPU消耗） 
		 * @return 
		 * 
		 */		
		public function get interactiveActive():Boolean
		{
			return _interactiveActive;
		}
		
		public function set interactiveActive(value:Boolean):void
		{			
			if(value != _interactiveActive){
				_interactiveActive = value;
				if(_interactiveActive){
					enableInteractive();
				}else{
					disableInteractive();
				}
			}
		}
		
		public function get alphaTolerance() : uint {
			return _threshold;
		}
		public function set alphaTolerance(value : uint) : void {
			_threshold = Math.min(255, value);
		}
		
		protected function bitmapHitTest():Boolean {
			_mousePoint.x = bitmap.mouseX;
			_mousePoint.y = bitmap.mouseY;
			return bitmap.bitmapData.hitTest(_basePoint, _threshold, _mousePoint);
		}
		
		public function disableInteractive(): void {
			deactivateMouseTrap();
			removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
			super.mouseEnabled = true;
			_transparentMode = false;
			_bitmapHit = false;
			_interactiveActive = false;
		}
		
		public function enableInteractive(): void {
			disableInteractive();
			if (hitArea!=null)
				return;
			activateMouseTrap();
			_interactiveActive = true;
		}
		
		protected function activateMouseTrap() : void {
			addEventListener(MouseEvent.ROLL_OVER, captureMouseEvent, false, 10000, true); //useCapture=true, priority=high, weakRef=true
			addEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent, false, 10000, true);
			addEventListener(MouseEvent.ROLL_OUT, captureMouseEvent, false, 10000, true);  
			addEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent, false, 10000, true);
			addEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent, false, 10000, true);
		}
		
		protected function deactivateMouseTrap() : void {
			removeEventListener(MouseEvent.ROLL_OVER, captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent);
			removeEventListener(MouseEvent.ROLL_OUT, captureMouseEvent);  
			removeEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent);
		}
		
		
		protected function captureMouseEvent(evt:MouseEvent):void
		{
			if (!_transparentMode) {
				if (evt.type==MouseEvent.MOUSE_OVER || evt.type==MouseEvent.ROLL_OVER) {
					super.mouseEnabled = false;
					_transparentMode = true;
					addEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds, false, 10000, true);
					trackMouseWhileInBounds(); 
				}
			}
			if (!_bitmapHit){
				evt.stopImmediatePropagation();
			}
		}
		
		protected function trackMouseWhileInBounds(event:Event=null):void 
		{
			if (bitmapHitTest() != _bitmapHit) 
			{
				_bitmapHit = !_bitmapHit;
				
				if (_bitmapHit) {
					deactivateMouseTrap();
					super.mouseEnabled = true; 
					_transparentMode = false;
				}else{
					_transparentMode = true;
					super.mouseEnabled = false; 
				}
			}
						
			var localMouse:Point = bitmap.localToGlobal(_mousePoint);
			if (hitTestPoint( localMouse.x, localMouse.y)==false) {
				removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
				super.mouseEnabled = true;
				_transparentMode = false;
				activateMouseTrap();
			}
		}
	}
}