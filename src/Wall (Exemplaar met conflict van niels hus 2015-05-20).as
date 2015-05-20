package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Wall extends Sprite
	{
		[Embed(source="../lib/Tree_Level1.png")]
		private var wall:Class;
		private var treeImage:Bitmap;
		
		public function Tree() 
		{
			treeImage = new wall();
			this.addChild(treeImage);
			
			this.x = 950;
			this.y = 300;
		}
		
	}

}