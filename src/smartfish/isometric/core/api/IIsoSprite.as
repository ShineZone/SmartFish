/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午3:10:26
 **/
package smartfish.isometric.core.api
{
	import smartfish.isometric.core.ext.IIsoSpriteExtension;
	
	/**
	 * Isometric world normal sprite 
	 * @author rayyee
	 */	
	public interface IIsoSprite extends IIsoObject
	{
		
		/**
		 * 安装插件 
		 * @param value
		 * @param mapTo
		 */		
		function install( value : IIsoSpriteExtension, mapTo : * ):void;
		
		/**
		 * 旋转 
		 * @param degree
		 * @return 
		 */		
		function rotation( degree:Number = 90 ):Boolean;
		
		/**
		 * 移动
		 * @param x
		 * @param y
		 */		
		function moveTo( x:Number, y:Number ):Boolean;
		
		/**
		 * 移动到索引位置 
		 * @param x
		 * @param y
		 */		
		function moveIndexTo( x:int = 0, y:int = 0 ):Boolean;
		
		/**
		 * 设置Sprite所占格子尺寸 
		 * @param width
		 * @param height
		 * @param length
		 */		
		function setSize( width:int, height:int, length:int ):void
		
		/**
		 * 设置材质 
		 * @param value
		 */			
		function set sprites( value:Array ):void;
		
		/**
		 * 获取插件 
		 * @param key
		 * @return 
		 */		
		function getExtension( key : * ):*;
		
	}
}