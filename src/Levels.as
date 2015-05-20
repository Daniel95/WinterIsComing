package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class Levels extends Sprite
	{
		
		[Embed(source="../lib/Backgrund_Level1.jpg")]
		private var levelImage:Class;
		private var level:Bitmap;
		
		public function Levels() 
		{
			level = new levelImage();
			addChild(level);
		}
		
	}

}