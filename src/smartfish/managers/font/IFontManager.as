package smartfish.managers.font
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.text.Font;
	import flash.text.TextField;

	public interface IFontManager extends IEventDispatcher
	{
//		function addFont(url:String,fontCls:String):void;
		function translateTextField(tf:TextField,fontName:String):void;
		function translateTextFieldsContainer(container:DisplayObjectContainer, fontName:String,replaceFont:String) : void
		function searchFont(fontName:String):Font;
		function registerFont(fontCls:Class):void;
	}
}