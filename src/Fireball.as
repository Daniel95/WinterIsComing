package
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class Fireball extends RotateBase
	{
		private var moveX:Number = 0;
		private var moveY:Number = 0;
		
		public var radius:int = width / 2;
		
		private var fireBall:FireBallArt;
		
		private var lifeTime:int = 400;
		
		public var didDamage:Boolean;
		
		public var isArrow:Boolean;
		
		public var damage:Number;
		
		public function Fireball(r:Number, tPos:Point, s:Number, dmg:Number)
		{
			fireBall = new FireBallArt;
			//addChildAt(arrow,numChildren-3);
			addChild(fireBall);
			
			damage = dmg;
			
			speed = 3;
			this.rotation = r;
			
			fireBall.scaleX = fireBall.scaleY = 3;
			
			var radian:Number = r * Math.PI / 180;
			moveX = Math.cos(radian);
			moveY = Math.sin(radian);
			
			this.x = tPos.x + (45 * moveX);
			this.y = tPos.y + (45 * moveY);
			
			rotateSpeed = 0.7;
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		override public function loop(e:Event):void
		{
			if (Main.player != null)
			{
				//Giving the rotation to main script
				targetPosition.x = Main.player.x - this.x;
				targetPosition.y = Main.player.y - this.y;
				
				var b:Number = this.rotation * Math.PI / 180;
				this.x += speed * Math.cos(b);
				this.y += speed * Math.sin(b);
				
				//the longer the unit lives, the faster it moves
				speed += 0.035;
				
				lifeTime--;
				if (lifeTime < 0 || didDamage == true)
					toRemove = true;
				
				super.loop(e);
			}
		}
		
		public function collWall():void
		{
			toRemove = true;
		}
		
		public function arrowCol():void
		{
			toRemove = true;
		}
		
		override public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			super.destroy();
		}
	}
}