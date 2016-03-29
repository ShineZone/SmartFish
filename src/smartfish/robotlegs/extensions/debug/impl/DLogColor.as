package smartfish.robotlegs.extensions.debug.impl
{
	import robotlegs.bender.framework.api.LogLevel;

    public class DLogColor
    {
        public static const DEBUG:String 	= "#DDDDDD";
        public static const INFO:String 	= "#BBBBBB";
        public static const WARN:String 	= "#FF6600";
        public static const ERROR:String 	= "#FF0000";
        public static const MESSAGE:String 	= "#FFFFFF";
        public static const CMD:String 		= "#00DD00";
        public static const FATAL:String	= "#FF3333";
		
        public static function getColor(level:String):String
        {
            switch(level)
            {
				case LogLevel.DEBUG:
                case DLogLevel.DEBUG:
                    return DEBUG;
					
				case LogLevel.INFO:
                case DLogLevel.INFO:
                    return INFO;
					
				case LogLevel.WARN:
                case DLogLevel.WARNING:
                    return WARN;
					
				case LogLevel.ERROR:
                case DLogLevel.ERROR:
                    return ERROR;
					
                case DLogLevel.MESSAGE:
                    return MESSAGE;
				
				case LogLevel.FATAL:
					return FATAL;
					
                case "CMD":
                    return CMD;
					
                default:
                    return MESSAGE;
            }
        }
    }
}