package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Wall extends Sprite
	{
		public var radius:int = 40;
		[Embed(source="../lib/Tree_Level1.png")]
		private var wall:Class;
		private var treeImage:Bitmap;
		
		public function Wall() 
		{
			treeImage = new wall();
			this.addChild(treeImage);
			
			this.x = 950;
			this.y = 300;
		}
		
	}

}