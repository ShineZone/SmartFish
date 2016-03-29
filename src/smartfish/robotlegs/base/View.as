/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:47:37
 **/
package smartfish.robotlegs.base
{
	import flash.display.Sprite;
	
	import smartfish.robotlegs.extensions.assets.api.IAssetsLoader;
	import smartfish.robotlegs.extensions.assets.api.IAssetsInjection;
	import smartfish.robotlegs.extensions.assets.api.IAssetsFactory;
	import smartfish.robotlegs.extensions.debug.api.IConsole;
	import smartfish.robotlegs.extensions.debug.api.IConsoleInjection;
	
	public class View 
		extends Sprite 
		implements 
			IAssetsInjection, 
			IConsoleInjection
	{
		protected var _assetsLoader:IAssetsLoader;
		protected var _assetsFactory:IAssetsFactory;
		protected var _console:IConsole;
		
		/**
		 * Constructor
		 **/
		public function View()
		{
			super();
		}
		
		public function initialization():void
		{
			
		}
		
		public function set assetsLoader(value:IAssetsLoader):void{_assetsLoader = value;}
		public function set assetsFactory(value:IAssetsFactory):void{_assetsFactory = value;}
		public function set console(value:IConsole):void{_console = value;}
	}
}