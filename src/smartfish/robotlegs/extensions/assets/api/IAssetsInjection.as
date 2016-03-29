package smartfish.robotlegs.extensions.assets.api
{
	public interface IAssetsInjection
	{
		function set assetsLoader(value:IAssetsLoader):void;
		function set assetsFactory(value:IAssetsFactory):void;
	}
}