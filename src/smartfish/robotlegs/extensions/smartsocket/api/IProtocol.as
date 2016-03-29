package smartfish.robotlegs.extensions.smartsocket.api
{
	import flash.utils.ByteArray;

	public interface IProtocol
	{
		function readArray(buff:ByteArray, response:Array):Array;
		function writeArray(data:Array, format:Array) : ByteArray
	}
}