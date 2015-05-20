package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	/**
	 * ...
	 * @author niels
	 */
	public class ScoreBoard extends TextField
	{
		//[Embed(source="../lib/Olympic Branding.ttf")]
		//private var font:Class;
		
		private var _score:Number = 0;
		
		
		public function set score(s:Number):void
		{
		  _score = s;
		  this.text = "score : " + _score;
		}
		public function get score():Number
		{
			return _score;
		}
		
		public function ScoreBoard() 
		{	
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.defaultTextFormat = new TextFormat("verdana",30,0x662000, true);
			this.width = stage.stageWidth;
			this.text = "score : " + _score;
		}
		
	}

}