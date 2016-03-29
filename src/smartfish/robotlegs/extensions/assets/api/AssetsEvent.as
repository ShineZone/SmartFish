/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:05:48
 **/
package smartfish.robotlegs.extensions.assets.api
{
	import flash.events.Event;
	
	public class AssetsEvent extends Event
	{
		public static const ASSETS_LOAD_COMPLETE:String = "AssetsEvent::assets_load_complete";
		
		/**
		 * Constructor
		 **/
		public function AssetsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}