package  
{
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Daniel Brand
	 */
	public class Player extends FollowBase
	{
		//private var tankBody:TankBodyArt;
		//private var character:characterArt;
		
		private var transformX:Number = 0;//de speed van de player x
		private var transformY:Number = 0;//de speed van de player y
		
		private var keyUp:Boolean;
		private var keyDown:Boolean;
		private var keyLeft:Boolean;
		private var keyRight:Boolean;

		private var bowPosX:Number = 0;
		private var bowPosY:Number = 0;
		private var shootCd:Number = 0;
		public var accuracy:Number = 20;//low is accurate, high is unaccurate
		private var mouseDown:Boolean;
		
		public var radius:int = 30;
		
		public var barLives:int//makes the playerhealth available for Bars script
		
		private var bow:BowArt;
		private var arrow:ArrowArt;
		
		private var speedValue:Number = 0.7;
		
		private var isMoving:Boolean;
		
		private var maxSpeed:Number = 0.9;
		private var minSpeed:Number = 0.45;
		
		private var allRotPos:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8];
		
		public function Player() 
		{
			character = new PlayerArt();
			this.addChild(character);
			
			bow = new BowArt();
			this.addChild(bow);
			
			arrow = new ArrowArt();
			arrow.scaleX = arrow.scaleY = 0.1;
			
			character.scaleX = character.scaleY = 0.2;
			
			speed = 0.7;
			
			rotateSpeed = 3;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void 
		{
			lives = 25;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		private function onMouseDown(e:MouseEvent):void 
		{
			mouseDown = true;
			this.addChild(arrow);
			//trace(mouseX, mouseY);
		}
		private function onMouseUp(e:MouseEvent):void 
		{
			mouseDown = false;
			if (shootCd <= 0)
			{
				this.removeChild(arrow);
				var se:ShootEvent = new ShootEvent("onShoot");
				se.shooter = this;
				dispatchEvent(se);
				//trace("you fired, accuracy = " +  accuracy);
				if (accuracy > 10)//if accuracy isnt good, you have a fire CD
				{
					shootCd = 11;
					accuracy = 20;
				}
				else
				{
					accuracy = 7;
				}
				isMoving = false;
				/*
				if (transformX < -2) transformX -= -3.5;
				else if(transformX > 2) transformX -= 3.5;
				if (transformY < -2) transformY -= 3.5;
				else if(transformY > 2) transformY -= -3.5;
				*/
			}
		}
		override public function loop(e:Event):void 
		{	
			var r:Number = character.rotation * Math.PI / 180;//van graden naar radians
			
			if (shootCd < -9 && accuracy >= 20 && isMoving == true)
			{
				aimMode = false;
				if (speed < maxSpeed) speed += 0.05;
				
				if (keyUp)
				{
					if (keyLeft)angle = 112.5;
					else if (keyRight) angle = 157.5;
					else angle = 135;
				}
				else if (keyDown)
				{
					if (keyLeft)angle = 67.5;
					else if (keyRight) angle = 22.5;
					else angle = 45;
				}
				else if (keyRight) angle = 0;
				else if (keyLeft) angle = 90;
				
				bow.rotation = arrow.rotation = character.rotation = this.rotation;
				targetPosition.x = mouseX;
				targetPosition.y = mouseY;
			}
			else
			{
				//trace("shootCd = " + shootCd + "accuracy = " + accuracy + "isMoving = " + isMoving);
				bow.rotation = arrow.rotation = character.rotation = this.rotation;
				targetPosition.x = mouseX;
				targetPosition.y = mouseY;
				
				if (speed > minSpeed) speed -= 0.05;

				aimMode = true;
			}
			//trace("angle = " + angle + " | char rotation = " + character.rotation);
			//trace("angle = " + angle);
			//trace("rotation = " + this.rotation);
			
			//grade berekenen
			bowPosX = Math.cos(r);
			bowPosY = Math.sin(r);
			bow.x = arrow.x = 25 * bowPosX;
			bow.y = arrow.y = 25 * bowPosY;
			
			//bow kleiner maken als je richt
			bow.scaleY = 0.12 + accuracy * 0.0025;
			bow.scaleX = 0.15 - accuracy * 0.0045;
			
			//shooting
			if (mouseDown)
			{
				if (accuracy > 0) accuracy -= 0.5;
				else accuracy = 0;
			}
			else if(accuracy < 20)
			{
				accuracy++;
			}
			
			if(shootCd > -10) shootCd -= 0.5;
			
			if(keyLeft){
                transformX -= speed; // move to the left if keyLeft is true
            } else if(keyRight){
                transformX += speed; // move to the right if keyRight is true
            }
            if(keyUp){
                transformY -= speed; // move up if keyUp is true
            } else if(keyDown){
                transformY += speed; // move down if keyDown is true
            }
			
			//move the player
			this.x += transformX;
			this.y += transformY;
			
			//smoothing the movement of the player
			transformX -= transformX / 4;
			transformY -= transformY / 4;
			
			//speler stoppen als hij het veld uit gaat
		    if(this.x < 0) this.x = 0;//left
			if(this.x > 1280) this.x = 1280;//right
			if(this.y < 0) this.y = 0;//up
			if (this.y > 720) this.y = 720;//down
			
			//gegevens doorgeven aan anderen scripts
			barLives = lives;
			
			super.loop(e);//zorgt ervoor dat de code in FollowBase loop ook nog wordt uitgevoert	
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 37 || e.keyCode == 65) keyLeft = true;
			if (e.keyCode == 39 || e.keyCode == 68)	keyRight = true;
			if (e.keyCode == 38 || e.keyCode == 87)	keyUp = true;
			if (e.keyCode == 40 || e.keyCode == 83) keyDown = true;
			isMoving = true;
		}
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == 37 || e.keyCode == 65) keyLeft = false;
			if (e.keyCode == 39 || e.keyCode == 68)	keyRight = false;
			if (e.keyCode == 38 || e.keyCode == 87)	keyUp = false;
			if (e.keyCode == 40 || e.keyCode == 83) keyDown = false;
		}
		public function getDamaged(otherX:int,otherY:int):void 
		{
			lives--;
			if (otherX < this.x) transformX += 7;
			else transformX -= 7;
			if (otherY < this.y) transformY += 7;
			else transformY -= 7;	
		}

		override public function destroy():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(MouseEvent.CLICK, onMouseDown);
			stage.removeEventListener(MouseEvent.CLICK, onMouseUp);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			super.destroy();
		}
	}
}