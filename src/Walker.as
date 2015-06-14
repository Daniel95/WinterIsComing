package
{
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Daniël Brands
	 */
	public class Walker extends MoveForwardBase
	{
		public var moveSpeed:Number = (Math.random() * 2) + 1.2;
		public var radius:int;
		
		public function Walker(score:int)
		{
			character = new WalkerArt();
			this.addChild(character);
			
			var random:Number = Math.random();
			
			this.scaleX = this.scaleY = size = (random * 0.05) + 0.4;
			
			rotateSpeed += score / 250;
			lives = Math.ceil(random * 3) + score / 40;
			speed = (random * 2) + 1.25 + (score / 45);
			radius = width / 3;
			meleeDamage = (score / 100) + 1;
			
			this.addEventListener(Event.ENTER_FRAME, loop);
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
			super.destroy(); //zo voer je ook alle anderen taken in een functie uit(die in de functie zitten die ik override)
		}
	}
}