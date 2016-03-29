package smartfish.robotlegs.extensions.smartsocket.api
{
	import flash.utils.ByteArray;

	public interface ISmartSocketFactory
	{
		function registerHandler(id:String, type:Class):void;
		
		function buildServiceFromData(id:uint,byteArray:ByteArray):ISocketService;
		
		function getEmptyService(id:String):ISocketService
	}
}