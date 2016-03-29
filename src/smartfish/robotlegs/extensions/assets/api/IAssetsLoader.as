package smartfish.robotlegs.extensions.assets.api
{
	import smartfish.robotlegs.extensions.assets.impl.AssetsLoaderListener;

	public interface IAssetsLoader
	{
		function load(key:String, loaderName:String = "factory", priority:int = 1):AssetsLoaderListener;
		
		/**
		 * 当所有都加载完以后
		 * Handler 里面参数加上  BulkProgressEvent.COMPLETE
		 * @param onComplete
		 * @param loaderName
		 */		
		function addGroupComplete(onComplete:Function, loaderName:String = "main"):void;
		
		/**
		 * 当所有加载的进度发生变化时
		 * BulkProgressEvent.PROGRESS
		 * @param onProcess
		 * @param loaderName
		 */		
		function addGroupProgress(onProcess:Function, loaderName:String = "main"):void;
		
		
	}
}