package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Daniel
	 */
	public class Cursor extends Sprite
	{
		private var cursor:CursorArt;
		
		public function Cursor() //Crosshair Toevoegen
		{
			Mouse.hide();
			cursor = new CursorArt();
			addChild(cursor);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void
		{
			this.x = stage.mouseX;
			this.y = stage.mouseY;
		}
	}
}