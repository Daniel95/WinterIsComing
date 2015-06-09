package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author nnnnelsonnnn
	 */
	public class TheGame extends Sprite
	{
		public var menu:mainMenu;
		
		public function TheGame():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			menu = new mainMenu();
			addChild(menu);
		}
	}

}