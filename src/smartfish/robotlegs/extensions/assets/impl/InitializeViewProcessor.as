/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:40:38
 **/
package smartfish.robotlegs.extensions.assets.impl
{
	import robotlegs.bender.framework.api.IInjector;

	public class InitializeViewProcessor
	{
		/**
		 * Constructor
		 **/
		public function InitializeViewProcessor()
		{
		}
		
		public function process(view:Object, type:Class, injector:IInjector):void
		{
			if ( view.hasOwnProperty("initialization") )
			{
				view.initialization();
			}
		}
		
		public function unprocess(view:Object, type:Class, injector:IInjector):void
		{
		}
	}
}