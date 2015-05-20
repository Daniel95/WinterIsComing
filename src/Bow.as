/*

package  
{
	/**
	 * ...
	 * @author Daniël Brand
	 */
	/*
	public class Bow extends Player
	{
		private var bow:BowArt;
		private var arrow:ArrowArt;
		
		public function Bow() 
		{
			bow = new BowArt();
			this.addChild(bow);
			
			arrow = new ArrowArt();
			arrow.scaleX = arrow.scaleY = 0.1;
		}
		override public function onMouseDown(e:MouseEvent):void 
		{	
			this.addChild(arrow);
		}
		override public function onMouseUp(e:MouseEvent):void 
		{	
			if (shootCd <= 0)
			{
				this.removeChild(arrow);
			}
		}
		override public function loop(e:Event):void 
		{	
			//grade berekenen
			bowPosX = Math.cos(radian);
			bowPosY = Math.sin(radian);
			bow.x = arrow.x = 25 * bowPosX;
			bow.y = arrow.y = 25 * bowPosY;
			
			//rotatie van bow & arrow
			bow.rotation = arrow.rotation = characterAngle;
			
			//bow kleiner maken als je richt
			bow.scaleY = 0.12 + accuracy * 0.0025;
			bow.scaleX = 0.15 - accuracy * 0.0045;
			super.loop(e);
		}
	}

}
*/