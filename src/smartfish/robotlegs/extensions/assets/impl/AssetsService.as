/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午4:59:51
 **/
package smartfish.robotlegs.extensions.assets.impl
{
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import smartfish.robotlegs.base.Service;
	import smartfish.robotlegs.extensions.assets.api.AssetsEvent;
	import smartfish.robotlegs.extensions.assets.api.IAssetsFactory;
	import smartfish.robotlegs.extensions.assets.api.IAssetsLoader;
	import smartfish.robotlegs.extensions.assets.api.IAssetsService;
	
	/**
	 * The service will load config.xml,   
	 * and initialize application assets
	 * 
	 * @trigger		项目初始化时
	 * 
	 * @usage		<code>
	 * 				assetsService
	 *					.initialize( "......config.xml", "http://www.shinezon.com/..." )
	 *					.progress(onApplicationAssetsLoadProgress)
	 *					.complete(onApplicationAssetsLoadComplete)
	 *					.reject(onApplicationAssetsLoadError);
	 *				</code>
	 * 
	 * @warning 	只有1和2次加载的才会加入application domain</br>
	 * 				it`s a asynchronous class
	 * 
	 * @link		AssetsFactory
	 * 
	 * @author 		rayyee
	 */	
	public class AssetsService extends Service implements IAssetsService
	{
		private var _progress:Function;
		private var _deadStart:Boolean;
		private var _pahtPerfix:String;
		private var _assetsCache:AssetsConfigCache;
		
		internal const FIRST_LOADNAME:String = "firstload";
		internal const SECOND_LOADNAME:String = "secondload";
		private const PRIORITY_FIRST:String = "1";
		private const PRIORITY_SECOND:String = "2";
		
		[Inject] public var _assetsFactory:IAssetsFactory;
		[Inject] public var _assetsLoader:IAssetsLoader;
		
		/**
		 * Constructor
		 **/
		public function AssetsService( )
		{
			_assetsCache = new AssetsConfigCache;
			super();
		}
		
		public function get configCache():AssetsConfigCache
		{
			return _assetsCache;
		}
		
		public function initialize( config:String, pathPerfix:String = "", deadStart:Boolean = true ):IAssetsService
		{
			this._deadStart = deadStart;
			_pahtPerfix = pathPerfix;
			_assetsLoader.load(config, "config", 1).addComplete(onLoadConfigComplete);
			return this;
		}
		
		/**
		 * 二次加载</br> 
		 * 静默加载 deadstart
		 */		
		public function loadForSecond():void
		{
			var url:String;
			for each (var confVO:AssetsConfigVO in _assetsCache.getAllAssetsConfig())
			{
				if (confVO.priority == PRIORITY_SECOND)
				{
					url = _pahtPerfix + confVO.path;
					_assetsLoader.load( url, "factory", 2).addComplete(addToFactory, [confVO.id]);
				}
			}
		}
		
		public function progress(value:Function):IAssetsService
		{
			_progress = value;
			return this;
		}
		
		private function onLoadConfigComplete(assetInfo:AssetInfo):void
		{
			var path:String;
			for each (var xml:XML in assetInfo.getXML()..item)
			{
				path = String(xml);
				if (xml.parent().@folder)
				{
					path = _pahtPerfix + xml.parent().@folder + path;
				}
				else
				{
					path = _pahtPerfix + path;
				}
				if (xml.@p == PRIORITY_FIRST)
				{
					_assetsLoader.load(path, FIRST_LOADNAME, 1).addComplete(addToFactory, [xml.@id]).addError(onLoadError);
				}
				_assetsCache.cache(xml.@id, new AssetsConfigVO(xml.@id, path, xml.@p, xml.parent().@folder, xml.parent().name()));
			}
			
			_assetsLoader.addGroupComplete(onFirstLoadComplete, FIRST_LOADNAME);
			_assetsLoader.addGroupProgress(onFisrtLoadProgress, FIRST_LOADNAME);
		}
		
		private function onLoadError( e:ErrorEvent ):void
		{
			_reject && _reject( e.text );
		}
		
		private function onFisrtLoadProgress(e:BulkProgressEvent):void
		{
			_progress.apply(null, [e.bytesLoaded, e.bytesTotal]);
		}
		
		private function addToFactory(assetInfo:AssetInfo, id:String):void
		{
			if ( assetInfo.content is DisplayObject )
			{
				_assetsFactory.addDomain(id, (assetInfo.content as DisplayObject).loaderInfo.applicationDomain);
			}
			else if ( assetInfo.content is XML || assetInfo.content is String )
			{
				_assetsFactory.addContent(id,assetInfo.content);
			}
		}
		
		private function onFirstLoadComplete(e:BulkProgressEvent):void
		{
			dispatch(new AssetsEvent( AssetsEvent.ASSETS_LOAD_COMPLETE ));
			propagate();
			if ( _deadStart )
			{
				loadForSecond();
			}
		}

	}
}