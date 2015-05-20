package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

/**
* ...  
* @author niels
*/
	public class mainMenu extends Sprite
	{
		private var main:Main;
		
		[Embed(source="../lib/bg.png")]
		private var BackgroundImage:Class;
		private var bgImage:Bitmap;
		
		[Embed(source="../lib/buttons/back.png")]
		private var backImage:Class;
		private var bImage:Bitmap
		 
		[Embed(source="../lib/HowTo.jpg")]
		private var BackHowImage:Class;
		private var bhImage:Bitmap;
		
		[Embed(source="../lib/buttons/start.png")]
		private var startImage:Class;
		private var sImage:Bitmap;
		
		[Embed(source="../lib/buttons/start_licht.png")]
		private var startLightImage:Class;
		private var slImage:Bitmap;
		
		
		[Embed(source="../lib/buttons/how to play.png")]
		private var howToPlayImage:Class;
		private var hImage:Bitmap;
		
		[Embed(source="../lib/buttons/how to play_licht.png")]
		private var howToPlayLightImage:Class;
		private var hlImage:Bitmap;
		
			public function mainMenu():void
			{
				
				if (stage) init();
				else addEventListener(Event.ADDED_TO_STAGE, init);
				
			}
			
			private function init(e:Event = null):void
			{				
				bgImage = new BackgroundImage();
				addChild(bgImage);
				
				bhImage = new BackHowImage;
				
				bImage = new backImage;
				bImage.x = 500;
				bImage.y = 500;
				
				sImage = new startImage();
				sImage.x = 340;
				sImage.y = 250;
				
				slImage = new startLightImage();
				slImage.x = 340;
				slImage.y = 250;
				
			
				addChild(sImage);
				
				
				hImage = new howToPlayImage();
				hImage.x = 235;
				hImage.y = 150;
				
				hlImage = new howToPlayLightImage();
				hlImage.x = 235;
				hlImage.y = 150;
	
				addChild(hImage);
			
				
				
				stage.addEventListener(MouseEvent.CLICK, msDown);
				
			}
			
			public function msDown(e:MouseEvent):void
			{
				if(sImage.hitTestPoint(mouseX,mouseY))
				{
					removeEventListener(Event.ADDED_TO_STAGE, init);
					removeChild(sImage);
					removeChild(hImage);
					
					sImage = null;
					hImage = null;
					bImage = null;
					
					main = new Main();
					addChild(main);
					stage.removeEventListener(MouseEvent.CLICK, msDown);
				}
				else {
					if(hImage.hitTestPoint(mouseX,mouseY))
					{
						removeEventListener(Event.ADDED_TO_STAGE, init);
						removeChild(sImage);
						removeChild(hImage);
								
						addChild(bhImage);	
						addChild(bImage);
					}
					else {
						if(bImage.hitTestPoint(mouseX,mouseY))
						{
							removeChild(bhImage);
							removeChild(bImage);
							
							addChild(sImage);
							addChild(hImage);
						}
					}
				}
			}
	}
}