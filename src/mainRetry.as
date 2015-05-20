package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

/**
* ...
* @author niels
*/
	public class mainRetry extends Sprite
	{
		
		
		private var menu:mainMenu;
		
		[Embed(source="../lib/theWalker.jpg")]
		private var BackgroundImage:Class;
		private var bgImage:Bitmap;
		//public var gamePlay = true;
	
			public function mainRetry():void
			{
				addEventListener(Event.ADDED_TO_STAGE, init);				
			}
			
			private function init(e:Event = null):void
			{				
				bgImage = new BackgroundImage();
				addChild(bgImage); 
			}
			
			public function keyDawn(e:KeyboardEvent):void
			{
				if (e.keyCode == 32) {
					
					removeEventListener(Event.ADDED_TO_STAGE, init);
					removeChild(bgImage);
					bgImage = null;
					
					menu = new mainMenu();
					addChild(menu);			
				}
			}
			
	}
}