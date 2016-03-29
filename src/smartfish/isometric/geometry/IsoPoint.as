/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午2:53:21
 **/
package smartfish.isometric.geometry
{
	public class IsoPoint
	{
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		/**
		 * Constructor
		 **/
		public function IsoPoint( x:Number = 0, y:Number = 0, z:Number = 0 )
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}
}