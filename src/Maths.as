package 
{
	/**
	 * ...
	 * @author David Zwitser
	 */
	public class Maths 
	{
		public function Maths() 
		{
			
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
			
		public static function distanceBetween(object1:Object, object2:Object):Number
		{
			var dx:int = object1.x - object2.x;
			var dy:int = object1.y - object2.y;
			return Math.sqrt((dx * dx) + (dy * dy));
		}
		
		
	}

}