/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午2:29:43
 **/
package smartfish.robotlegs.extensions.debug
{
	import flash.display.DisplayObjectContainer;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.extensions.viewProcessorMap.utils.FastPropertyInjector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	
	import smartfish.robotlegs.extensions.debug.api.IConsole;
	import smartfish.robotlegs.extensions.debug.api.IConsoleInjection;
	import smartfish.robotlegs.extensions.debug.impl.DConsole;
	import smartfish.robotlegs.extensions.debug.impl.DUIAppender;
	
	public class DebugConsoleExtension implements IExtension
	{
		private var _console:DConsole;
		private var _context:IContext;
		
		/**
		 * Constructor
		 **/
		public function DebugConsoleExtension()
		{
		}
		
		public function extend(context:IContext):void
		{
			context.injector.map(IConsole).toSingleton(DConsole);
			context.afterInitializing(afterinitializing);
			_console = context.injector.getInstance(IConsole);
			_context = context;
		}
		
		private function afterinitializing():void
		{
			var contextView:DisplayObjectContainer = (_context.injector.getInstance(ContextView) as ContextView).view;
			_context.addLogTarget(new DUIAppender( contextView, _console ));
			
			const viewProcessorMap:IViewProcessorMap = _context.injector.getInstance(IViewProcessorMap);
			viewProcessorMap.mapMatcher( new TypeMatcher().anyOf(IConsoleInjection) ).toProcess( new FastPropertyInjector({console:IConsole}) );
		}
	}
}