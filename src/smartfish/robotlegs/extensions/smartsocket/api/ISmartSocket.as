package smartfish.robotlegs.extensions.smartsocket.api
{
	import flash.events.IEventDispatcher;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public interface ISmartSocket extends IEventDispatcher
	{
		function send(id:uint, data:ByteArray) : void;
		function get socket():Socket;
		function set socket(value:Socket):void;
		function disconnect() : void;
		function connect(host:String = "127.0.0.1", port:int = 9933) : void;
		function get connected():Boolean;
		function set connected(value:Boolean):void;
	}
}