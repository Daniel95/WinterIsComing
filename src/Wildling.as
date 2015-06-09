package  
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Wildling extends MoveInScreenBase
	{	
		public var radius:int;
		
		private var randomAttack:Number;
		
		private var shootCD:int;
		
		private var shootTimer:Timer;
		
		public function Wildling(score:int) 
		{	
			character = new SkeletionBoogArt();
			this.addChild(character);
			
			var random:Number = Math.random();
			
			var randomAttack:Number = random;
			
			rotateSpeed += score / 200;
			
			if (randomAttack > 0.25) {
				lives = Math.ceil(random * 2) + score / 40;
				shootCD = 2200 - score;
				this.scaleX = this.scaleY = size = 0.35;
			}
			else {
				lives = Math.ceil(random * 4) + score / 50;
				isMage = true;
				shootCD = 4000 - score;
				size = 0.3;
				this.scaleX = this.scaleY = size = 0.30;
			}
			
			radius = width / 3;
			
			meleeDamage = (score / 25) + 1;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void 	
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			shootTimer = new Timer(shootCD+Math.random()*2600);
			shootTimer.addEventListener(TimerEvent.TIMER, shoot);
			shootTimer.start();
			
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
			super.loop(e);
			if (dead) {
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
			shootTimer.removeEventListener(TimerEvent.TIMER, shoot);
			shootTimer.stop();
			shootTimer = null;
			this.removeEventListener(Event.ENTER_FRAME, loop);
			super.destroy();
		}
	}
}