package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class PickUp extends Sprite
	{
		private var pickUpImage:MovieClip;
		
		public function PickUp()
		{
			pickUpImage = new PickupArt();
			this.addChild(pickUpImage);
		}
	
	}
}