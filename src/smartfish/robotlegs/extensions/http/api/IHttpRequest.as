/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:27:55
 **/
package smartfish.robotlegs.extensions.http.api
{
	import smartfish.robotlegs.extensions.http.impl.vo.HttpData;
	

	public interface IHttpRequest
	{
		function setData( httpData:HttpData ):void;
		function setTimeOuts(seconds:int):void;
		function call():void;
		function reset():void;
		function removeListeners():void;
	}
}