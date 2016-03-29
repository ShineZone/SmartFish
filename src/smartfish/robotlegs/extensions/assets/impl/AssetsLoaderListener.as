/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 上午10:42:32
 **/
package smartfish.robotlegs.extensions.assets.impl
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	public class AssetsLoaderListener
	{
		private var _loadItem:LoadingItem;
		private var _assetsLoader:AssetsLoader;
		private var _key:String;
		
		/**
		 * Constructor
		 **/
		public function AssetsLoaderListener(assetsLoader:AssetsLoader)
		{
			_assetsLoader = assetsLoader;
		}
		
		internal function set loadItem(value:LoadingItem):void
		{
			_loadItem = value;
		}
		
		internal function set key(value:String):void
		{
			_key = value;
		}
		
		public function addComplete(value:Function, params:Array = null):AssetsLoaderListener
		{
			_assetsLoader.cache[_key] ||= new AssetInfo;
			params ||= [];
			_assetsLoader.cache[_key].onCompletes.push(value);
			_assetsLoader.cache[_key].onCompleteParams.push(params);
			
			var bloader:BulkLoader = BulkLoader.whichLoaderHasItem( _key );
			if (bloader)
			{
				var item:LoadingItem = bloader.get( _key );
				if (item.isLoaded)
				{
					_assetsLoader.applyCallback(item);
				}
			}
			
			return this;
		}
		
		public function addError(value:Function):AssetsLoaderListener
		{
			var bloader:BulkLoader = BulkLoader.whichLoaderHasItem( _key );
			if (bloader)
			{
				var item:LoadingItem = bloader.get(_key);
				if (item.isLoaded)
				{
					return this;
				}
			}
			
			_loadItem.addEventListener(BulkLoader.ERROR, value);
			return this;
		}
		
		public function addProgress(value:Function, params:Array = null):AssetsLoaderListener
		{
			var bloader:BulkLoader = BulkLoader.whichLoaderHasItem( _key );
			if (bloader)
			{
				var item:LoadingItem = bloader.get(_key);
				if (item.isLoaded)
				{
					return this;
				}
			}
			
			_assetsLoader.cache[_key] ||= new AssetInfo;
			params ||= [];
			_assetsLoader.cache[_key].onUpdates.push(value);
			_assetsLoader.cache[_key].onUpdateParams.push(params);
			
			return this;
		}

	}
}