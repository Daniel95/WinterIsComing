package
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author David Zwitser
	 */
	public class Skeleton extends MoveForwardBase
	{
		public var radius:int;
		
		public function Skeleton(score:int)
		{
			character = new SkeletionArt();
			this.addChild(character);
			
			size = this.scaleX = this.scaleY = 0.35;
			
			rotateSpeed = (rotateSpeed / 2) + score / 200;
			
			lives = 0.1 + score / 100;
			
			speed = 3.5 + score / 50;
			radius = width / 3;
			
			meleeDamage = (score / 25) + 1;
			
			this.scaleX = this.scaleY = size = 0.35;
		
		}
		
		override public function loop(e:Event):void
		{
			if (Main.player != null)
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
		}
		
		override public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			super.destroy();
		}
	
	}

}