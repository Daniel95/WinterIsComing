package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Niels
	 */
	public class HowToPlay extends Sprite 
	{
		static public const GO_BACK_TO_MENU:String = "goBackToMenu";
		private var menu:mainMenu;
		
		[Embed(source="../lib/buttons/back.png")]
		private var backImage:Class;
		private var bImage:Bitmap
		 
		[Embed(source="../lib/HowTo.jpg")]
		private var BackgroundImage:Class;
		private var bgImage:Bitmap;

		public function HowToPlay():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function checkStuff(e:Event):void
		{
			
		}
		
		private function init(e:Event = null):void
		{				
				bgImage = new BackgroundImage;
				
				bImage = new backImage;
				bImage.x = 500;
				bImage.y = 500;
				
				stage.addEventListener(MouseEvent.CLICK, mouseDown);
				
				//var masker:Masker = new Masker();
				//addChild(masker);
				//this.mask = masker;       
		}
			
		public function mouseDown(e:MouseEvent):void
		{
			if(bImage.hitTestPoint(mouseX,mouseY))
			{
				dispatchEvent(new Event(GO_BACK_TO_MENU));
				/*
				removeEventListener(Event.ADDED_TO_STAGE, init);
				removeChild(bgImage);
				removeChild(bImage);
				//bgImage = null;
				//bImage = null;					
				
				menu = new mainMenu();
				addChild(menu);
				stage.removeEventListener(MouseEvent.CLICK, mouseDown);
				stage.addEventListener(Event.ENTER_FRAME, checkStuff);
				*/
			}
		}
	}

}