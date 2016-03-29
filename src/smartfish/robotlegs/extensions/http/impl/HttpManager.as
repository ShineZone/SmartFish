package smartfish.robotlegs.extensions.http.impl
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import smartfish.robotlegs.extensions.http.api.IHttpManager;
	import smartfish.robotlegs.extensions.http.api.IHttpRequest;
	import smartfish.robotlegs.extensions.http.api.IHttpService;
	import smartfish.robotlegs.extensions.http.api.IHttpServiceFactory;
	import smartfish.robotlegs.extensions.http.impl.vo.HttpData;

	public class HttpManager implements IHttpManager
	{
		///////////////////////////////////////////////////////////////////////
		// injections //////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		[Inject]
		public var serviceFacetory:IHttpServiceFactory;
		[Inject]
		public var injector:IInjector;
		
		///////////////////////////////////////////////////////////////////////
		// VARIABLES //////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		private var pendingRemotes:Vector.<IHttpService>;
		private var timer:Timer;
		private var _maxConnections:int = 8;
		private var requestTimeouts:int;		//超时时间（秒）
		
		private var httpQueue:HttpQueue;		//http请求队列
		private var _modalCount:int;			//需要显示模态的数量
		private var _httpUniqueIdCnt:int = 0;	//http唯一标识
		private var _path:String;				//后端路径
		private var _showModal:Function;		//显示模态窗口的方法
		private var _hideModal:Function;		//关闭模态窗口的方法
		private var _showError:Function;		//显示错误的方法
		
		///////////////////////////////////////////////////////////////////////
		// setter & getter ////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function get modalCount():int
		{
			return _modalCount;
		}
		
		public function set modalCount(value:int):void
		{
			_modalCount = value;
			if( _modalCount > 0 )
			{
				if( _showModal != null )
				{
					_showModal.apply();
				}
			}
			else
			{
				if( _hideModal != null )
				{
					_hideModal.apply();
				}
			}
		}
		public function get showError():Function
		{
			return _showError;
		}
		public function get showModal():Function
		{
			return _showModal;
		}
		public function get hideModal():Function
		{
			return _hideModal;
		}
		/**
		 * backend path 
		 * @return 
		 * 
		 */		
		public function get path():String
		{
			return _path;
		}
		/**
		 * 一个HTTP请求允许包含的最大request数量
		 * @return 
		 * 
		 */		
		public function get maxConnections():int
		{
			return _maxConnections;
		}

		public function set maxConnections(value:int):void
		{
			_maxConnections = value;
		}
		
		///////////////////////////////////////////////////////////////////////
		// CONSTRUCTOR ////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function HttpManager()
		{			
			pendingRemotes = new Vector.<IHttpService>();
			httpQueue = new HttpQueue();
		}
		
		/**
		 *  初始化
		 * @param pathToBackend 后端API的路径
		 * 
		 */		
		public function initialize( apiPath:String,show:Function = null,hide:Function= null,showError:Function=null):void
		{
			this._showModal = showModal;
			this._hideModal = hideModal;
			this._showError = showError;
			this._path 		= apiPath;
			
			setPackInterval(5000);
		}
		
		/**
		 * 设置自动组合的时间
		 * @param value
		 * 
		 */		
		public function setPackInterval(value:int):void
		{
			if(timer != null)
			{
				timer.removeEventListener(TimerEvent.TIMER,processPendingServices);
				timer.stop();
			}
			timer = new Timer(value);
			timer.addEventListener(TimerEvent.TIMER,processPendingServices);
			checkTimer();
		}
		
		/**
		 * 设置单个HTTP请求超时时间 
		 * @param seconds
		 * 
		 */		
		public function setRequestTimeouts(seconds:int):void
		{
			requestTimeouts = seconds;
		}
		
		///////////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		/**
		 * 检测timer 
		 */		
		private function checkTimer():void
		{
			if(pendingRemotes.length > 0)
			{
				if(!timer.running)
				{
					timer.start();
				}
			}
			else
			{
				if(timer.running)
					timer.stop();
			}
		}
		
		/**
		 * 自动组合service 
		 * @param evt
		 * 
		 */		
		private function processPendingServices(evt:TimerEvent):void
		{
			trace("[processPendingServices] processing");
			if(pendingRemotes.length > 0)
			{
				var vec:Vector.<IHttpService> 	= pendingRemotes.concat();
				pendingRemotes.length 			= 0;
				
				var paramsTemp:Array 	= [];
				var userDatas:Array 	= [];
				var service:IHttpService;
				for (var i:int = 0, len:int = vec.length; i < len; i++)
				{
					service = vec[i];
					if (service.hasApplied)
					{
						continue;
					}
					service.apply();
					service.hasApplied = true;
					var unBind:Boolean = serviceFacetory.verifyService(service.name);
					if(unBind)
					{
						//先发送前面一部分
						if(paramsTemp.length > 0)
						{
							splitGroup(paramsTemp,userDatas);
							paramsTemp.length 	= 0; 
							userDatas.length 	= 0;
						}
						//再把当前的发出去
						createHttpRequest([[service.name,service.params]],[service]);
					}
					else
					{
						paramsTemp.push([service.name,service.params]);
						userDatas.push(service);
					}
				}
				
				//整个循环收集的request发出去
				if(paramsTemp.length > 0)
				{
					splitGroup(paramsTemp,userDatas);
					paramsTemp.length 	= 0; 
					userDatas.length 	= 0;
				}
			}			
			checkTimer();
		}
		
		/**
		 * 通过一个包的最大请求数进行分组 
		 * @param params
		 * @param userDatas
		 * 
		 */		
		private function splitGroup(params:Array,userDatas:Array):void
		{
			while(params.length > 0)
			{
				var paramsGroup:Array = params.splice(0,_maxConnections);
				var userDatasGroup:Array = userDatas.splice(0,_maxConnections);
				createHttpRequest(paramsGroup,userDatasGroup);
			}
		}
		
		
		/**
		 * 创建http 
		 * @param params
		 * @param userDatas
		 * @param isModal
		 * 
		 */		
		private function createHttpRequest(params:Array,userDatas:Array):void
		{
			var httpData:HttpData 	= new HttpData();
			httpData.reset();
			httpData.uniqueId		= generateUniqueId();
			httpData.path			= path;
			httpData.callback 		= onDataReceived;
			httpData.params			= params.concat();
			httpData.userData		= userDatas.concat();
			var http:HttpRequest 	= injector.getInstance(HttpRequest);
			http.setTimeOuts(requestTimeouts);
			http.setData(httpData);
			addHttpRequest(http);
		}
		
		///////////////////////////////////////////////////////////////////////
		// INTERFACE //////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		/**
		 * 添加service进自动组合队列 
		 * @param service
		 * 
		 */		
		public function queue(service:IHttpService):void
		{
			pendingRemotes.push(service);
			service.onQueued();
			if(service.isModal)
			{
				++modalCount;
			}
			checkTimer();
		}
		
		/**
		 * 添加一个http进发送队列 
		 * @param value
		 * 
		 */		
		public function addHttpRequest(value:IHttpRequest):void
		{
			httpQueue.push(value);
		}
		
		/**
		 * 请求下一个连接。 
		 * 
		 */		
		public function callNextHttpRequest():void
		{
			httpQueue.next();
		}
		
		private function generateUniqueId():int
		{
			return _httpUniqueIdCnt++;
		}
		
		///////////////////////////////////////////////////////////////////////
		// EVENT HANDLERS /////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		/**
		 * 当后端返回数据进行service分发。 
		 * @param data
		 * 
		 */		
		private function onDataReceived(data:HttpData):void
		{
			var params:Array		= data.params;
			var userDatas:Array 	= data.userData as Array;

			var i:int;
			var len:int 			= params.length;
			var service:HttpService;
			if(data.result)
			{
				var remoteData:Array 	= data.remoteData  as Array;	
				for (i = 0; i < len; i++)
				{
					service = userDatas[i];
					if(service.isModal)
					{
						--modalCount;
					}
					service.success(remoteData[i]);
				}
			}
			else
			{
				for (i = 0; i < len; i++)
				{
					service = userDatas[i];
					if(service.isModal)
					{
						--modalCount;
					}
					service.fault(data.remoteData);
				}
			}
		}
		
		/**
		 * 清除队列service 
		 * 
		 */		
		public function clearService():void
		{
			pendingRemotes.length = 0;
			checkTimer();
		}
		
		public function registerService(key:String, type:Class, isBind:Boolean=false):void
		{
			serviceFacetory.registerService(key, type, isBind);
		}
		
		public function unRegisterService(id:String, type:Class):void
		{
			serviceFacetory.unRegisterService(id, type);
		}
		
		public function getEmptyService(id:String):IHttpService
		{
			return serviceFacetory.getEmptyService(id);
		}
		
	}
}