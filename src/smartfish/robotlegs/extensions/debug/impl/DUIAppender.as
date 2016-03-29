package smartfish.robotlegs.extensions.debug.impl
{
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.LogLevel;

	public class DUIAppender implements ILogTarget
	{
		protected var _logViewer:DLogViewer;
	   	private var _main:DisplayObjectContainer;
		private var _console:DConsole;
		public function DUIAppender(stage:DisplayObjectContainer, console:DConsole)
		{
			_console = console;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			_logViewer 	= new DLogViewer(console);
			_main		= stage;
			_logViewer.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
  
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode != _console.hotKeyCode)
				return;
			 
			if (_logViewer)
			{
				if (_logViewer.parent)
				{
					_logViewer.y	=	0;
					_logViewer.parent.removeChild(_logViewer);
					_logViewer.deactivate();
				}
				else
				{
					_logViewer.y	=	0;
					_main.addChild(_logViewer);
					var char:String = String.fromCharCode(event.charCode);
					_logViewer.restrict = "^"+char.toUpperCase()+char.toLowerCase();	// disallow hotKey character
					_logViewer.activate();
				}
			}
		}
		
		public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void
		{
			if (_logViewer)
			{
				_logViewer.addLogMessage(LogLevel.NAME[level], String(source), message);
			}
		}
  
		public function addLogMessage(level:String, loggerName:String, message:String):void
		{
			if (_logViewer)
				_logViewer.addLogMessage(level, loggerName, message);
		}
	}
}