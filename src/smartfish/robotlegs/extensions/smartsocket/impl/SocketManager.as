package smartfish.robotlegs.extensions.smartsocket.impl
{
	import smartfish.robotlegs.extensions.smartsocket.api.ISmartSocket;
	import smartfish.robotlegs.extensions.smartsocket.api.ISmartSocketFactory;
	import smartfish.robotlegs.extensions.smartsocket.api.ISocketManager;
	import smartfish.robotlegs.extensions.smartsocket.api.ISocketService;
	import smartfish.robotlegs.extensions.smartsocket.impl.events.SmartSocketEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	/**
	 * socket 通讯层 
	 * @author chenyonghua
	 * 
	 */	
	public class SocketManager implements ISocketManager
	{
		///////////////////////////////////////////////////////////////////////
		// STATICS ////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public static const LOCAL_QUEUE:String = "local";
		public static const REMOTE_QUEUE:String = "remote";
		
		///////////////////////////////////////////////////////////////////////
		// VARIABLES //////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		[Inject]
		public var smartSocket:ISmartSocket;
		
		[Inject]
		public var factory:ISmartSocketFactory;
		
		private var pendingLocals:Vector.<ISocketService>;
		private var pendingRemotes:Vector.<ISocketService>;
		private var timer:Timer;
		
		///////////////////////////////////////////////////////////////////////
		// CONSTRUCTOR ////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function SocketManager()
		{			
			pendingLocals = new Vector.<ISocketService>();
			pendingRemotes = new Vector.<ISocketService>();
		}
		
		[PostConstruct]
		public function init():void
		{
			timer = new Timer(15);
			timer.addEventListener(TimerEvent.TIMER,processChanges);
			smartSocket.addEventListener(SmartSocketEvent.DATA,onDataReceived);
			smartSocket.addEventListener(SmartSocketEvent.CONNECT,onConnect);
			smartSocket.addEventListener(SmartSocketEvent.DISCONNECT,onDisconnect);
		}
		
		
		///////////////////////////////////////////////////////////////////////
		// INTERFACE //////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		public function connect(host:String = "127.0.0.1", port:int = 9933) : void
		{
			smartSocket.connect(host,port);	
		}
		
		public function registerHandler(id:String, type:Class):void
		{
			factory.registerHandler(id,type);
		}
		
		public function queueLocal(service:ISocketService):void
		{
			pendingLocals.push(service);
			service.onQueued(LOCAL_QUEUE);
			checkTimer();
		}
		
		public function queueRemote(service:ISocketService):void
		{
			pendingRemotes.push(service);
			service.onQueued(REMOTE_QUEUE);
			checkTimer();
		}
		
		private function processChanges(evt:TimerEvent):void
		{
			processPendingChanges();
		}
		
		///////////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		private function checkTimer():void
		{
			if(pendingRemotes.length > 0 || pendingLocals.length > 0)
			{
				if(!timer.running)
					timer.start();
			}
			else
			{
				if(timer.running)
					timer.stop();
			}
		}
		
		private function processPendingChanges():void
		{
			var service:ISocketService;
			for each (service in pendingLocals)
			{
				if(!smartSocket.connected)
					return;
				service.apply();
				if (service.hasAppliedRemote)
				{
					continue;
				}
				smartSocket.send(service.id, service.serialize());
				service.hasAppliedRemote = true;
			}
			pendingLocals  = pendingLocals.filter(filterOutAppliedRemote);
			for each (service in pendingRemotes)
			{
				service.hasAppliedLocal  = true;
				service.apply();
			}
			pendingRemotes = pendingRemotes.filter(filterOutAppliedLocal);
			checkTimer();
		}
		
		private static function filterOutAppliedLocal(item:ISocketService, index:int, list:Vector.<ISocketService>):Boolean
		{
			return !item.hasAppliedLocal;
		}
		private static function filterOutAppliedRemote(item:ISocketService, index:int, list:Vector.<ISocketService>):Boolean
		{
			return !item.hasAppliedRemote;
		}
		
		///////////////////////////////////////////////////////////////////////
		// EVENT HANDLERS /////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		private function onDataReceived(evt:SmartSocketEvent):void
		{
			var buff:ByteArray 	= evt.data.data;
			var id:int	 		= buff.readUnsignedInt();
			var service:ISocketService = factory.buildServiceFromData(id, buff);
			if (service == null)
			{
				return;
			}			
			queueRemote(service);
		}
		
		private function onConnect(evt:SmartSocketEvent):void
		{
			if(!timer.running)
			{
				timer.start();
			}
		}

		private function onDisconnect(evt:SmartSocketEvent):void
		{
			if(timer.running)
			{
				timer.stop();
			}
		}
		
		public function clearService():void
		{
			pendingLocals.length = 0;
			pendingRemotes.length = 0;
			checkTimer();
		}
	}
}