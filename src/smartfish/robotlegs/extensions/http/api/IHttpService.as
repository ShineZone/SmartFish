/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:53:42
 **/
package smartfish.robotlegs.extensions.http.api
{
	import smartfish.robotlegs.base.Promise;

	public interface IHttpService extends Promise
	{
		/**
		 * unique id.
		 */
		function get id():uint;
		function set id(value:uint):void;
		
		/**
		 *  
		 * module.action
		 */		
		function get name():String;
		function set name(value:String):void;
		
		function get params():Array;
		function set params(value:Array):void;
		function get userData():Object;
		function set userData(value:Object):void
		function get isModal():Boolean;
		function set isModal(value:Boolean):void
		
		/**
		 * add to HttpManager
		 * @param params
		 * @param userData
		 * @param isModal
		 * 
		 */		
		function send(params:Array,userData:Object=null ,isModal:Boolean = true):IHttpService;
		
		/**
		 * Whether or not the IHttpService has been applied
		 * locally yet.
		 */
		function get hasApplied():Boolean;
		function set hasApplied(applied:Boolean):void

		/**
		 * Custom method for an IHttpService to perform whatever service
		 * it is intended to.Primarily used for debugging.
		 */
		function apply():void;	
		
		/**
		 * Custom method for when an IHttpService is added to a queue. Primarily
		 * used for debugging.
		 */
		function onQueued():void;
		
		function success(value:Object):void;
		function fault(value:Object):void;
	}
}