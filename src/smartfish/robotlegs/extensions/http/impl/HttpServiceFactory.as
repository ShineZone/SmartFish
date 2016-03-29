package smartfish.robotlegs.extensions.http.impl
{
	import flash.utils.Dictionary;
	
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	
	import smartfish.robotlegs.extensions.http.api.IHttpService;
	import smartfish.robotlegs.extensions.http.api.IHttpServiceFactory;

	public class HttpServiceFactory implements IHttpServiceFactory
	{
		[Inject]
		public var _injector:IInjector;
		public var _logger:ILogger;
		
		private var _handlerMap:Dictionary;
		
		private var idIterator:uint = 0;
		///////////////////////////////////////////////////////////////////////
		// CONSTRUCTOR ////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function HttpServiceFactory(logger:ILogger)
		{
			this._logger 	= logger;
			_handlerMap 	= new Dictionary();
		}
		
		///////////////////////////////////////////////////////////////////////
		// INTERRFACE /////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		/**
		 * 注册service 
		 * @param key
		 * @param type	
		 * @param isBind 是否支持打包，如果不支持，遇到这个service会被单独打包成一个http发出去。
		 * 
		 */		
		public function registerService(key:String, type:Class ,isBind:Boolean = false):void
		{
			if (key in _handlerMap)
			{
				_logger.error("Overridding existing handler for service id:" + key);
			}
			_handlerMap[key] = {"clazz":type,"isBind":isBind};
		}
		
		public function unRegisterService(id:String, type:Class):void
		{
			if (id in _handlerMap)
			{
				delete _handlerMap[id];
			}
			else
			{
				_logger.error("Overridding existing handler for service id:" + id);
			}
		}
		
		/**
		 * 检查是否支持打包 
		 * @param key
		 * @return 
		 * 
		 */		
		public function verifyService(key:String):Boolean
		{
			if (!(key in _handlerMap))
			{
				_logger.error("not existing service id:" + key);
			}
			
			if(_handlerMap[key].isBind == true)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获取空service,并且进行依赖注入
		 * @param key
		 * @return 
		 * 
		 */		
		public function getEmptyService(key:String):IHttpService
		{
			if (!(key in _handlerMap))
			{
				return null;
			}
			
			try
			{
				var clazz:Class 		 = _handlerMap[key].clazz;
				var service:IHttpService = new clazz();
				service.id = idIterator++;
			}
			catch (err:Error)
			{
				_logger.debug("error msg:" + err);
				return null;
			}
			
			_injector.injectInto(service);
			return service;
		}
	}
}