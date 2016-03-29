/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午10:00:21
 **/
package smartfish.robotlegs.extensions.assets
{
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.extensions.viewProcessorMap.utils.FastPropertyInjector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	
	import smartfish.robotlegs.extensions.assets.api.IAssetsFactory;
	import smartfish.robotlegs.extensions.assets.api.IAssetsInjection;
	import smartfish.robotlegs.extensions.assets.api.IAssetsLoader;
	import smartfish.robotlegs.extensions.assets.api.IAssetsService;
	import smartfish.robotlegs.extensions.assets.impl.InitializeViewProcessor;
	import smartfish.robotlegs.extensions.assets.impl.AssetsFactory;
	import smartfish.robotlegs.extensions.assets.impl.AssetsLoader;
	import smartfish.robotlegs.extensions.assets.impl.AssetsService;
	
	public class AssetsExtension implements IExtension
	{
		
		private var _context:IContext;
		
		/**
		 * Constructor
		 **/
		public function AssetsExtension()
		{
		}
		
		public function extend(context:IContext):void
		{
			_context = context;
			
			context.injector.map( IAssetsLoader ).toSingleton( AssetsLoader );
			context.injector.map( IAssetsFactory ).toSingleton( AssetsFactory );
			context.injector.map( IAssetsService ).toValue( new AssetsService );
			
			context.afterInitializing(initializing);
//			context.whenInitializing(initializing);
		}
		
		private function initializing():void
		{
			const _injector:IInjector = _context.injector;
			const _logger:ILogger = _context.getLogger(this);
			
			var _assetsFactory:IAssetsFactory = _injector.getInstance( IAssetsFactory );
			var _assetsService:IAssetsService = _injector.getInstance( IAssetsService );
			_injector.injectInto( _assetsService );
			
			if (_injector.hasDirectMapping(IViewProcessorMap))
			{
				const viewProcessorMap:IViewProcessorMap = _context.injector.getInstance(IViewProcessorMap);
				
				//View processor map
				viewProcessorMap.mapMatcher( new TypeMatcher().anyOf( IAssetsInjection ) ).toProcess( new FastPropertyInjector({assetsFactory:IAssetsFactory, assetsLoader:IAssetsLoader}) );
				viewProcessorMap.mapMatcher( new TypeMatcher().anyOf( IAssetsInjection ) ).toProcess( InitializeViewProcessor );
			}
			else
			{
				_logger.error("A ViewProcessorMap must be installed if you install the AssetsExtension.");
			}
		}
	}
}