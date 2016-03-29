package smartfish.robotlegs.extensions.popup.impl
{
	import flash.events.Event;
	public class PopUpEvent extends Event
	{
		public static const INITALIZE:String 				= "INITALIZE";
		public static const PROGRESS:String 				= "PROGRESS";
		public static const ON_OPEN:String 					= "ON_OPEN";
		public static const ON_OPEN_COMPLETE:String 		= "ON_OPEN_COMPLETE";
		public static const CLOSE:String 					= "CLOSE";
		public static const ON_CLOSE:String 				= "ON_CLOSE";
		public static const ON_CLOSE_COMPLETE:String 		= "ON_CLOSE_COMPLETE";
		
		public var data:Object;		
		public function PopUpEvent(type:String,data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event 
		{ 
			return new PopUpEvent(type, this.data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PopUpEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}