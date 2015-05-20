package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Daniel Brand
	 */
	public class Arrow extends Sprite 
	{
		private var moveX:Number = 0;
		private var moveY:Number = 0;
		public var speed:Number;
		public var otherArrowCol:Boolean;
		private var calDist:Boolean = true;
		
		private	var distanceX:Number;
		private	var distanceY:Number;	
		private	var rotDifference:Number;
		
		private var arrow:ArrowArt;
		
		public var didDamage:Boolean = false;
		
		public function Arrow(r:Number, tPos:Point, s:Number)
		{
			arrow = new ArrowArt;
			addChild(arrow);
			
			speed = s;
			this.rotation = r;
			
			var radian:Number = r * Math.PI / 180;
			moveX = Math.cos(radian);
			moveY = Math.sin(radian);

			this.x = tPos.x + (30 * moveX);
			this.y = tPos.y + (30 * moveY);
			
			super();
		}
		public function update():void
		{
			//trace("arrow rot" + this.rotation);
			this.x += moveX * speed;
			this.y += moveY * speed;
			
			if (calDist == false)
			{
				//trace("this.x  = " + this.x);
			}
		}
		
		public function arrowCol():void
		{
			if (didDamage == false)
			{
				this.rotation = Math.random() * 360;
			}
							/*
			if (arrows[y].x < arrows[h].x) arrows[h].x += 2;
			else arrows[h].x -= 2;
			if (arrows[y].y < arrows[h].y)arrows[h].y += 2;
			else arrows[h].y -= 2;
			*/
		}
		
		public function stuckInTarget(target:Object,targetRot:int):void
		{
			//var radian:Number = targetRot * Math.PI / 180;//van graden naar radians
			//var arrowPosX:Number = Math.cos(radian);
			//var arrowPosY:Number = Math.sin(radian);
			
			if (target != null)
			{
				if (calDist)
				{
					speed = 0;
					distanceX = target.x - this.x;
					distanceY = target.y - this.y;
					rotDifference = targetRot - this.rotation;
					calDist = false;
				}
				this.x = target.x - distanceX;
				this.y = target.y - distanceY;
				this.rotation = targetRot + rotDifference;
				
				//bowPosY = Math.sin(radian);
				//arrows.x = arrow.x = 25 * bowPosX;
				//bow.y = arrow.y = 25 * bowPosY;
			}
		}
	}

}