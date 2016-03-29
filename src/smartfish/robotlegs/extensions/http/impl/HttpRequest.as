/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:53:42
 **/
package smartfish.robotlegs.extensions.http.impl
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;
	
	import smartfish.robotlegs.extensions.http.api.IHttpManager;
	import smartfish.robotlegs.extensions.http.api.IHttpRequest;
	import smartfish.robotlegs.extensions.http.impl.vo.HttpData;
	
	/**
	 * 处理消息请求响应
	 * @author chenyonghua
	 * 
	 */
	public class HttpRequest implements IHttpRequest
	{
		
		[Inject]
		public var httpManager:IHttpManager;
		
		private var logger:ILogger;
		private var httpData:HttpData;
		private var loader:URLLoader;	
		private var retries:int = 3;	//重连次数
		private var timer:Timer;		//定时器
		private var startTime:int; 		//开始时间
		private var timeouts:int; 		//超时时间
		public function HttpRequest(context:IContext)
		{
			this.logger = context.getLogger(this);
			timer 		= new Timer(50);
			timeouts	= 5000;
		}
		
		/**
		 * 请求数据 
		 * @param httpData
		 * 
		 */		
		public function setData( httpData:HttpData ):void
		{
			this.httpData = httpData;
		}
		
		/**
		 * 设置超时时间 
		 * @param seconds
		 * 
		 */		
		public function setTimeOuts(seconds:int):void
		{
			timeouts = seconds * 1000;
		}
		
		/**
		 * 重置 
		 * 
		 */		
		public function reset():void
		{
			if(loader)
			{
				removeListeners();
			}
			loader 		= null;
			if(timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimer);
				timer.stop();
				timer.reset();
			}
		}
		
		/**
		 * call后台 
		 * 
		 */		
		public function call():void
		{	
			var urlRequest:URLRequest	= new URLRequest(httpData.path);
			urlRequest.method			= URLRequestMethod.POST;
			urlRequest.data				= "*=" + com.adobe.serialization.json.JSON.encode(httpData.params == null ? [] : httpData.params);
			
			loader	= new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onHttpData);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onHttpError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onHttpError);
			logger.debug("===============================================================");
			dump();
			logger.debug("[HttpRequest "+httpData.uniqueId+"] call start:");
			loader.load(urlRequest);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
			
			startTime = getTimer();
		}
		
		/**
		 * 超时 
		 * @param event
		 * 
		 */		
		protected function onTimer(event:TimerEvent):void
		{
			if(getTimer() - startTime < timeouts)
			{
				return;
			}
			
			logger.debug("第"+(4-retries)+"次调用超时:");
			dump();
			retries--;
			if(checkRetry()){
				reset();
				this.call();
			}else{
				httpData.result				= false;
				httpData.errorCode			= 404;
				httpData.errorMsg			= "request time out!";
				httpData.remoteData			= null;
				
				if(httpManager.showError != null)
				{
					httpManager.showError(httpData);
				}	
				if (httpData.callback != null)
				{
					httpData.callback(httpData);		
				}
				complete();
			}
		}
		
		/**
		 * 当数据返回处理
		 * @param e
		 * 
		 */		
		private function onHttpData(e:Event):void
		{			 
			var loadData:String			= String(loader.data);
			var param:Object;			
			loadData					= loadData == 'undefined' ? '' : loadData;
			try
			{
				param					= com.adobe.serialization.json.JSON.decode(loadData);
			}catch(e:Error){
				logger.error("JSON.decode 出错！")
			}			
			analysisData(param);
			
			complete();
		}
		
		/**
		 * 分析数据 
		 * @param o
		 * 
		 */		
		private function analysisData(o:Object):void{
			httpData.result			= false; 
			if(!o){
				logger.debug( "调用成功，协议出错，返回结构出错:" );
				dump();
				
				httpData.result = false;
			}else{
				httpData.errorCode    	= int(o.code);				
				httpData.result 		= (httpData.errorCode == 0)?true:false;
				if(httpData.result)
				{
					httpData.errorMsg 		= String(o.msg);
				}
			}
			if (!httpData.result)
			{
				logger.debug( "调用成功，有错误，errorCode："+ httpData.errorCode +":");
				dump();
				
				if(httpManager.showError != null){
					httpManager.showError(httpData);
				}	
			}
			else
			{
				logger.debug( "调用:");
				dump();
				logger.debug( "成功,返回数据:"+String(loader.data));
				httpData.remoteData	= o.msg;
			}		
			
			if (httpData.callback != null)
			{
				httpData.callback(httpData);
			}
		}
		
		/**
		 * 当数据出错 
		 * @param e
		 * 
		 */		
		private function onHttpError(e:Event):void{
			logger.debug("第"+(4-retries)+"次调用失败:\n" + e);
			dump();
			
			retries--;
			if(checkRetry()){
				reset();
				this.call();
			}else{
				httpData.result				= false;
				httpData.errorCode			= 404;
				httpData.errorMsg			= String(e.type);
				httpData.remoteData			= null;
				
				if(httpManager.showError != null)
				{
					httpManager.showError(httpData);
				}	
				if (httpData.callback != null)
				{
					httpData.callback(httpData);		
				}
				complete();
			}
		}
		
		/**
		 * 重连 
		 * @return 
		 * 
		 */		
		private function checkRetry():Boolean{
			if(retries<=0){
				return false;
			}else{				
				return true;
			}
		}
		
		/**
		 * 清除侦听 
		 * 
		 */		
		public function removeListeners():void{
			if(loader.hasEventListener(Event.COMPLETE))
			{
				loader.removeEventListener(Event.COMPLETE, onHttpData);
			}
			if(loader.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onHttpError);
			}
			if(loader.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onHttpError);
			}
		}
		
		private function dump():void
		{
			for each (var i:Array in httpData.params)
			{
				logger.debug("module.action:" + i[0] + ", params:[" + i[1] + "]");
			}
		}
		
		/**
		 * 执行完成 
		 */		
		private function complete():void
		{
			reset();
			httpManager.callNextHttpRequest();
			httpData 		= null;
			logger 			= null;
			httpManager 	= null;
		}
		
		
	}
}