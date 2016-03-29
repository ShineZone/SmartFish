/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:43:03
 **/
package smartfish.utils
{
	

	public class MathUtil
	{
		/**
		 * Constructor
		 **/
		public function MathUtil()
		{
		}
		
		public static function lerp( start : Number, end : Number, amt : Number ):Number
		{
			return start + ( end - start ) * amt;
		}
		
		public static function map( value : Number, start1 : Number, stop1 : Number, start2 : Number, stop2 : Number ) : Number
		{
			return start2 + ( stop2 - start2 ) * ( ( value - start1 ) / ( stop1 - start1 ) );
		}
		
		public static function norm( value : Number, start : Number, end : Number ) : Number
		{
			return ( value - start ) / ( end - start );
		}
	}
}