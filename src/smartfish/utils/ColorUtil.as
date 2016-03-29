/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午1:28:22
 **/
package smartfish.utils
{
	public class ColorUtil
	{
		/**
		 * Constructor
		 **/
		public function ColorUtil()
		{
		}
		
		public static function toRGBArray( rgb: uint ):Array
		{
			var r: uint = rgb >> 16 & 0xFF;
			var g: uint = rgb >> 8 & 0xFF;
			var b: uint = rgb & 0xFF;
			return [r, g, b];
		}
		
		public static function toRGBCode( r: uint, g: uint, b: uint ):uint
		{
			return r << 16 | g << 8 | b;
		}
	}
}