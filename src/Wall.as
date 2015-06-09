package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Wall extends Sprite
	{
		public var radius:int;
		private var wall:Class;
		private var treeImage:MovieClip;
		private var treeImage2:MovieClip;
		public static var wallRandomArt:Boolean;
		
		public function Wall()
		{
			treeImage = new TreeArt();
			treeImage2 = new SnowTreeArt();
			
			radius = width / 2;
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		public function init(e:Event):void
		{
			if (wallRandomArt == false)
				addChild(treeImage);
			if (wallRandomArt == true)
				addChild(treeImage2);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
	
	}

}