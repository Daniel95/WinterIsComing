package
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author David Zwitser
	 */
	public class Maths
	{
		public function Maths()
		{
			trace("there is something wrong in maths.as");
		}
		
		//circular collision
		public static function hitTest(obj1:Object, obj2:Object):Boolean
		{
			var combinedRadii:int = obj1.radius + obj2.radius;
			
			if (combinedRadii >= distanceBetween(obj1, obj2))
			{
				return true;
			}
			return false;
		}
		
		//check distance beteen two objects
		public static function distanceBetween(object1:Object, object2:Object):Number
		{
			var a:int = object1.x - object2.x;
			var b:int = object1.y - object2.y;
			
			return Math.sqrt((a * a) + (b * b));
		}
		
		//calculates an angle to a position
		public static function fromAngleToPos(angle:Number):Point
		{
			return new Point(Math.cos(angle / 180 * Math.PI), Math.sin(angle / 180 * Math.PI))
		}
		
		//calculates two positions to an angle
		public static function fromPosToAngle(obj1:Object, obj2:Object):Number
		{
			
			return Math.atan2(obj1.x - obj2.x, obj1.y - obj2.y) * 180 / Math.PI
		}
		
		//creates an x and y coordinate randomly outside the screen
		public static function spawnOutScreen():Point
		{
			var randomNumber:Number = Math.random();
			var randomPosX:int;
			var randomPosY:int;
			
			if (randomNumber < 0.25)
			{
				randomPosX = 1310;
				randomPosY = Math.random() * 720;
			}
			else if (randomNumber > 0.25 && randomNumber < 0.50)
			{
				randomPosX = Math.random() * 1280;
				randomPosY = 790;
			}
			else if (randomNumber > 0.50 && randomNumber < 0.75)
			{
				randomPosX = -30;
				randomPosY = Math.random() * 720;
			}
			else if (randomNumber > 0.75)
			{
				randomPosX = Math.random() * 1280;
				randomPosY = -30;
			}
			var point:Point = new Point(randomPosX, randomPosY);
			return point;
		}
		
		public static function ShakeScreen(shakynes:int):Point
		{
			var shakeX:int;
			var shakeY:int;
			
			if (Math.random() < 5) shakynes = shakynes;
			else shakynes = shakynes - (shakynes * 2);
			
			shakeX = Math.random() * shakynes;
			shakeY = Math.random() * shakynes;
			
			var movingPoint:Point = new Point(shakeX, shakeY);
			var opositeMovingPoint:Point = new Point(shakeX - (shakeX * 2), shakeY - (shakeY * 2))
			
			var shakePos:Point;
			
			if (Math.random() > 0.5) shakePos = movingPoint;
			else shakePos = opositeMovingPoint;
			
			return shakePos;
		}
	}
}