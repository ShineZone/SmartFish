## BaseService
> all service will implement IService.    
> 外部可以注册service的完成和错误2个处理器。

	facebookFriendService
		.call( "uid, is_app_user, name, sex", "('active', 'offline')" )
		.complete( onGetComplete )
		.reject( onError );




## BaseView

> View常用的一些操作，以及注入View有权限获取的框架层组件。