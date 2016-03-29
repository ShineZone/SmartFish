/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:23:43
 **/
package smartfish.robotlegs.extensions.facebook
{
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IConfig;
	
	import smartfish.robotlegs.extensions.facebook.impl.FacebookConst;
	
	public class FacebookConfig implements IConfig
	{
		[Inject]
		public var contextView:ContextView;
		
		/**
		 * Constructor
		 **/
		public function FacebookConfig()
		{
		}
		
		public function configure():void
		{
			var flashVars:Object = contextView.view.loaderInfo.parameters;
			FacebookConst.Access_Token = flashVars.access_token;
		}
	}
}