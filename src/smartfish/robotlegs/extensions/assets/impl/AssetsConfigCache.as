/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午6:30:01
 **/
package smartfish.robotlegs.extensions.assets.impl
{
	import flash.utils.Dictionary;

	public class AssetsConfigCache
	{
		private var _pool:Dictionary;
		
		/**
		 * Constructor
		 **/
		public function AssetsConfigCache()
		{
			_pool = new Dictionary();
		}
		
		public function cache(key:String, value:AssetsConfigVO):void
		{
			_pool[key] = value;
		}
		
		public function getAssetsConfigByLabel( value : String ):Vector.<AssetsConfigVO>
		{
			var _assets:Vector.<AssetsConfigVO> = new Vector.<AssetsConfigVO>;
			for each (var i:AssetsConfigVO in _pool)
			{
				if ( i.parentLabel == value ) _assets.push( i );
			}
			return _assets;
		}
		
		public function getAssetsConfigByID(key:String):AssetsConfigVO
		{
			return _pool[key];
		}
		
		public function getAllAssetsConfig():Dictionary
		{
			return _pool;
		}
	}
}