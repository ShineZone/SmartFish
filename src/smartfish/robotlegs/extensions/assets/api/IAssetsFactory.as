package smartfish.robotlegs.extensions.assets.api
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import smartfish.robotlegs.extensions.assets.impl.AssetsConfigCache;

	public interface IAssetsFactory extends IEventDispatcher
	{
		/**
		 * config.xml内容的缓存 
		 * @return 
		 */		
		function get configCache():AssetsConfigCache;
		
		function getClass(key:String,domainName:String = null):Class;
		function getMovieClip(key:String,domainName:String = null):MovieClip;
		function getBitmap(key:String,domainName:String = null):Bitmap;
		function getSimpleButton(key:String,domainName:String = null):SimpleButton;
		function getSprite(key:String,domainName:String = null):Sprite;
		function getXML( key : String ):XML;
		function getText( key : String ):String;
		function addDomain(name:String, domain:ApplicationDomain):void;
		function addContent(key:String,content:*):void;
		function removeDomain(name:String):void;
	}
}