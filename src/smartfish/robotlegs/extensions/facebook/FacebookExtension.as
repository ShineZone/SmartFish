/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午3:36:34
 **/
package smartfish.robotlegs.extensions.facebook
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;
	
	import smartfish.robotlegs.extensions.facebook.api.IFacebookAvatar;
	import smartfish.robotlegs.extensions.facebook.api.IFacebookFriends;
	import smartfish.robotlegs.extensions.facebook.impl.FacebookFriendsService;
	import smartfish.robotlegs.extensions.facebook.impl.FacebookQuery;
	
	public class FacebookExtension implements IExtension
	{
		private var _injector : IInjector;

		private var _facebookQuery : FacebookQuery;
		
		/**
		 * Constructor
		 **/
		public function FacebookExtension()
		{
			//兑换货币
			//https://graph.facebook.com/me?fields=currency&access_token=" + ServiceData.access_token;
			
			//avatar
			
			//authorize
			
			//friends
		}
		
		public function extend(context:IContext):void
		{
			_injector = context.injector;
			context.whenInitializing( initialized );
			_facebookQuery = new FacebookQuery();
			context.injector.map( IFacebookFriends ).toSingleton( FacebookFriendsService );
			context.injector.map( IFacebookAvatar );
		}
		
		private function initialized():void
		{
			
		}
	}
}