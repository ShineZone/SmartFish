package smartfish.robotlegs.extensions.smartsocket
{
	import smartfish.robotlegs.extensions.smartsocket.api.IProtocol;
	import smartfish.robotlegs.extensions.smartsocket.api.ISmartSocket;
	import smartfish.robotlegs.extensions.smartsocket.api.ISmartSocketFactory;
	import smartfish.robotlegs.extensions.smartsocket.api.ISocketManager;
	import smartfish.robotlegs.extensions.smartsocket.impl.SmartSocket;
	import smartfish.robotlegs.extensions.smartsocket.impl.SmartSocketFactory;
	import smartfish.robotlegs.extensions.smartsocket.impl.SocketManager;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;
	
	/**
	 * robotlegs's extension 
	 * @author chenyonghua
	 * 
	 */	
	public class SmartSocketExtension implements IExtension
	{
		private var _injector:IInjector;
		public function SmartSocketExtension()
		{
		}
		
		public function extend(context:IContext):void
		{
			_injector = context.injector;
			context.injector.map(ISmartSocket).toSingleton(SmartSocket);
			context.injector.map(ISocketManager).toSingleton(SocketManager);
			context.injector.map(ISmartSocketFactory).toSingleton(SmartSocketFactory);
			context.whenInitializing(whenInitializing);
		}
		
		private function whenInitializing():void
		{
			
		}
	}
}