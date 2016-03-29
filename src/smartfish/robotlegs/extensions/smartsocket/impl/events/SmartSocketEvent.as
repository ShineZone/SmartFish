package smartfish.robotlegs.extensions.smartsocket.impl.events
{
	import flash.events.Event;
	
	public class SmartSocketEvent extends Event
	{
		public static const CONNECT:String 				= "connect";
		public static const DISCONNECT:String 			= "disconnect";
		public static const RECONNECTION_TRY:String 	= "reconnectionTry";
		public static const IO_ERROR:String 			= "ioError";
		public static const SECURITY_ERROR:String 		= "securityError";
		public static const DATA_ERROR:String 			= "dataError";
		public static const DATA:String 				= "data";
		
		public var data:Object;
		public function SmartSocketEvent(type:String,data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type,bubbles,cancelable);
		}
		
		override public function clone() : Event
		{
			return new SmartSocketEvent(this.type, this.data,this.bubbles,this.cancelable);
		}
	}
}