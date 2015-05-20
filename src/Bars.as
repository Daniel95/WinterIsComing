package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Bars extends Sprite
	{
		private var healthBar:HealthBarArt;
		private var accuracyBar:HealthBarArt;
		
		public function Bars() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			healthBar = new HealthBarArt();
			this.addChild(healthBar);
			
			//accuracyBar = new HealthBarArt();
			//this.addChild(accuracyBar);
			
			//accuracyBar.x = 600;
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void 
		{
			if (Main.player != null)
			{
				healthBar.scaleX = Main.player.barLives * 0.08;
				
				//accuracyBar.scaleX = Main.player.accuracy * 0.02;
			}
		}
		
		
	}

}