package smartfish.robotlegs.extensions.http.api
{
	public interface IHttpManager
	{
		function initialize( apiPath:String,show:Function = null,hide:Function= null,showError:Function=null):void;
		
		function registerService(key:String, type:Class ,isBind:Boolean  = false):void
		function unRegisterService(id:String, type:Class):void;
		
		function getEmptyService(id:String):IHttpService;
		
		function addHttpRequest(value:IHttpRequest):void;
		function callNextHttpRequest():void;
		function get path():String;
		
		function set modalCount(value:int):void;
		function get modalCount():int;
		
		function get showError():Function;
		function get showModal():Function;
		function get hideModal():Function;
		
		function queue(service:IHttpService):void;
		function setPackInterval(value:int):void;
		function setRequestTimeouts(seconds:int):void;
		function set maxConnections(value:int):void;
		function get maxConnections():int;
		function clearService():void;
	}
}