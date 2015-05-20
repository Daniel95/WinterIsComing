package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Tree extends Sprite
	{
		[Embed(source="../lib/Tree_level1.png")]
		private var tree:Class;
		private var treeImage:Bitmap;
		
		public function Tree() 
		{
			treeImage = new tree();
			this.addChild(treeImage);
			
			this.x = 950;
			this.y = 300;
		}
		
	}

}