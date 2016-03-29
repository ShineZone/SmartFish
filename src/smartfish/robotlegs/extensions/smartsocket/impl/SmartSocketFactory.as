package smartfish.robotlegs.extensions.smartsocket.impl
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import smartfish.robotlegs.extensions.smartsocket.api.ISmartSocketFactory;
	import smartfish.robotlegs.extensions.smartsocket.api.ISocketService;

	/**
	 * the factory for services.
	 * @author chenyonghua
	 * 
	 */	
	public class SmartSocketFactory implements ISmartSocketFactory
	{
		[Inject]
		public var _injector:IInjector;
		
		private var _handlerMap:Dictionary;
		public function SmartSocketFactory()
		{
			_handlerMap = new Dictionary();
		}
		///////////////////////////////////////////////////////////////////////
		// INTERRFACE /////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function registerHandler(id:String, type:Class):void
		{
			if (id in _handlerMap)
			{
				throw new Error("[registerHandler] Overridding existing handler for service id " + id);
			}
			_handlerMap[id] = type;
		}
		
		/**
		 * get the service by service id.
		 * @param id
		 * @return 
		 * 
		 */		
		public function getEmptyService(id:String):ISocketService
		{
			if (!(id in _handlerMap))
			{
				throw new Error("[getEmptyChange] handler for service id " + id + "does not exist.");
				return null;
			}
			
			try
			{
				var serivce:ISocketService = new _handlerMap[id]();
			}
			catch (err:Error)
			{
				return null;
			}
			
			_injector.injectInto(serivce);
			return serivce;
		}
		
		/**
		 * response for the remote when data received. 
		 * @param id
		 * @param byteArray
		 * @return 
		 * 
		 */		
		public function buildServiceFromData(id:uint,byteArray:ByteArray):ISocketService
		{
			var serivce:ISocketService;
			var msgType:uint = id;
			if (!(msgType in _handlerMap))
			{
				return null;
			}			
			try
			{
				serivce = new _handlerMap[msgType]();
			}
			catch (err:Error)
			{
				return null;
			}			
			_injector.injectInto(serivce);
			serivce.deserialize(byteArray);
			return serivce;
		}
	}
}