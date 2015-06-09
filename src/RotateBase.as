package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Daniël Brand
	 */
	public class RotateBase extends MovieClip
	{
		protected var character:MovieClip;
		
		public var angle:Number = 0;
		
		public var targetPosition:Point;
		
		public var lives:Number;
		
		public var speed:Number;
		
		public var rotateSpeed:Number = (Math.random() * 0.5) + 1;
		
		public var aimMode:Boolean = true;
		
		//public var rotValue:int;
		
		public var rotationCheckLength:int;
		
		public var isMage:Boolean;
		
		public var isPlayer:Boolean;
		
		public var size:Number;
		
		public var toRemove:Boolean;
		
		public var meleeDamage:Number;
		
		public var waitForAnim:int = 10;
		
		public var dead:Boolean;
		
		private var dx:Number;
		private var dy:Number;
		
		private var radian:Number;
		
		public function RotateBase()
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
			if (Main.player != null)
			{
				if (aimMode)
				{
					rotationCheckLength = 2;
					dx = targetPosition.x;
					dy = targetPosition.y;
					
					radian = Math.atan2(dy, dx);
					angle = radian * 180 / Math.PI; //omzetten van radian naar angle
				}
				if (this.rotation < angle)
				{
					if ((this.rotation + 90 * rotationCheckLength) > angle)
						this.rotation += rotateSpeed;
					else
						this.rotation -= rotateSpeed;
				}
				if (this.rotation > angle)
				{
					if ((this.rotation - 90 * rotationCheckLength) < angle)
						this.rotation -= rotateSpeed;
					else
						this.rotation += rotateSpeed;
				}
			}
		}
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
		}
	}
}