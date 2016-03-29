/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午4:28:33
 **/
package smartfish.robotlegs.extensions.facebook.impl
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	
	import smartfish.robotlegs.base.Promise;
	import smartfish.robotlegs.base.Service;
	import smartfish.robotlegs.extensions.facebook.api.IFacebookFriends;

	public class FacebookFriendsService extends Service implements IFacebookFriends
	{
		private var _fql : FacebookQuery;
		private var _injector : IInjector;

		private var loader:URLLoader;
		
		/**
		 * Constructor
		 **/
		public function FacebookFriendsService( context : IContext )
		{
			_injector = context.injector;
		}
		
		/**
		 * 调用该Service获取Facebook平台好友数据 
		 * @param selectCondition				要获取的好友数据的哪些字段 @FacebookQuery.NORMAL
		 * @param whereCondition				一些条件限制，比如只查询当前在线的好友 @FacebookQuery.ONLINESTATE_LIVE
		 * @see FacebookQuery[详见]
		 */		
		public function call( selectCondition : String = FacebookQuery.NORMAL, whereCondition : String = "" ):Promise
		{
			var request:URLRequest = new URLRequest( FacebookQuery.getFriendListQuery( selectCondition, whereCondition ) );
			request.method = URLRequestMethod.POST;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			loader.load(request);
			
			return this;
		}
		
		private function securityError(event:SecurityErrorEvent):void
		{
			_reject && _reject(event.text);
		}
		
		private function ioError(event:IOErrorEvent):void
		{
			_reject && _reject(event.text);
		}
		
		private function loadComplete(event:Event):void
		{
			var _parserObject : Object = com.adobe.serialization.json.JSON.decode(event.target.data);
			propagate(_parserObject);
		}
		
		public function set fql(value:FacebookQuery):void
		{
			_fql = value;
		}

	}
}