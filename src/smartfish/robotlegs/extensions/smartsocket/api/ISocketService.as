package smartfish.robotlegs.extensions.smartsocket.api
{
	import flash.utils.ByteArray;
	
	import smartfish.robotlegs.base.Promise;

	public interface ISocketService extends Promise
	{
		/**
		 * Change type id.
		 */
		function get id():uint
		
		/**
		 * Whether or not the ISocketService has been applied
		 * locally yet.
		 */
		function get hasAppliedLocal():Boolean;
		function set hasAppliedLocal(applied:Boolean):void
		
		/**
		 * Whether or not the ISocketService has been replicated to
		 * the server yet.
		 */
		function get hasAppliedRemote():Boolean;
		function set hasAppliedRemote(applied:Boolean):void;
		
		/**
		 * Custom method for an ISocketService to perform whatever service
		 * it is intended to.
		 */
		function apply():void;
		
		/**
		 * Custom method for when an ISocketService is added to a queue. Primarily
		 * used for debugging.
		 */
		function onQueued(queueName:String):void;
		
		/**
		 * Stores data of this ISocketService in an ISFFObject to be sent
		 * to the server and other clients.
		 * 
		 * @returns Array containing relevant data about this ISocketService
		 */
		function serialize():ByteArray;
		
		/**
		 * Retrieves information from an ISFSObject to fill out the
		 * relevant data in this ISocketService. Used when receiving
		 * ISocketServices from the server.
		 * 
		 * @param data Array
		 */
		function deserialize(data:ByteArray):void;
	}
}