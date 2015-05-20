package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Daniel
	 */
	public class Cursor extends Sprite
	{
		[Embed(source = "../lib/hand.png")]
		private var CrossHairArt:Class;
		private var art:Bitmap;
		//private var gunshotSounds:Sound;
		//private var soundChannel: SoundChannel;
		public static const SHOOT:String = "Shoot";
		
		public function Cursor() //Crosshair Toevoegen
		{
			Mouse.hide();
			art = new CrossHairArt();
			addChild(art);
			this.scaleX = this.scaleY = 0.05;
			//art.x = -art.width / 2;
			//art.y = -art.height / 2;
			
			this.addEventListener(Event.ENTER_FRAME, loop);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			//gunshotSounds = new Sound();
			//gunshotSounds.load(new URLRequest("../lib/gunsound.mp3"));
		}
		
		private function onClick(e:MouseEvent):void //Wanneer Je Schiet
		{
			dispatchEvent(new Event(Cursor.SHOOT));
			//hier komt de gunshot
			//soundChannel = gunshotSounds.play(0, 1);
		}
		
		private function loop(e:Event):void 
		{
			this.x = stage.mouseX;
			this.y = stage.mouseY;
		}
	}
}