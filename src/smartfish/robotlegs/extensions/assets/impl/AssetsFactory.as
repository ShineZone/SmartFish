package smartfish.robotlegs.extensions.assets.impl
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.BulkLoader;
	
	import smartfish.robotlegs.extensions.assets.api.IAssetsFactory;
	import smartfish.robotlegs.extensions.assets.api.IAssetsService;

	/**
	 * 资源工厂  
	 * 获取加载完的资源 
	 * @author rayyee
	 */	
	public class AssetsFactory extends EventDispatcher implements IAssetsFactory
	{		
		public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		public static const ERROR:String 	= "error";
		
		private var domainDict:Dictionary;
		private var loaderDataDic:Dictionary;
		private var items:Array;
		
		[Inject] public var assetsService:IAssetsService;
		
		public function AssetsFactory() 
		{
			init();
		}
		
		/**
		 * 初始化类库加载器 
		 */		
		private function init():void
		{
			domainDict 			= new Dictionary(true);	
			loaderDataDic     	= new Dictionary(true);	

			items = [];
		}
		
		public function get configCache():AssetsConfigCache
		{
			return assetsService.configCache;
		}
		public function addContent(key:String,content:*):void
		{
			loaderDataDic[key] = content;
		}
		/**
		 * 添加域
		 * @param name
		 * @param domain
		 * 
		 */		
		public function addDomain(name:String, domain:ApplicationDomain):void	
		{
			if (domainDict[name] == null)
			{
				domainDict[name] = domain;
			}
		}
				
		/**
		 * 删除域
		 * @param name
		 * @param domain
		 * 
		 */		
		public function removeDomain(name:String):void	
		{
			if (domainDict[name] != null)
			{
				domainDict[name] = null;
			}
		}
		
		public function getXML( key : String ):XML
		{
			if(loaderDataDic.hasOwnProperty(key))
			{
				return XML(loaderDataDic[key]);				
			}
			return null;
		}
		
		public function getText( key : String ):String
		{
			if(loaderDataDic.hasOwnProperty(key))
			{
				return String(loaderDataDic[key]);				
			}
			return null;
		}
		
		/**
		 * 获取指定类
		 * @param	key
		 * @return
		 */
		public function getClass(key:String, domainName:String = null):Class 
		{
			var cls:Class = getClassFromDomain(key,domainName);
			if (cls)
			{
				return cls;
			}
			return null;
		}
		
		public function getMovieClip(key:String, domainName:String = null):MovieClip
		{
			var cls:Class = getClass(key,domainName);
			var mc:MovieClip = new cls();
			return mc;
		}

		public function getBitmap(key:String, domainName:String = null):Bitmap
		{
			var cls:Class = getClass(key,domainName);
			var bit:Bitmap = new Bitmap(new cls() as BitmapData);
			return bit;
		}
		
		public function getSimpleButton(key:String, domainName:String = null):SimpleButton
		{
			var cls:Class = getClass(key,domainName);
			var mc:SimpleButton = new cls();
			return mc;
		}
		
		public function getSprite(key:String, domainName:String = null):Sprite
		{
			var cls:Class = getClass(key,domainName);
			var mc:Sprite = new cls();
			return mc;
		}
				
		private function getClassFromDomain(clsName:String, domainName:String = null):Class
		{
			if (domainName)	
			{
				var domain:ApplicationDomain = domainDict[domainName];
				if (domain)	
				{
					if (domain.hasDefinition(clsName))	
					{
						return domain.getDefinition(clsName) as Class;
					}
					return null;
				}
			}
			for each (var eachDomain:ApplicationDomain in domainDict)	
			{
				if (eachDomain.hasDefinition(clsName))	
				{
					return eachDomain.getDefinition(clsName) as Class;
				}
			}
			return null;
		}
	}
	
}