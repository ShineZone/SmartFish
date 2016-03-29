package smartfish.robotlegs.extensions.smartsocket.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;
	
	import smartfish.robotlegs.extensions.smartsocket.api.ISmartSocket;
	import smartfish.robotlegs.extensions.smartsocket.impl.events.SmartSocketEvent;
	
	public class SmartSocket extends EventDispatcher implements ISmartSocket
	{		
		private static const PREHEAD_LENGTH:int = 4;
		private var logger:ILogger;
		private var _socket:Socket;
		private var _connected:Boolean;
		private var _lastIpAddress:String;
		private var _lastTcpPort:int;
		private var _len:int = -1;
		public function SmartSocket(context:IContext)
		{
			this.logger = context.getLogger(this);
			init();
		}
		
		public function get socket():Socket
		{
			return _socket;
		}
		
		public function set socket(value:Socket):void
		{
			_socket = value;
		}
		
		public function get connected():Boolean
		{
			return _connected;
		}
		
		public function set connected(value:Boolean):void
		{
			_connected = value;
		}
		
		public function connect(host:String = "127.0.0.1", port:int = 9933) : void
		{
			this._lastIpAddress = host;
			this._lastTcpPort = port;
			this._socket.connect(host, port);
		}
		
		public function disconnect() : void
		{
			this._socket.close();
			_connected = false;
			dispatchEvent(new SmartSocketEvent(SmartSocketEvent.DISCONNECT));
		}
		
		public function init() : void
		{
			this._socket = new Socket();
			this._socket.addEventListener(Event.CONNECT, this.onSocketConnect);
			this._socket.addEventListener(Event.CLOSE, this.onSocketClose);
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
			this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.onSocketIOError);
			this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSocketSecurityError);
		}
		
		protected function onSocketSecurityError(evt:SecurityErrorEvent):void
		{
			logger.debug("socket(ip:"+_lastIpAddress+",host:"+_lastTcpPort+" ) IO error");
			var event:SmartSocketEvent = new SmartSocketEvent(SmartSocketEvent.IO_ERROR);
			dispatchEvent(event);
		}
		
		protected function onSocketIOError(evt:IOErrorEvent):void
		{
			logger.debug("socket(ip:"+_lastIpAddress+",host:"+_lastTcpPort+" ) IO error");
			var event:SmartSocketEvent = new SmartSocketEvent(SmartSocketEvent.SECURITY_ERROR);
			dispatchEvent(event);
		}
		
		protected function onSocketData(evt:ProgressEvent):void
		{
			try
			{
				parseSocketData();
			}
			catch (error:*)
			{
				dispatchEvent(new SmartSocketEvent(SmartSocketEvent.DATA_ERROR));
			}
		}
		
		/**
		 * parse the data from remote. 
		 * 
		 */		
		protected function parseSocketData():void
		{
			while(_socket.bytesAvailable >= _len)
			{
				if(_len == -1 && _socket.bytesAvailable >= PREHEAD_LENGTH)
				{
					_len 	= _socket.readUnsignedInt();
				}
				if (this._len == -1)
				{
					return;
				}
				if (_socket.bytesAvailable < _len)
				{
					return;
				}
				var buffer:ByteArray = new ByteArray();
				_socket.readBytes(buffer, 0, _len);
				_len = -1;
				dispatchEvent(new SmartSocketEvent(SmartSocketEvent.DATA,{data:buffer}));
			}
		}
		
		/**
		 * send a package 
		 * @param id
		 * @param data
		 * 
		 */		
		public function send(id:uint, data:ByteArray) : void
		{
			var head:ByteArray = new ByteArray();
			head.writeUnsignedInt(id);
			//write the package's total lenght.
			this._socket.writeUnsignedInt(head.length + data.length);
			//write the service's id.
			this._socket.writeBytes(head, 0, head.length);
			//write the data.
			this._socket.writeBytes(data, 0, data.length);
			this._socket.flush();
		}
		
		protected function onSocketClose(evt:Event):void
		{
			logger.debug("socket(ip:"+_lastIpAddress+",host:"+_lastTcpPort+" ) disconnect");
			connected = false;
			dispatchEvent(new SmartSocketEvent(SmartSocketEvent.DISCONNECT));
		}
		
		private function onSocketConnect(evt:Event) : void
		{
			logger.debug("socket(ip:"+_lastIpAddress+",host:"+_lastTcpPort+" ) connect");
			connected = true;
			var event:SmartSocketEvent = new SmartSocketEvent(SmartSocketEvent.CONNECT);
			event.data = {success:true};
			dispatchEvent(event);
		}
	}
}