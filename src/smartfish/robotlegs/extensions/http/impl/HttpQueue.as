/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:33:21
 **/
package smartfish.robotlegs.extensions.http.impl
{
	import smartfish.robotlegs.extensions.http.api.IHttpRequest;

	internal class HttpQueue
	{
		private var _queue:Vector.<IHttpRequest>;
		
		private var _running:Boolean;
		
		/**
		 * Constructor
		 **/
		public function HttpQueue()
		{
			_running = false;
			_queue = new Vector.<IHttpRequest>;
		}
		
		internal function push( value : IHttpRequest ):void
		{
			_queue.push( value );
			if(!_running)
			{
				next();
			}
		}
		
		internal function next():void
		{
			if (_queue.length == 0)
			{
				_running = false;
			}
			else
			{
				_running = true;
				_queue.shift().call();
			}
		}

		internal function get running():Boolean
		{
			return _running;
		}

	}
}