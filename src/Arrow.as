package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Daniel Brand
	 */
	public class Arrow extends Sprite
	{
		private var moveX:Number = 0;
		private var moveY:Number = 0;
		public var speed:Number;
		private var calDist:Boolean = true;
		
		private var stuckPosX:Number;
		private var stuckPosY:Number;
		
		private var distanceX:Number;
		private var distanceY:Number;
		private var rotDifference:Number;
		
		public var radius:int = width / 2;
		
		private var arrow:ArrowArt;
		
		private var lifeTime:int = 400;
		
		public var damage:Number;
		
		public var didDamage:Boolean = false;
		public var toRemove:Boolean;
		public var dieSoon:Boolean;
		public var isArrow:Boolean = true;
		
		public function Arrow(r:Number, tPos:Point, s:Number, dmg:Number)
		{
			arrow = new ArrowArt;
			//addChildAt(arrow,numChildren-3);
			addChild(arrow);
			
			damage = dmg;
			
			speed = s;
			this.rotation = r;
			
			var radian:Number = r * Math.PI / 180;
			moveX = Math.cos(radian);
			moveY = Math.sin(radian);
			
			this.x = tPos.x + (45 * moveX);
			this.y = tPos.y + (45 * moveY);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void
		{
			if (calDist)
			{
				this.x += moveX * speed;
				this.y += moveY * speed;
			}
			if (dieSoon)
			{
				lifeTime--;
				if (lifeTime < 0)
					toRemove = true;
			}
		}
		
		public function arrowCol():void
		{
			if (!didDamage)
			{
				this.rotation = Math.random() * 360;
			}
		}
		
		public function collWall():void
		{
			speed = 0;
			didDamage = true;
			dieSoon = true;
		}
		
		public function stuckInTarget(target:Object, targetRot:int):void
		{
			if (target != null)
			{
				if (calDist)
				{
					speed = 0; //speed is 0 for less dmg
					distanceX = target.x - this.x;
					distanceY = target.y - this.y;
					rotDifference = targetRot - this.rotation;
					calDist = false;
				}
				var radianT:Number = targetRot * Math.PI / 180;
				
				stuckPosX = Math.cos(radianT);
				stuckPosY = Math.sin(radianT);
				
				this.rotation = targetRot + rotDifference;
				
				this.x = target.x - distanceX;
				this.y = target.y - distanceY;
			}
		}
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
		}
	}
}