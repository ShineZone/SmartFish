/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午7:15:46
 **/
package smartfish.isometric.core
{
	import flash.utils.Dictionary;
	
	import smartfish.isometric.core.api.IIsoObject;

	public class IsoMap
	{
		
		private var _dictMap:Dictionary;
		
		public static const instance:IsoMap = new IsoMap( );
		
		/**
		 * Constructor
		 **/
		public function IsoMap( )
		{
			_dictMap = new Dictionary;	
		}
		
		/**
		 * 校验指定坐标在地图上的映射关系是否通过 
		 * @return 
		 */		
		public function verifyMapRelationship( x:Number, y:Number ):Boolean
		{
			return true;
//			var maps:Vector.<IIsoObject> = getObjects(x, y);
//			return !maps || maps.length < 0;
		}
		
		public function map( value:IIsoObject ):void
		{
			if ( value.isoScene == null ) return;
			var key:String;
			var sprites:Vector.<IIsoObject>;
			var index:int;
			for each (var i:IsoNode in value.isoNodes)
			{
				key = (i.position.x) + "_" + (i.position.y);
				_dictMap[key] ||= new Vector.<IIsoObject>;
				sprites = _dictMap[key];
				if ( sprites.indexOf( value ) == -1 ) sprites.push(value);
			}
		}
		
		public function remap( value:IIsoObject ):void
		{
			if ( value.isoScene == null ) return;
			unmap( value );
			map( value );
		}
		
		public function unmap( value:IIsoObject ):void
		{
			if ( value.isoScene == null ) return;
			var key:String;
			var sprites:Vector.<IIsoObject>;
			var index:int;
			for each (var i:IsoNode in value.isoNodes)
			{
				key = (i.position.x) + "_" + (i.position.y);
				sprites = _dictMap[key];
				if ( sprites )
				{
					index = sprites.indexOf( value );
					if ( index != -1 )
					{
						sprites.splice( index, 1 ); 
					}
				}
			}
		}
		
		public function getObjects( x:Number, y:Number ):Vector.<IIsoObject>
		{
			var key:String = x + "_" + y;
			return _dictMap[key];
		}
	}
}