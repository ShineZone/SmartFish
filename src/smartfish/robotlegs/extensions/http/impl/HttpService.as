package smartfish.robotlegs.extensions.http.impl
{
	import smartfish.robotlegs.base.Service;
	import smartfish.robotlegs.extensions.http.api.IHttpManager;
	import smartfish.robotlegs.extensions.http.api.IHttpService;
	
	public class HttpService extends Service implements IHttpService
	{
		[Inject]
		public var httpManager:IHttpManager;
		
		private var _id:uint 				= NaN;
		private var _hasApplied:Boolean		= false;
		private var _name:String			= "undefined";
		private var _params:Array			= null;
		private var _userData:Object		= null;
		private var _isModal:Boolean		= true;
		public function HttpService(name:String)
		{
			_name = name;
		}
		
		/**
		 * 参数 
		 * @return 
		 * 
		 */		
		public function get params():Array
		{
			return _params;
		}

		public function set params(value:Array):void
		{
			_params = value;
		}

		/**
		 * 获取用户缓存数据 
		 * @return 
		 * 
		 */		
		public function get userData():Object
		{
			return _userData;
		}
		public function set userData(value:Object):void
		{
			_userData = value;
		}
		
		/**
		 * 是否是模态 
		 * @return 
		 * 
		 */		
		public function get isModal():Boolean
		{
			return _isModal;
		}
		public function set isModal(value:Boolean):void
		{
			_isModal = value;
		}

		/**
		 * 接口名字 
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;	
		}
		
		/**
		 * 唯一id 
		 * @param value
		 * 
		 */		
		public function set id(value:uint):void
		{
			_id = value;
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		/**
		 * 是否发送到后端了 
		 * @return 
		 * 
		 */		
		public function get hasApplied():Boolean
		{
			return _hasApplied;
		}
		
		public function set hasApplied(applied:Boolean):void
		{
			_hasApplied = applied;
		}
		
		/**
		 * 发送到后端前 
		 * 
		 */		
		public function apply():void
		{
			
		}
		
		/**
		 * 发送 
		 * @param params    参数
		 * @param userData	用户需要cache的数据
		 * @param isModal	是否是模态
		 * 
		 */		
		public function send(params:Array, userData:Object=null, isModal:Boolean=true):IHttpService
		{
			this._isModal 	= isModal;
			this._userData 	= userData;
			this._params 	= params;
			httpManager.queue(this);
			
			return this;
		}
		
		/**
		 * 当添加进队列 
		 * 
		 */		
		public function onQueued():void
		{
			
		}
		
		/**
		 * 成功的调用方法 
		 * @param value
		 * 
		 */		
		public function success(value:Object):void
		{
			trace("it should be overrided!");
		}
		
		/**
		 * 失败的调用方法 
		 * @param value
		 * 
		 */
		public function fault(value:Object):void
		{
			trace("it should be overrided!");
		}
	}
}