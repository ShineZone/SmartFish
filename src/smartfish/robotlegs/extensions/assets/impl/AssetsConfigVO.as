/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午12:54:12
 **/
package smartfish.robotlegs.extensions.assets.impl
{
	public class AssetsConfigVO
	{
		public var id:String;
		public var path:String;
		public var folder:String;
		public var priority:String;
		public var parentLabel:String;
		
		/**
		 * Constructor
		 **/
		public function AssetsConfigVO(id:String, path:String, priority:String = null, folder:String = null, parentLabel:String = null)
		{
			this.parentLabel = parentLabel;
			this.id = id;
			this.path = path;
			this.priority = priority ? priority : "2";
			this.folder = folder ? folder : "";
		}
	}
}