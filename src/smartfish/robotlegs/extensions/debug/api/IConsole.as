package smartfish.robotlegs.extensions.debug.api
{
	
	/**
	 * 控制台，用于游戏运行时输出一些日志
	 * @author rayyee
	 */	
	public interface IConsole
	{
		/**
		 * 向Console注册一个侦听指令 
		 * @param name			指令名
		 * @param callback		处理函数
		 * @param docs			指令描述
		 */		
		function registerCommand(name:String, callback:Function, docs:String = null):void;
	}
}