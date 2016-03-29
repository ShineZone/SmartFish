package smartfish.robotlegs.extensions.smartsocket.impl
{
	import flash.utils.ByteArray;
	
	import smartfish.robotlegs.base.Service;
	import smartfish.robotlegs.extensions.smartsocket.api.ISocketService;

	/**
	 * the base of service 
	 * @author chenyonghua
	 * 
	 */	
	public class SocketService extends Service implements ISocketService
	{
		private var _id:uint;
		private var _isAppliedLocal:Boolean;
		private var _isAppliedRemote:Boolean;
		public function SocketService(id:uint)
		{
			_id = id;
		}
		
		public function get id():uint
		{
			return _id;
		}
				
		public function get hasAppliedLocal():Boolean
		{
			return _isAppliedLocal;
		}
		
		public function set hasAppliedLocal(applied:Boolean):void
		{
			_isAppliedLocal = applied;
		}
		
		public function get hasAppliedRemote():Boolean
		{
			return _isAppliedRemote;
		}
		
		public function set hasAppliedRemote(applied:Boolean):void
		{
			_isAppliedRemote = applied;
		}
		
		public function apply():void
		{
			
		}
		
		public function onQueued(queueName:String):void
		{
		}
		
		/**
		 * 可以关联到google protocol buffer && protoc-gen-as3 
		 * Message.writeto(output:IDataInput);
		 * @return 
		 * 
		 */		
		public function serialize():ByteArray
		{
			return null;
		}
		
		/**
		 * 可以关联到google protocol buffer && protoc-gen-as3 
		 * Message.mergeFrom(input:IDataInput);
		 * @return 
		 */
		public function deserialize(data:ByteArray):void
		{
			
		}
	}
}