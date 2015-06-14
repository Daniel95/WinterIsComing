package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author niels
	 */
	public class mainMenu extends Sprite
	{
		//music
		private var menuTheme:Sound;
		//private var buttonClick:Sound;
		private var soundChannel:SoundChannel
		
		private var startScerm:WinterIsComingMenuArt;
		
		private var main:Main;
		
		[Embed(source="../lib/bg.png")]
		private var BackgroundImage:Class;
		private var bgImage:Bitmap;
		
		private var startButton:StartButtonArt;
		private var backButton:BackButtonArt;
		private var cursor:Cursor;
		
		private var creditScreen:CreditsScreenArt;
		private var creditButton:CreditsButtonArt;
		
		private var htpButton:HowToPlayArt;
		private var htpScreen:howToPlayScreenArt;
		
		private var snowMenuButton:SnowArtButton;
		private var forrestMenuButton:ForrestArtButton;
		
		private var backgroundSnow:MovieClip;
		private var backgroundForrest:MovieClip;
		
		public static var forrestStyle:Boolean;
		private var toRemoveScreen:int;
		
		private var easterEggCounter:int;
		private var eastereggArt:MovieClip;
		
		public function mainMenu():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			menuTheme = new Sound();
			menuTheme.load(new URLRequest("../lib/sound/menutheme.mp3"));
			
			backgroundForrest = new blurForestLevelArt();
			backgroundForrest.width = 0;
			addChild(backgroundForrest);
			backgroundSnow = new blurIceLevelArt();
			addChild(backgroundSnow);
			
			forrestMenuButton = new ForrestArtButton();
			forrestMenuButton.x = 650, forrestMenuButton.y = 550;
			addChild(forrestMenuButton);
			
			snowMenuButton = new SnowArtButton();
			snowMenuButton.x = 650, snowMenuButton.y = 550;
			snowMenuButton.width = 0;
			addChild(snowMenuButton);
			
			eastereggArt = new Easteregg();
			eastereggArt.alpha = 0;
			eastereggArt.x = 250;
			addChild(eastereggArt);
			
			creditScreen = new CreditsScreenArt();
			
			backButton = new BackButtonArt();
			backButton.x = 1100;
			backButton.y = 100;
			
			startButton = new StartButtonArt();
			startButton.x = 340;
			startButton.y = 200;
			addChild(startButton);
			
			htpButton = new HowToPlayArt();
			htpButton.x = 440;
			htpButton.y = 320;
			addChild(htpButton);
			
			htpScreen = new howToPlayScreenArt();
			
			creditButton = new CreditsButtonArt();
			creditButton.x = 540;
			creditButton.y = 450;
			addChild(creditButton);
			
			startScerm = new WinterIsComingMenuArt();
			startScerm.alpha = 1.5;
			startScerm.x = 640;
			startScerm.y = 360;
			addChild(startScerm);
			
			//addChildAt(cursor, numChildren - 1);
			cursor = new Cursor();
			addChild(cursor);
			
			stage.addEventListener(MouseEvent.CLICK, start);
		
		}
		
		private function loop(e:Event):void
		{
			if (startScerm.alpha <= 0)
			{
				stage.removeEventListener(Event.ENTER_FRAME, loop);
				stage.addEventListener(MouseEvent.CLICK, msDown);
				removeChild(startScerm);
				startScerm = null;
			}
			else startScerm.alpha -= 0.02;
		}
		
		//checks if clicked on start screen
		public function start(e:MouseEvent):void
		{
			if (startScerm.hitTestPoint(mouseX, mouseY))
			{
				stage.addEventListener(Event.ENTER_FRAME, loop);
				stage.removeEventListener(MouseEvent.CLICK, start);
				soundChannel = menuTheme.play(0, 0.5);
			}
		}
		
		public function msDown(e:MouseEvent):void
		{
			//checks for art style button
			if (forrestMenuButton.hitTestPoint(mouseX, mouseY) || snowMenuButton.hitTestPoint(mouseX, mouseY))
			{
				//trace(snowStyleTrue);
				if (easterEggCounter > 15) eastereggArt.alpha = 1;
				if (!forrestStyle)
				{
					forrestMenuButton.width = 0;
					snowMenuButton.width = 200;
					
					backgroundForrest.width = 1280;
					backgroundSnow.width = 0;
					
					easterEggCounter++;
					
					forrestStyle = true;
				}
				else if (forrestStyle)
				{
					snowMenuButton.width = 0;
					forrestMenuButton.width = 200;
					
					backgroundSnow.width = 1280;
					backgroundForrest.width = 0;
					
					easterEggCounter++;
					
					forrestStyle = false;
				}
			}
			
			//Checks if start button is clicked
			if (startButton.parent && htpButton.parent && creditButton.parent && startButton.hitTestPoint(mouseX, mouseY))
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
				removeChild(htpButton);
				removeChild(creditButton);
				removeChild(forrestMenuButton);
				removeChild(snowMenuButton);
				removeChild(backgroundForrest);
				removeChild(backgroundSnow);
				removeChild(eastereggArt);
				
				stage.removeEventListener(MouseEvent.CLICK, msDown);
				
				soundChannel.stop();
				
				main = new Main();
				addChild(main);
			}
			
			//checks if how to play button is clicked
			if (startButton.parent && htpButton.parent && creditButton.parent && htpButton.hitTestPoint(mouseX, mouseY))
			{
				removeChild(startButton);
				removeChild(htpButton);
				removeChild(creditButton);
				removeChild(forrestMenuButton);
				removeChild(snowMenuButton);
				removeChild(cursor);
				
				toRemoveScreen = 1;
				
				addChild(htpScreen);
				addChild(backButton);
				addChild(cursor);
				
			}
			
			//checks if credids button is clicked 
			if (startButton.parent && htpButton.parent && creditButton.parent && creditButton.hitTestPoint(mouseX, mouseY))
			{
				removeChild(startButton);
				removeChild(htpButton);
				removeChild(creditButton);
				removeChild(forrestMenuButton);
				removeChild(snowMenuButton);
				removeChild(cursor);
				
				toRemoveScreen = 2;
				
				addChild(cursor);
				addChild(creditScreen);
				addChild(backButton);
			}
			
			//checks if back button is clicked
			if (backButton.parent && backButton.hitTestPoint(mouseX, mouseY))
			{
				removeChild(backButton);
				removeChild(cursor);
				if (toRemoveScreen == 1) removeChild(htpScreen);
				else removeChild(creditScreen);
				
				addChild(startButton);
				addChild(htpButton);
				addChild(creditButton);
				addChild(forrestMenuButton);
				addChild(snowMenuButton);
				addChild(cursor);
			}
		
		}
	
	}
}