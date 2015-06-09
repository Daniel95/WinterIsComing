package
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class MoveForwardBase extends RotateBase
	{
		private var b:Number;
		
		public function MoveForwardBase()
		{
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		override public function loop(e:Event):void
		{
			targetPosition.x = Main.player.x - this.x;
			targetPosition.y = Main.player.y - this.y;
			
			b = this.rotation * Math.PI / 180;
			this.x += speed * Math.cos(b);
			this.y += speed * Math.sin(b);
			
			//the longer the unit lives, the faster it moves
			speed += 0.0005;
			
			super.loop(e);
		}
		
		override public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			super.destroy();
		}
	}

}