/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:58:24
 **/
package smartfish.robotlegs.extensions.popup
{
	
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.extensions.viewProcessorMap.utils.PropertyValueInjector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	
	import smartfish.robotlegs.extensions.assets.api.IAssetsFactory;
	import smartfish.robotlegs.extensions.popup.api.IPopUpManager;
	import smartfish.robotlegs.extensions.popup.api.IPopUpWindow;
	import smartfish.robotlegs.extensions.popup.impl.PopUpWindow;
	import smartfish.robotlegs.extensions.popup.impl.SFPopUpManager;
	
	public class PopupExtension implements IExtension
	{
		private var _context:IContext;
		
		/**
		 * Constructor
		 **/
		public function PopupExtension()
		{
		}
		
		public function extend(context:IContext):void
		{
			_context = context;
			context.injector.map( IPopUpManager ).toSingleton( SFPopUpManager );
			context.afterInitializing( onInitialization );
		}
		
		private function onInitialization():void
		{
			var popupManager:IPopUpManager = _context.injector.getInstance( IPopUpManager );
			var viewProcessorMap:IViewProcessorMap = _context.injector.getInstance( IViewProcessorMap );
			var popupTypeMatcher:ITypeMatcher = new TypeMatcher().anyOf( IPopUpWindow );
			var assetsFactory:IAssetsFactory = _context.injector.getInstance( IAssetsFactory );
			viewProcessorMap.mapMatcher(new TypeMatcher().allOf(PopUpWindow)).toProcess(new PropertyValueInjector({popupManager:_context.injector.getInstance( IPopUpManager )}));
		}
	}
}