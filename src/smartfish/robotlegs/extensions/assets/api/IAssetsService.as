package smartfish.robotlegs.extensions.assets.api
{
	import smartfish.robotlegs.base.Promise;
	import smartfish.robotlegs.extensions.assets.impl.AssetsConfigCache;

	/**
	 * Application initialize to load assets.
	 * @author rayyee
	 */	
	public interface IAssetsService extends Promise
	{
		/**
		 * Initialize to load config file.
		 * @param config			application config file.
		 * @param pathPerfix		assets url perfix.
		 * @param deadStart			if true, auto load second file after first file load complete.
		 * @return 
		 */		
		function initialize( config:String, pathPerfix:String = "", deadStart:Boolean = true ):IAssetsService;
		
		/**
		 * load progress handler.
		 * @param value
		 * @return 
		 */		
		function progress( value : Function ):IAssetsService;
		
		/**
		 * config.xml内容的缓存 
		 * @return 
		 */		
		function get configCache():AssetsConfigCache;
	}
}