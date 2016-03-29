/*
 * Copyright (c) 2013 rayyee. All rights reserved.
 * @author rayyee
 * Created 13-7-18 下午2:46
 */
package smartfish.managers.toolTip
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import smartfish.utils.Direction;
	
	/**
	 * 
	 * @author vincent
	 * 
	 */	
	public class ToolTip extends Sprite
	{
		private static const AUTO_LIST:Array = [Direction.TOP,Direction.RIGHT,Direction.LEFT,Direction.BOTTOM];
		private var _target:DisplayObject;
		private var container:Sprite;		
		
		private var bgColor:uint            = 0xffffff;
		private var bgAlpha:Number          = 1;
		private var borderColor:uint        = 0xffffff;
		private var borderAlpha:Number      = 1;
		private var borderThickNess:Number  = 1;
		private var _ellipsSize:Number  = 1;
		private var _arrowSize:Number  = 1;
		private var mTf:TextField;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		private var skin:MovieClip;
		private var arrow:MovieClip;
		private var ellipse:MovieClip;
		private var marginX:Number;
		private var marginY:Number;
		public function ToolTip() 
		{
			container = new Sprite();
			container.x = 5;
			container.y = 4;
			this.addChild(container);
			
			this.mouseEnabled  = false;
			this.mouseChildren = false;
		}
		
		/**
		 * 初始化
		 * @param	displayObject
		 * @param	content
		 * @param	direction
		 * @param	contentOffetX
		 * @param	contentOffetY
		 */
		public function init(displayObject:DisplayObject, content:* , direction:String = Direction.TOP,marginX:Number = 0,marginY:Number = 0, contentOffetX:Number = 0, contentOffetY:Number = 0 ):void {
			mTf.text 	= "";
			mTf.x 		= 0;
			mTf.y 		= 0;
			target 		= displayObject;
			this.marginX = marginX;
			this.marginY = marginY;
			removeAllChildren(this.container);
			if (content is String) {	
				mTf.text = content;
				this.container.addChild(mTf);	
				mTf.x +=contentOffetX;
				mTf.y +=contentOffetY;
				_width = mTf.textWidth + 15 + contentOffetX;
				_height = mTf.textHeight + 10 + contentOffetY;
			}else if (content is DisplayObject) {
				var rect:Rectangle = (content as DisplayObject).getBounds((content as DisplayObject));
				content.x = contentOffetX - rect.x;
				content.y = contentOffetX - rect.y;
				this.container.addChild(content);
				_width = (content  as DisplayObject).width + 10 + contentOffetX;
				_height = (content  as DisplayObject).height + 8 + contentOffetY;
			}else {
				return;
			}			
			if(direction == Direction.AUTO){
				if(this.stage){
					for (var j:int = 0; j < AUTO_LIST.length; j++) 
					{
						setDirection(AUTO_LIST[j]);
						if(checkDirection()){
							break;
						}
					}
				}
			}else{
				setDirection(direction);				
			}
		}
		
		private function checkDirection():Boolean
		{			
			var rect:Rectangle = this.getRect(this.stage);
			if(rect.x < 0 || (rect.x + rect.width) > this.stage.stageWidth){
				return false;
			}else if(rect.y < 0 || (rect.y + rect.height) > this.stage.stageHeight){
				return false;
			}else{
				return true;
			}
		}
		
		public function setSkin(mov:MovieClip):void{
			skin     = mov;
			ellipse  = mov.ellipse;
			arrow    = mov.arrow;
			mTf		 = mov.tf;
			mTf.selectable	= false;
			mTf.multiline 	= true;
			mTf.wordWrap 	= false;
			this.addChildAt(skin,0);
		}
		
		private function resetSkin(direction:String):void
		{
			ellipse.width  = _width;
			ellipse.height = _height;
			ellipse.x = 0;
			ellipse.y = 0;
			if(arrow){
				if (direction == Direction.TOP){
					arrow.gotoAndStop(3);
					arrow.x   = (ellipse.width - arrow.width)/2;
					arrow.y   = ellipse.height;				
				}else if (direction == Direction.RIGHT){
					arrow.gotoAndStop(4);	
					arrow.x   = -arrow.width;
					arrow.y   = (ellipse.height - arrow.height)/2;
				}else if (direction == Direction.BOTTOM){
					arrow.gotoAndStop(1);				
					arrow.x   = (ellipse.width - arrow.width)/2;
					arrow.y   = -arrow.height;
				}else if (direction == Direction.LEFT){
					arrow.gotoAndStop(2);
					arrow.x   = ellipse.width;
					arrow.y   = (ellipse.height - arrow.height)/2;
				}
			}
		}
		
		private function setDirection(direction:String):void {	
			graphics.clear();
			if(skin){
				resetSkin(direction);
			}else{				
				var arrowSize:Number;
				if(direction == Direction.TOP || direction == Direction.BOTTOM){
					arrowSize = _width / 2;
				}else{
					arrowSize = _height / 2;
				}
				redrawBg(0, 0, _width, _height, _ellipsSize, direction, arrowSize, _arrowSize, bgColor, bgAlpha, true);
			}			
			if (target) {
				var rect:Rectangle     = target.getRect(this.parent);
				var selfRect:Rectangle = this.getBounds(this);
				var isAdaptX:Boolean = false;
				if(direction == Direction.TOP){					
					this.x = rect.x + int(rect.width / 2) - int(selfRect.width / 2) - selfRect.x;
					this.y = rect.y - selfRect.height - 10 - selfRect.y;
					isAdaptX = true;
				}else if(direction == Direction.BOTTOM){
					this.x = rect.x + int(rect.width / 2) - int(selfRect.width / 2) - selfRect.x;
					this.y = rect.y + rect.height + 10 - selfRect.y;
					isAdaptX = true;
				}else if(direction == Direction.LEFT){
					this.x = rect.x - selfRect.width -10 - selfRect.x;
					this.y = rect.y + rect.height/2 - int(selfRect.height / 2) - selfRect.y;
				}else if(direction == Direction.RIGHT){
					this.x = rect.x + rect.width +10 - selfRect.x;
					this.y = rect.y + rect.height/2 - int(selfRect.height / 2) - selfRect.y;
				}
				
				this.x += marginX;
				this.y += marginY;
				
				if(isAdaptX)
				{
					if(this.container.stage)
					{
						if(this.x < 0)
						{
							this.x = 0;
						}else if(this.x + selfRect.width > this.container.stage.stageWidth)
						{
							this.x = this.container.stage.stageWidth - selfRect.width;
						}						
					}
				}
			}			
		}
		
		public function setFormat(format:TextFormat):void {
			mTf.defaultTextFormat = format;	
		}
		
		public function setStyle(bgColor:uint = 0xffffff,bgAlpha:Number = 1,borderColor:uint=0xffffff,borderAlpha:Number=1,borderThickNess:Number=1,ellipsSize:Number = 5,arrowSize:Number = 7):void {
			mTf					  	= new TextField();
			var tfm:TextFormat 		= new TextFormat;
			tfm.color 				= 0x666666;
			tfm.size  				= 12;
			tfm.font  				= "微软雅黑";
			mTf.embedFonts 			= false;
			mTf.defaultTextFormat = tfm;
			mTf.autoSize          = TextFieldAutoSize.LEFT;
			
			this.bgColor          = bgColor;
			this.bgAlpha          = bgAlpha;
			this.borderColor      = borderColor;
			this.borderAlpha      = borderAlpha;
			this.borderThickNess  = borderThickNess;
			this._ellipsSize      = ellipsSize;
			this._arrowSize       = arrowSize;		
		}
		
		
		private function redrawBg(sX:Number,sY:Number,eX:Number,eY:Number,ellipsSize:Number,direction:String,arrowX:Number,arrowSize:Number,color:uint,alpha:Number,border:Boolean=false):void
		{
			graphics.beginFill(color,alpha);
			if(border)
			{
				graphics.lineStyle(borderThickNess,borderColor,borderAlpha,true);
			}
			
			if (direction == Direction.TOP){
				graphics.moveTo(sX,ellipsSize);
				graphics.curveTo(sX,sY,ellipsSize,sY);
				graphics.lineTo(eX - ellipsSize,sY);
				graphics.curveTo(eX,sY,eX,ellipsSize);
				graphics.lineTo(eX,eY - ellipsSize);
				graphics.curveTo(eX,eY,eX - ellipsSize,eY);
				graphics.lineTo(arrowX + 7,eY);
				graphics.lineTo(arrowX,eY + arrowSize);
				graphics.lineTo(arrowX - 7,eY);
				graphics.lineTo(ellipsSize,eY);
				graphics.curveTo(sX,eY,sX,eY - ellipsSize);
				graphics.lineTo(sX,ellipsSize);
			}else if (direction == Direction.BOTTOM){
				graphics.moveTo(sX,ellipsSize);
				graphics.curveTo(sX,sY,ellipsSize,sY);
				graphics.lineTo(arrowX - 7,sY);
				graphics.lineTo(arrowX,sY - arrowSize);
				graphics.lineTo(arrowX + 7,sY);
				graphics.lineTo(eX - ellipsSize,sY);
				graphics.curveTo(eX,sY,eX,ellipsSize);
				graphics.lineTo(eX,eY - ellipsSize);
				graphics.curveTo(eX,eY,eX - ellipsSize,eY);
				graphics.lineTo(ellipsSize,eY);
				graphics.curveTo(sX,eY,sX,eY - ellipsSize);
				graphics.lineTo(sX,ellipsSize);
			}else if (direction == Direction.LEFT){
				graphics.moveTo(sX,ellipsSize);
				graphics.curveTo(sX,sY,ellipsSize,sY);				
				graphics.lineTo(eX - ellipsSize,sY);
				graphics.curveTo(eX, sY, eX, ellipsSize);				
				graphics.lineTo(eX, arrowX -5);
				graphics.lineTo(eX + arrowSize,arrowX);
				graphics.lineTo(eX ,arrowX + 5);
				graphics.lineTo(eX ,eY - ellipsSize);
				graphics.curveTo(eX,eY,eX - ellipsSize,eY);
				graphics.lineTo(ellipsSize,eY);
				graphics.curveTo(sX,eY,sX,eY - ellipsSize);
				graphics.lineTo(sX,ellipsSize);
			}else if (direction == Direction.RIGHT){
				graphics.moveTo(sX,ellipsSize);
				graphics.curveTo(sX,sY,ellipsSize,sY);				
				graphics.lineTo(eX - ellipsSize,sY);
				graphics.curveTo(eX, sY, eX, ellipsSize);				
				graphics.lineTo(eX ,eY - ellipsSize);
				graphics.curveTo(eX, eY, eX - ellipsSize, eY);
				graphics.lineTo(ellipsSize, eY);
				graphics.curveTo(sX, eY, sX, eY - ellipsSize);				
				graphics.lineTo(sX, arrowX +5);
				graphics.lineTo(sX - arrowSize,arrowX);
				graphics.lineTo(sX , arrowX - 5);
				graphics.lineTo(sX,ellipsSize);
			}
			this.graphics.endFill();
		}
		
		public function set target(value:DisplayObject):void {
			_target = value;
		}
		
		public function get target():DisplayObject {
			return _target;
		}
		
		/**
		 * 删除所有子元件
		 * @param	displayObject
		 */
		private function removeAllChildren(container:DisplayObjectContainer):void {		
			while(container.numChildren > 0){
				container.removeChildAt(0);
			}
		}
	}

}