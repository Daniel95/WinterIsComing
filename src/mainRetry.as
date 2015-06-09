package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author niels
	 */
	public class mainRetry extends Sprite
	{
		private var menu:mainMenu;
		
		private var backButton:BackButtonArt;
		
		private var bgImage:DieScreenArt;
		
		//public var gamePlay = true;
		
		public function mainRetry():void
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			stage.addEventListener(MouseEvent.CLICK, backMouse);
			
			menu = new mainMenu();
			
			bgImage = new DieScreenArt();
			bgImage.x = 640;
			bgImage.y = 360
			addChild(bgImage);
			
			backButton = new BackButtonArt();
			backButton.x = 1100;
			backButton.y = 600;
			addChild(backButton);
		
		}
		
		public function backMouse(e:MouseEvent):void
		{
			if (backButton.parent && backButton.hitTestPoint(mouseX, mouseY))
			{
				removeChild(bgImage);
				removeChild(backButton);
				
				addChild(menu);
			}
		}
	
	}
}