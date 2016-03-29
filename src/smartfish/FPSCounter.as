package smartfish
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * 内存，帧频查看工具 
	 * @author chenyonghua
	 * 
	 */	
	public class FPSCounter
	{
		private var stage:Stage;
		private var content:Sprite;
		private var field:TextField;
		
		private var current:int;
		private var timer:Timer;
		private var prevTime:int;
		
		private var dragX:int;
		private var dragY:int;
		private var isDrag:Boolean = false;
		
		//激活
		public static function activate(stage:Stage):void{
			new FPSCounter(stage);
		}
		
		public function FPSCounter(stage:Stage)
		{
			this.stage = stage;
			init();
		}
		
		//初始化
		private function init():void{
			createUI();
			stage.addEventListener(Event.ADDED,addedHandle);
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandle);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandle);
			content.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandle);
			
			prevTime = getTimer();
			timer = new Timer(1000);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,timerHandle);
		}
		
		//侦听添加事件
		private function addedHandle(e:Event):void{
			stage.addChild(content);
			content.x = stage.stageWidth - content.width;
		}
		
		//键盘事件
		private function keyDownHandle(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.F2) content.visible = !content.visible;
		}
		
		//鼠标按住拖拽
		private function mouseDownHandle(e:MouseEvent):void{
			dragX = e.localX;
			dragY = e.localY;
			isDrag = true;
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
		}
		
		//鼠标停止拖拽
		private function mouseUpHandle(e:MouseEvent):void{
			isDrag = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
		}
		
		//时间器事件
		private function timerHandle(e:TimerEvent):void{
			updateText(current * 1000 / (getTimer() - prevTime));
			current = 0;
			prevTime = getTimer();
		}
		
		//更新一次特效t
		private function updateText(fps:int = -1):void{
			if(fps == -1) fps = stage.frameRate;
			field.text = fps + "/" + stage.frameRate + "\n" + (System.totalMemory / 1024 / 1024).toFixed(2) + "MB";
			updateBackground();
		}
		
		//频繁触发
		private function enterFrameHandle(e:Event):void{
			current ++;
			if(isDrag){
				if(stage.mouseX < 0 || stage.mouseX > stage.stageWidth ||
					stage.mouseY < 0 || stage.mouseY > stage.stageHeight) return;
				content.x = stage.mouseX - dragX;
				content.y = stage.mouseY - dragY;
			}
		}
		
		//生成界面
		private function createUI():void{
			var format:TextFormat = new TextFormat("_sans",10,0xffffff);
			content = new Sprite;
			field = new TextField;
			
			var restField:TextField = new TextField;
			restField.autoSize = "left";
			restField.selectable = false;
			restField.mouseEnabled = false;
			restField.defaultTextFormat = format;
			restField.text = "FPS:\nMemory:";
			
			field.x = restField.width;
			field.autoSize = "left";
			field.selectable = false;
			field.mouseEnabled = false;
			field.defaultTextFormat = format;
			
			content.addChild(restField);
			content.addChild(field);
			stage.addChild(content);
			
			updateText();
		}
		
		//更新背景
		private function updateBackground():void{
			content.graphics.clear();
			var rect:Rectangle = content.getRect(content);
			rect.inflate(1,1);
			content.graphics.beginFill(0,.3);
			content.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
		}
	}
}
