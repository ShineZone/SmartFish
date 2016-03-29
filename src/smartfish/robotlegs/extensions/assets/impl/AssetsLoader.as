package smartfish.robotlegs.extensions.assets.impl
{	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import smartfish.robotlegs.extensions.assets.api.IAssetsLoader;
	
	/**
	 * 资源加载 
	 * @author rayyee
	 */	
	public class AssetsLoader implements IAssetsLoader
	{
		private var _listener:AssetsLoaderListener;
		public var cacheLoader:BulkLoader;
		public var cache:Object;
		
		public function AssetsLoader() 
		{
			this.initilize();
		}
		
		private function initilize():void
		{
			this.cache			= new Object();
			this._listener		= new AssetsLoaderListener(this);
		}
		
		private function pauseAllLoader():void
		{
			BulkLoader.pauseAllLoaders();
		}
		
		private function resumeAllLoader():void
		{
			for each (var atLoader : BulkLoader in BulkLoader._allLoaders)
			{
				atLoader.resumeAll();
			}
		}
		
		public function addGroupComplete(onComplete:Function, loaderName:String = "main"):void
		{
			var _loader:BulkLoader = BulkLoader.getLoader(loaderName);
			if ( _loader.isFinished )
			{
				onComplete( null );
			}
			else
			{
				_loader.addEventListener(BulkProgressEvent.COMPLETE, onComplete);
			}
		}
		
		public function addGroupProgress(onProcess:Function, loaderName:String = "main"):void
		{
			var _loader:BulkLoader = BulkLoader.getLoader(loaderName);
			if ( _loader.isRunning )
			{
				_loader.addEventListener(BulkProgressEvent.PROGRESS, onProcess);
			}
		}
		
		/**
		 * 加载
		 * @param	key      			URL地址
		 * @param	loaderName			加载域的名字
		 */
		public function load( key:String, loaderName:String = "factory", priority:int = 1 ):AssetsLoaderListener
		{
			cacheLoader = BulkLoader.getLoader( loaderName );
			cacheLoader ||= new BulkLoader( loaderName, 3 );
			var item:LoadingItem = this.cacheLoader.get( key );
			
			var bloader:BulkLoader = BulkLoader.whichLoaderHasItem( key );
//			!this.cacheLoader.hasItem(key, false)
			if ( bloader == null )
			{
				if ( item == null )
				{
					var context:LoaderContext = new LoaderContext();
					context.applicationDomain = new ApplicationDomain( ApplicationDomain.currentDomain );
					item = this.cacheLoader.add( key, {id:key, context:context, priority:priority} );
				}
				
				if ( !this.cacheLoader.isRunning )
				{
					this.cacheLoader.start();
				}
				
				if ( priority == int.MAX_VALUE )
				{
					pauseAllLoader();
					item.addEventListener(Event.COMPLETE, onPopupAssetsLoadComplete);
				}
				
				item.addEventListener(Event.COMPLETE, onLoadComplete);
				item.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			}
			
			_listener.key = key;
			_listener.loadItem = item;
			
			return _listener;
		}
		
		private function onPopupAssetsLoadComplete( e:Event ):void
		{
			resumeAllLoader();
		}
		
		protected function onLoadProgress(e:ProgressEvent):void
		{
			var item:LoadingItem	= e.target as LoadingItem;		
			for(var i:int=0;i<this.cache[item.id].onUpdates.length;i++)
			{
				var temp:Array = (this.cache[item.id].onUpdateParams[i] as Array).concat();
				temp.splice(0,0,item.percentLoaded);
				(this.cache[item.id].onUpdates[i] as Function).apply(null,temp);
			}
		}
		
		private function onLoadComplete(e:Event):void
		{
			var item:LoadingItem	= e.target as LoadingItem;			
			applyCallback(item);
			if (item.hasEventListener(BulkProgressEvent.COMPLETE))
			{
				item.removeEventListener(Event.COMPLETE, onLoadComplete);
				item.removeEventListener(ProgressEvent.PROGRESS, onLoadComplete);
			}
		}
		
		internal function applyCallback(item:LoadingItem):void 
		{
			var content:*            	= item.content;
			this.cache[item.id].content = content;
			for (var i:int=0;i<this.cache[item.id].onCompletes.length;i++)
			{
				if (content is DisplayObject)
				{
					this.cache[item.id].content.x = 0;
					this.cache[item.id].content.y = 0;
				}
				(this.cache[item.id].onCompleteParams[i] as Array).splice(0,0,this.cache[item.id] as AssetInfo);
				(this.cache[item.id].onCompletes[i] as Function).apply(null,this.cache[item.id].onCompleteParams[i]);
			}
			
			this.cache[item.id].onCompletes	    = [];
			this.cache[item.id].onUpdates	    = [];
			this.cache[item.id].onUpdateParams	    = [];
			this.cache[item.id].onCompleteParams	= [];
		}
	}

}