package  
{
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Wildling extends FollowBase
	{
		private var shootTimer:Timer;
		public var speedX:int;
		public var speedY:int;
		private var turnToPlayAtStart:Boolean;
		
		public function Wildling() 
		{
			character = new PlayerArt();
			this.addChild(character);
			
			this.scaleX = this.scaleY = 0.2;
			
			shootTimer = new Timer(2000+Math.random()*2600);
			shootTimer.addEventListener(TimerEvent.TIMER, shoot);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			shootTimer.start();
		}
		private function init(e:Event):void 	
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			lives = Math.ceil(Math.random() * 2);
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function shoot(e:TimerEvent):void
		{
			var se:ShootEvent = new ShootEvent("onShoot");
			se.shooter = this;
			dispatchEvent(se);
		}
		override public function loop(e:Event):void
		{
			if (Main.player != null)
			{
				//speedx and speedy get a value depending on where they spawn
				if (this.x < 540) speedX = 1;
				else speedX = -1;
				if (this.y < 360) speedY = 1;
				else speedY = -1;
				
				//if not in the field, this objects moves
				if(this.x > 1024 || this.x < 100 || this.y > 620 || this.y < 100)
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
		}
		override public function destroy():void
		{
			shootTimer.removeEventListener(TimerEvent.TIMER, shoot);
			shootTimer.stop();
			shootTimer = null;
			super.destroy();
		}
		
	}

}