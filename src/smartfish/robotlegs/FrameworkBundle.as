/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:10:25
 **/
package smartfish.robotlegs
{
	import robotlegs.bender.framework.api.IBundle;
	import robotlegs.bender.framework.api.IContext;
	
	import smartfish.robotlegs.extensions.assets.AssetsExtension;
	import smartfish.robotlegs.extensions.debug.DebugConsoleExtension;
	import smartfish.robotlegs.extensions.facebook.FacebookConfig;
	import smartfish.robotlegs.extensions.facebook.FacebookExtension;
	import smartfish.robotlegs.extensions.http.HttpExtension;
	import smartfish.robotlegs.extensions.popup.PopupExtension;
	
	public class FrameworkBundle implements IBundle
	{
		/**
		 * Constructor
		 **/
		public function FrameworkBundle()
		{
		}
		
		public function extend(context:IContext):void
		{
			context.install( 
				AssetsExtension, 
				PopupExtension,
				HttpExtension,
				FacebookExtension,
				DebugConsoleExtension
			);
			
			context.configure( 
				FacebookConfig
			);
		}
	}
}