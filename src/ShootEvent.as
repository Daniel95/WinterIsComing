package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class ShootEvent extends Event 
	{
		public var shooter:FollowBase;
		public function ShootEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}