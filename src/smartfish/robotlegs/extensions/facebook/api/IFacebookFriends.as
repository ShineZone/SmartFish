package smartfish.robotlegs.extensions.facebook.api
{
	import smartfish.robotlegs.base.Promise;

	public interface IFacebookFriends extends Promise
	{
		function call( selectCondition : String = "", whereCondition : String = "" ):Promise;
	}
}