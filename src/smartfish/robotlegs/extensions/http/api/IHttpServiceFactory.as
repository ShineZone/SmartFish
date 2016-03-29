package smartfish.robotlegs.extensions.http.api
{
	public interface IHttpServiceFactory
	{
		function registerService(key:String, type:Class ,isBind:Boolean  = false):void
		function unRegisterService(id:String, type:Class):void;
		function getEmptyService(id:String):IHttpService;
		function verifyService(key:String):Boolean;
	}
}