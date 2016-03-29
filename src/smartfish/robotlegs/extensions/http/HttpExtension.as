/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:53:42
 **/
package smartfish.robotlegs.extensions.http
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	
	import smartfish.robotlegs.extensions.http.api.IHttpManager;
	import smartfish.robotlegs.extensions.http.api.IHttpServiceFactory;
	import smartfish.robotlegs.extensions.http.impl.HttpManager;
	import smartfish.robotlegs.extensions.http.impl.HttpRequest;
	import smartfish.robotlegs.extensions.http.impl.HttpServiceFactory;
	
	/**
	 * 组合通讯 
	 * @author chenyonghua
	 * 
	 * eg:
	 * 		[Inject]
	 *		public var httpManager:IHttpManager;
	 *		
	 * 		httpManager.initialize("http://frame.shinezone.com/?dev=daihh");	
	 * 		httpManager.registerService(TestService.NAME,TestService,false);
	 * 		httpManager.registerService(UnBindService.NAME,UnBindService,true);
	 * 
	 * 		var service:IHttpService = httpManager.getEmptyService(TestService.NAME) as HttpService;	
	 * 		service.send(["luke","params"+id],null,true);
	 * 
	 */	
	public class HttpExtension implements IExtension
	{
		/**
		 * Constructor
		 **/
		public function HttpExtension()
		{
		}
		
		public function extend(context:IContext):void
		{
			context.injector.map(IHttpServiceFactory).toSingleton(HttpServiceFactory);
			context.injector.map(IHttpManager).toSingleton(HttpManager);
			context.injector.map(HttpRequest).toType(HttpRequest);
		}
	}
}