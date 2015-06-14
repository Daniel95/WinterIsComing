package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author 
	 */
	public class SoundTest extends Sprite
	{
		private var sound:Sound;
		private var channel:SoundChannel;
		
		
		public function SoundTest() 
		{
			var urlLoader:URLRequest = new URLRequest("../lib/sound/roar.mp3");
			sound = new Sound(urlLoader);
			channel = sound.play(0, 10);
			
			loop();
			
			
		}
		
		public function loop():void 
		{
			chanel.stop();
			channel = 
		}
		
	}

}