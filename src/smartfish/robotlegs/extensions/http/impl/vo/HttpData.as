/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午5:53:42
 **/
package smartfish.robotlegs.extensions.http.impl.vo
{
	/**
	 * 通讯层vo 
	 * @author chenyonghua
	 * 
	 */	
	public class HttpData
	{
		public var uniqueId:int;					//唯一标识
		public var path:String;						//后端API调用路径
				
		public var callback:Function;				// 调用后端成功的回调方法
		
		public var result:Boolean;					// 接口调用是否成功
		public var params:Array;					// 接口调用参数
		public var userData:Object;					// 需要附带的数据
		public var remoteData:Object;				// 服务端返回的数据	
		
		public var errorMsg:String;					// 错误信息
		public var errorCode:int;					// 错误码
		
		public function HttpData()
		{
			
		}
		
		public function reset():void
		{
			uniqueId 		= -1;
			path 			= "";
			callback 		= null; 
			result 			= false;
			params 			= null;
			userData 		= null;
			remoteData 		= null;
			errorMsg 		= null;
			errorCode 		= -1;
		}
	}
}