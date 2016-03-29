package smartfish.robotlegs.extensions.debug.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;
	
	import robotlegs.bender.framework.api.ILogger;
	
	import smartfish.robotlegs.extensions.debug.api.IConsole;

	public class DConsole implements IConsole
	{		
		protected var commandList:Array = [];
		protected var commands:Object = {};
		protected var commandListOrdered:Boolean = false;
		protected var _hotKeyCode:uint = 192;//192是“～”号的keycode.
		
		public var verbosity:int = 0;
		
		private var _logger:ILogger;
		
		public function DConsole(log:ILogger)
		{
			_logger = log;
		}
		
		public function registerCommand(name:String, callback:Function, docs:String = null):void
		{
			if (callback == null)
				_logger.error("registerCommand:" + "Command '" + name + "' has no callback!");
			
			if (!name || name.length == 0)
				_logger.error("registerCommand:" + "Command has no name!");
			
			if (name.indexOf(" ") != -1)
				_logger.error("registerCommand:" + "Command '" + name + "' has a space in it, it will not work.");
			
			var c:ConsoleCommand = new ConsoleCommand();
			c.name = name;
			c.callback = callback;
			c.docs = docs;
			
			if (commands[name.toLowerCase()])
				_logger.warn("registerCommand" + "Replacing existing command '" + name + "'.");
			
			commands[name.toLowerCase()] = c;
			
			commandList.push(c);
			commandListOrdered = false;
		}
		
		public function getCommandList():Array
		{
			ensureCommandsOrdered();			
			return commandList;
		}
		
		protected function ensureCommandsOrdered():void
		{
			if (commandListOrdered == true)
				return;
			
			if (commands.help == null)
				init();
			
			commandListOrdered = true;
			
			commandList.sort(function(a:ConsoleCommand, b:ConsoleCommand):int
			{
				if (a.name > b.name)
					return 1;
				else
					return -1;
			});
		}
		
		protected function _listDisplayObjects(current:DisplayObject, indent:int):int
		{
			if (!current)
				return 0;
			
			_logger.info(
				generateIndent(indent) +
				current.name +
				" (" + current.x + "," + current.y + ") visible=" +
				current.visible);
			
			var parent:DisplayObjectContainer = current as DisplayObjectContainer;
			if (!parent)
				return 1;
			
			var sum:int = 1;
			for (var i:int = 0; i < parent.numChildren; i++)
				sum += _listDisplayObjects(parent.getChildAt(i), indent + 1);
			return sum;
		}
		protected function generateIndent(indent:int):String
		{
			var str:String = "";
			for (var i:int = 0; i < indent; i++)
			{
				// Add 2 spaces for indent
				str += "  ";
			}
			
			return str;
		}
		
		public function init():void
		{
			/*** THESE ARE THE DEFAULT CONSOLE COMMANDS ***/
			registerCommand("help", function(prefix:String = null):void
			{
				// Get commands in alphabetical order.
				ensureCommandsOrdered();
				
				_logger.info("快捷键: ");
				_logger.info("[SHIFT]-TAB			- 循环执行command.");
				_logger.info("PageUp/PageDown			- 日志翻上页/下页");
				_logger.info("");
				
				// Display results.
				_logger.info("Commands:");
				for (var i:int = 0; i < commandList.length; i++)
				{
					var cc:ConsoleCommand = commandList[i] as ConsoleCommand;
					
					// Do prefix filtering.
					if (prefix && prefix.length > 0 && cc.name.substr(0, prefix.length) != prefix)
						continue;
					
					_logger.info("   " + cc.name + "			- " + (cc.docs ? cc.docs : ""));
				}
			}, "查看命令列表");
			
			registerCommand("verbose", function(level:int):void
			{
				verbosity = level;
				_logger.info("Verbosity set to " + level);
			}, "Set verbosity level of console output.");
			
			if(ExternalInterface.available)
			{
				registerCommand("exit", _exitMethod,
					"Attempts to exit the application using ExternalInterface if avaliable");
			}
		}
		protected function _exitMethod():void
		{
			if(ExternalInterface.available)
			{
				_logger.info("exit:" + ExternalInterface.call("window.close"));	
			}
			else
			{
				_logger.warn("exit:" + "ExternalInterface is not avaliable");
			}
		}
		public function processLine(line:String):void
		{
			// Make sure everything is in order.
			ensureCommandsOrdered();
			
			// Match Tokens, this allows for text to be split by spaces excluding spaces between quotes.
			// TODO Allow escaping of quotes
			var pattern:RegExp = /[^\s"']+|"[^"]*"|'[^']*'/g;
			var args:Array = [];
			var test:Object = {};
			while (test)
			{
				test = pattern.exec(line);
				if (test)
				{
					var str:String = test[0];
					str = PBUtil.trim(str, "'");
					str = PBUtil.trim(str, "\"");
					args.push(str);	// If no more matches can be found, test will be null
				}
			}
			
			// Look up the command.
			if (args.length == 0)
				return;
			var potentialCommand:ConsoleCommand = commands[args[0].toString().toLowerCase()];
			
			if (!potentialCommand)
			{
				_logger.warn("processLine:" + "No such command '" + args[0].toString() + "'!");
				return;
			}
			
			// Now call the command.
			try
			{
				potentialCommand.callback.apply(null, args.slice(1));
			}
			catch(e:Error)
			{
				var errorStr:String = "Error: " + e.toString();
				errorStr += " - " + e.getStackTrace();
				_logger.error(errorStr, args);
			}
		}
		
		/**
		 * The keycode to toggle the Console interface.
		 */
		public function set hotKeyCode(value:uint):void
		{
			_logger.info("Setting hotKeyCode to: " + value);
			_hotKeyCode = value;
		}
		
		public function get hotKeyCode():uint
		{
			return _hotKeyCode;
		}
	}
}

final class ConsoleCommand
{
	public var name:String;
	public var callback:Function;
	public var docs:String;
}