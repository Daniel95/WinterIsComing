package
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class MoveInScreenBase extends RotateBase
	{
		public var speedX:int;
		public var speedY:int;
		private var turnToPlayAtStart:Boolean;
		
		public function MoveInScreenBase()
		{
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		override public function loop(e:Event):void
		{
			//speedx and speedy get a value depending on where they spawn
			if (this.x < 540)
				speedX = 1;
			else
				speedX = -1;
			if (this.y < 360)
				speedY = 1;
			else
				speedY = -1;
			
			//if not in the field, this objects moves
			if (this.x > 1024 || this.x < 100 || this.y > 620 || this.y < 100)
			{
				this.x += speedX;
				this.y += speedY;
				if (turnToPlayAtStart == false && this.x > 400)
				{
					this.rotation = 180;
					turnToPlayAtStart = true;
				}
			}
			
			targetPosition.x = Main.player.x - this.x;
			targetPosition.y = Main.player.y - this.y;
			
			super.loop(e);
		}
		
		override public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			super.destroy();
		}
	}

}