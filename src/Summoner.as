package
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author David Zwitser
	 */
	public class Summoner extends MoveInScreenBase
	{
		//private var turnToPlayAtStart:Boolean;
		public var radius:int;
		public var sumLives:int = 5;
		
		public function Summoner(score:int)
		{
			character = new WhiteWalkerArt();
			this.addChild(character);
			
			sumLives += score / 3;
			
			this.scaleX = this.scaleY = 0.5;
			
			lives = sumLives;
			
			radius = width / 3;
			
			meleeDamage = 3;
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		override public function loop(e:Event):void
		{
			super.loop(e);
			if (dead)
			{
				lives = 1;
					
				if (waitForAnim > 0){
					character.alpha -= 0.1;
					character.scaleX = character.scaleY -= 0.02;
					waitForAnim--;
				}else toRemove = true;	
			}
		}
		
		override public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			super.destroy();
		}
	
	}

}