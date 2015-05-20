package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class FollowBase extends MovieClip
	{
		protected var character:MovieClip;
		
		public var characterAngle:Number = 1;
		
		public var angle:Number = 0;
		
		public var targetPosition:Point;
		
		public var lives:int;
		
		public var speed:Number;
		
		public var rotateSpeed:Number = (Math.random() * 0.5) + 0.85;
		
		public var aimMode:Boolean = true;
		
		public var rotValue:int;
		
		public function FollowBase() 
		{
			targetPosition = new Point();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void 	
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function loop(e:Event):void 
		{	
			var rotationCheckLength:int;
			//characterAngle = character.rotation;//hiermee kun je in de main ook de characterAngle lezen 
			if (aimMode)	
			{
				rotationCheckLength = 2;
				var dx:Number = targetPosition.x;
				var dy:Number = targetPosition.y;
				
				var radian:Number = Math.atan2(dy, dx);
				angle = radian * 180 / Math.PI;//omzetten van radian naar angle
			}
			else {
				rotationCheckLength = 1;
				/*
				if (angle < 0)
				{
					angle = 0;
				}
				if (angle < 0)
				{
					if(angle < -90) angle += 180;//90+
					else angle -= 180;//90- 
				}
				if (this.rotation < 0)
				{
					if(this.rotation < -90)this.rotation = -360;
					else this.rotation = 0;	
				}
				if (this.rotation < 0)
				{
					this.rotation -= 180;
				}
				*/
				if (angle < 0)
				{
					if(angle < -90) angle = 0;//-90+
					else angle = 180;//-90- 
				}
				if (this.rotation < 0)
				{
					if(this.rotation < -90) this.rotation = 0;//90+
					else this.rotation = 180;//90- 
				}
				//trace("this this.rotation = " + this.rotation + " this angle = " + angle);
			}
			if (this.rotation < angle)
			{
				if ((this.rotation + 90 * rotationCheckLength) > angle) this.rotation += rotateSpeed;
				else this.rotation -= rotateSpeed;
			}
			if (this.rotation > angle)
			{
				if ((this.rotation - 90 * rotationCheckLength) < angle) this.rotation -= rotateSpeed;
				else this.rotation += rotateSpeed;
			}
		}
		
		public function wallCol(otherX:int,otherY:int,otherW:int,otherH:int):void 
		{
			otherW / 2;
			otherH / 2;
			
			if (otherX - 10 < this.x)
			{
				for (var w:int = 1; w <= 20; w++)
				{
					this.x  -= 2;
				}
				
				
			}
			
			if (this.hitTestPoint(otherX + width / 2, otherY , true))
			{
				this.x -= 7;
			}
			else if (otherX - otherW + 20 > this.x)
			{
				this.x = otherX - otherW;
			}
			if (otherY + otherH - 150 < this.y)
			{
				this.y = otherY + otherH * 0.7;
			}
			else if (otherY - otherH + 150 > this.y)
			{
				this.y = otherY - otherH * 0.7;
			}
		}
		
		public function enemyCol(wallX:int,wallY:int):void 
		{
			if (wallX < this.x) this.x += 4;
			else this.x -= 4;
			if (wallY < this.y) this.y += 4;
			else this.y -= 4;
		}
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
		}
	}
}