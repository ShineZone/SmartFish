/**
 * Copyright (c) 2013 rayyee. All rights reserved. 
 * 
 * @author rayyee
 * Created 下午4:32:10
 **/
package smartfish.robotlegs.extensions.facebook.impl
{
	public class FacebookQuery
	{
		/**
		 * 默认需要查询的好友字段 
		 */		
		public static const NORMAL : String = "name, uid,first_name, sex, is_app_user, online_presence";
		/**
		 * 只查找active和idle状态的好友 
		 */		
		public static const ONLINESTATE_LIVE : String = "('active', 'idle')";
		
		private static const ONLINESTATE_PREFIX : String = "online_presence IN ";
		private static const FQL : String = "https://api.facebook.com/method/fql.query?query= ";
		
		/**
		 * Constructor
		 **/
		public function FacebookQuery( )
		{
			
		}
		
		internal static function getFriendListQuery( selectCondition : String = NORMAL, whereCondition : String = "" ):String
		{
			return FQL + 
					"SELECT " + selectCondition + 
					" FROM user WHERE " + (whereCondition ? ONLINESTATE_PREFIX + whereCondition + " AND " : "") + " uid IN (SELECT uid2 FROM friend WHERE uid1 = me())" + 
					"&format=" + "json" + "&access_token=" + FacebookConst.Access_Token;
		}

	}
}