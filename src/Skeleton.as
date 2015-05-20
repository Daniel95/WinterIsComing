package 
{
	import flash.events.Event;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author David Zwitser
	 */
	public class Skeleton extends FollowBase 
	{
		private var moveSpeed:Number = 3.5;
		public function Skeleton() 
		{
			character = new WalkerArt();
			this.addChild(character);
			
			this.scaleX = this.scaleY = 0.20;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 	
		{
			//character.rotation = angle;
			lives = Math.ceil(1);
			speed = 5;
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
			super.destroy();
		}
		
	}

}