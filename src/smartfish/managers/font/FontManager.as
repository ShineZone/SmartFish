package smartfish.managers.font
{	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class FontManager extends EventDispatcher implements IFontManager
	{
		private var fontDic:Dictionary;
		private var tfDic:Dictionary;		
		
		private static var instance:IFontManager;
		
		public function FontManager()
		{
			tfDic = new Dictionary(false);
			fontDic = new Dictionary(false);
		}
		
		public static function getInstance():IFontManager
		{
			return instance ||= new FontManager();
		}
		
		/**
		 * 添加字体库 
		 * @param url
		 * @param fontCls
		 */		
//		public function addFont(url:String,fontCls:String):void
//		{
//			(Singleton.getInstance("AssetsManager") as IAssetsManager).load(url,onFontLoaded,[fontCls]);
//		}
		
		/**
		 * 为文本框更改嵌入字体 
		 * @param tf
		 * @param fontName
		 * 
		 */		
		public function translateTextField(tf:TextField,fontName:String):void
		{
			if (!tf || !fontName)
			{
				throw new Error("【FontManager】参数有误，请检查！");
				return;
			}
			if (tf.type != TextFieldType.DYNAMIC)
			{
				return;
			}
			if (fontDic[fontName] == null)
			{
				if (tfDic[fontName] == null)
				{
					tfDic[fontName] = new Dictionary();
				}
				if (tfDic[fontName][tf] == null)
				{
					tfDic[fontName][tf] = {tf:tf,fontName:fontName};
				}
			}
			else
			{
				replaceTf(tf,fontDic[fontName]);
//				updateTf(tf,fontDic[fontName]);
				if (tfDic && tfDic[fontName] && tfDic[fontName][tf] != null)
				{
					delete tfDic[fontName][tf];
				}
				tf = null;
			}
		}
		
		public function translateTextFieldsContainer(container:DisplayObjectContainer,fontName:String,replaceFont:String) : void
		{
			if (container == null)
			{
				return;
			}
			
			for (var i:int = 0; i < container.numChildren; i++)
			{
				var o:DisplayObject = container.getChildAt(i) as DisplayObject;
				if (o is DisplayObjectContainer)
				{
					translateTextFieldsContainer((o as DisplayObjectContainer), fontName,replaceFont);
				}
				else if (o is TextField && (o as TextField).getTextFormat().font == replaceFont)
				{
					translateTextField((o as TextField), fontName);
				}
			}
		}
				
		/**
		 * 更新文本框 
		 * @param tf
		 * @param font
		 * 
		 */		
		private function updateTf(tf:TextField,font:Font):void
		{			
			var fmt:TextFormat = tf.defaultTextFormat;
			fmt.kerning = true;
			tf.embedFonts = true;
			fmt.font = font.fontName;
			tf.defaultTextFormat = fmt;
			tf.setTextFormat(fmt);
		}
		
		private function replaceTf(tf:TextField,font:Font):void
		{
			var newtf:TextField = new TextField();
			var fmt:TextFormat = tf.getTextFormat();
			var rot:Number = tf.rotation;
			newtf.visible = tf.visible;
			
			tf.rotation = 0;
			
			fmt.kerning = true;
			fmt.font = font.fontName;
			
			//获取所有设置
			newtf.alpha = tf.alpha;
			newtf.antiAliasType = AntiAliasType.ADVANCED;
			newtf.defaultTextFormat = fmt;
			newtf.autoSize = tf.autoSize;
			newtf.embedFonts = true;
			newtf.gridFitType = tf.gridFitType;
			newtf.height = tf.height;
			newtf.mouseEnabled = tf.mouseEnabled;
			newtf.mouseWheelEnabled = false;
			newtf.multiline = tf.multiline;
			newtf.name = tf.name;
			newtf.selectable = tf.selectable;
			newtf.sharpness = tf.sharpness;
			newtf.textColor = tf.textColor;
			newtf.thickness = tf.thickness;
			newtf.width = tf.width;
			newtf.wordWrap = tf.wordWrap;
			newtf.x = tf.x;
			newtf.y = tf.y;
			newtf.text = tf.text;
			newtf.htmlText = tf.htmlText;
			newtf.cacheAsBitmap = tf.cacheAsBitmap;
			newtf.filters = tf.filters;
			
			newtf.setTextFormat(fmt);
			newtf.defaultTextFormat = fmt;
			
			newtf.rotation = rot;
			tf.rotation = rot;
			
			if(tf.parent)
			{
				changeTextFieldReference(tf,newtf);
			}		
			else
			{
				tf = newtf;
			}
		}
			
		private function changeTextFieldReference(tf:TextField,newtf:TextField):void
		{
			var pos:int = tf.parent.getChildIndex(tf);
			var p:DisplayObjectContainer = tf.parent;
//			tf.visible = false;
			p.removeChild(tf);
			p.addChildAt(newtf, pos);
			try{
				p[newtf.name] = newtf;
			}catch(e:Error){
				trace("replace font error!")
			}
		}
		
		/**
		 * 字体加载完成 
		 * @param o
		 * 
		 */		
//		private function onFontLoaded(o:Object,fontCls:String):void
//		{
//			var cls:Class;
//			var fontList:Array = fontCls.split("|");
//			for (var i:int = 0, len:int = fontList.length; i < len; i++)
//			{
//				var fontName:String = fontList[i];
//				if(o.content is DisplayObject && o.content.loaderInfo.applicationDomain.hasDefinition(fontName)){
//					cls = o.content.loaderInfo.applicationDomain.getDefinition(fontName) as Class;		
//					registerFont(cls);				
//				}		
//			}
//			this.dispatchEvent(new Event("FontLoadCompelete"));
//		}
		
		/**
		 * 注册字体 
		 * @param fontCls
		 * 
		 */		
		public function registerFont(fontCls:Class):void
		{
			try{
				Font.registerFont(fontCls);
			}catch(e:Error){
				trace("注册字体出错：" + e.toString())
				return;
			}
			var arr:Array = getQualifiedClassName(fontCls).split("::");
			var fontcls:String = arr[arr.length-1];
			searchFont(fontcls);	
			for each (var info:Object in tfDic[fontcls]) 
			{
				translateTextField(info.tf,info.fontName);
			}
		}
		
		/**
		 * 在系统中搜索字体
		 * @param fontName
		 * @return 
		 * 
		 */		
		public function searchFont(fontCls:String):Font
		{
			var fonts:Array = Font.enumerateFonts();
			var exists:Boolean = false;
			var clFont:Class;
			
			for each (var o:Font in fonts)
			{
				var arr:Array = getQualifiedClassName(o).split("::");
				if (arr[arr.length-1] == fontCls)
				{
					fontDic[fontCls] = o;
					return o;
				}
			}
			
			return null;
		}
	}
}