package
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author niels, David
	 */
	public class ScoreBoard extends TextField
	{
		public var _score:int = 0;
		public var _upgradeScore:int = 0;
		public var _summonersSpawned:int = 0;
		
		public function score():void
		{
			this.text = "Pickups: " + _upgradeScore + "      Boss: " + _summonersSpawned;
		}
		
		public function ScoreBoard()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.defaultTextFormat = new TextFormat("font", 30, 0xd3b14d, true);
			this.width = stage.stageWidth;
			this.x = 880;
			this.text = "Pickups: " + _upgradeScore + "      Boss: " + _summonersSpawned;
		}
	
	}

}