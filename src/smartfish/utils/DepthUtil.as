package smartfish.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 深度管理器 
	 * @author chenyonghua
	 * 
	 */	
	public class DepthUtil
	{
		public function DepthUtil()
		{
			
		}
		public static function bringToBottom(dis:DisplayObject):void
		{
			var container:DisplayObjectContainer = dis.parent;
			if (container == null)
			{
				return;
			}
			if (container.getChildIndex(dis) != 0)
			{
				container.setChildIndex(dis, 0);
			}
		}
		
		public static function bringToTop(dis:DisplayObject):void
		{
			var container:DisplayObjectContainer = dis.parent;
			if (container == null)
			{
				return;
			}
			if (container.getChildIndex(dis) != container.numChildren-1)
			{
				container.setChildIndex(dis, container.numChildren-1);
			}
		}
	}
}