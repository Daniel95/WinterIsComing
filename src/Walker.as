package  
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Walker extends FollowBase
	{
		public var moveSpeed:Number = (Math.random() * 2) + 1.2;
		public function Walker()
		{
   			character = new WalkerArt();
			this.addChild(character);
			
			this.scaleX = this.scaleY = (Math.random() / 7) + 0.25;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}		
		private function init(e:Event):void 	
		{
			lives = Math.ceil(Math.random() * 3);
			speed = (Math.random() * 2) + 1.2;
			this.addEventListener(Event.ENTER_FRAME, loop);
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override public function loop(e:Event):void 
		{
			if (Main.player != null)
			{	
				
				//Giving the rotation to main script
				targetPosition.x = Main.player.x - this.x;
				targetPosition.y = Main.player.y - this.y;
				
				var b:Number = this.rotation * Math.PI/180;
				this.x += speed * Math.cos(b);
				this.y += speed * Math.sin(b);
				
				speed += 0.000001;
				
				super.loop(e);
			}
		}
		
		override public function destroy():void
		{
			super.destroy();//zo voer je ook alle anderen taken in een functie uit(die in de functie zitten die ik override)
		}
	}
}