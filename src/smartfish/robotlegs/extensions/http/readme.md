# Usage

### initialization
---

	eg:
	[Inject]
	public var httpManager:IHttpManager;
	[Inject]
	public var serviceFactory:IHttpServiceFactory; 
	 
	httpManager.initialize("http://frame.shinezone.com/?dev=daihh");	
	serviceFactory.registerHandler(TestService.NAME,TestService,false);
	serviceFactory.registerHandler(UnBindService.NAME,UnBindService,true);
	 
	var service:IHttpService = serviceFactory.getEmptyService(TestService.NAME) as HttpService;	
	service.send(["luke","params"+id],null,true);
		
> 协议全部会以组合形式出现，框架层会处理掉，所以业务调用时不需要额外处理单包多包。
