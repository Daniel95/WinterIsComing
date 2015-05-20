package 
{
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class Obsidian extends Sprite
	{
		[Embed(source="../lib/arrow_pickup.png")]
		private var obsidianImage:Class;
		private var obImage:Bitmap;
		
		public function Obsidian() 
		{
			obImage = new obsidianImage();
			addChild(obImage);
		}
		
	}

}