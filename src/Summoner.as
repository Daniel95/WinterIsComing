package 
{
	import flash.events.Event;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author David Zwitser
	 */
	public class Summoner extends FollowBase
	{
		public var speedX:int;
		public var speedY:int;
		private var turnToPlayAtStart:Boolean;
		
		public function Summoner()
		{
			character = new WalkerArt();
			this.addChild(character);
			
			this.scaleX = this.scaleY = 1;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void 
		{
			lives = Math.ceil(20);
			this.addEventListener(Event.ENTER_FRAME, loop);
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		override public function loop(e:Event):void
		{
			if (Main.player != null)
			{
				//speedx and speedy get a value depending on where they spawn
				if (this.x < 540) speedX = 2;
				else speedX = -2;
				if (this.y < 360) speedY = 2;
				else speedY = -2;
				
				//if not in the field, this objects moves
				if(this.x > 980 || this.x < 100 || this.y > 620 || this.y < 100)
				{
					this.x += speedX;
					this.y += speedY
				}
				
				if (turnToPlayAtStart == false && this.x > 980)
				{
					character.rotation = 180;
					turnToPlayAtStart = true;
				}
				
				targetPosition.x = Main.player.x - this.x;
				targetPosition.y = Main.player.y - this.y;
				super.loop(e);
			}
		}
		override public function destroy():void
		{
			super.destroy();
		}
		
	}

}