package smartfish.robotlegs.extensions.debug.impl
{
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.LogLevel;

    public class DTraceAppender implements ILogTarget
    {
        public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void
        {
			trace(timestamp // (START + timestamp)
				+ ' ' + LogLevel.NAME[level]
				+ ' ' + source);
        }
    }
}