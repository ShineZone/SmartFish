package smartfish.robotlegs.extensions.smartsocket.api
{
	public interface ISocketManager
	{
		function connect(host:String = "127.0.0.1", port:int = 9933) : void;
		function registerHandler(id:String, type:Class):void;
		function queueLocal(change:ISocketService):void;
		function queueRemote(change:ISocketService):void;
		function clearService():void;
	}
}