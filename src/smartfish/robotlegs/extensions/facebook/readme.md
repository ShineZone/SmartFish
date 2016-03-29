#Facebook Extension

## Installation
安装非常简单，装上后，再配置下。

	_context = new Context()
    .install( FacebookExtension )
    .configure( FacebookConfig );
    
## Usage

- 注意事项
	- FacebookExtension需要平台acess token，通过Context.configure设置配置的时候可以设置acess token给FacebookExtension，详见进阶使用
	- 通常情况下只需要默认配置安装即可（如果需要更多功能和一些条件可参考进阶使用），默认情况下具体如下功能：
		> 获取玩家的所有好友数据，数据字段包括 "name, uid,first_name, sex, is_app_user, online_presence"
		
		
		
		
- 进阶使用

	- FacebookQuery常量
		> NORMAL   
		> ONLINESTATE_LIVE

	- FacebookConfig自定义配置
	
			public class FacebookConfig implements IConfig
			{
				[Inject]
				public var contextView:ContextView;
		
				public function configure():void
				{
					//可以通过flashvar传递，亦或是别的方式
					var flashVars:Object = contextView.view.loaderInfo.parameters;
					FacebookConst.Access_Token = flashVars.access_token;
				}
			}
			
	- IFacebookFriends使用
	
			public class GetFacebookFriendsCommand extends Command
			{
				[Inject] 
				public var facebookFriend:IFacebookFriends;
		
				/**
				 * Constructor
				 **/
				public function GetFacebookFriendsCommand()
				{
					//Default use  facebookFriend.call(onGetComplete);
					//facebookFriend.call( onGetComplete, FacebookQuery.NORMAL, FacebookQuery.ONLINESTATE_LIVE );
			
					//Diy use
					facebookFriend.call( onGetComplete, "uid, is_app_user, name, sex", "('active', 'offline')" );
				}
		
				private function onGetComplete():void
				{
					//对应 selectCondition
					for each (var fdata:* in value)
					{
						if (fdata.is_app_user == true)
						{
							fdata.uid;
							fdata.name;
							fdata.sex;
						}
						else {}
					}
				}
			}
			
	