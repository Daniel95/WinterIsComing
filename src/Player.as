package
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Daniel Brand
	 */
	public class Player extends RotateBase
	{
		//X & Y movement
		public var transformX:Number = 0; //de speed van de player x
		public var transformY:Number = 0; //de speed van de player y
		
		private var bowPosX:Number;
		private var bowPosY:Number;
		
		//collision
		public var radius:int = 25;
		
		//input
		private var keyUp:Boolean;
		private var keyDown:Boolean;
		private var keyLeft:Boolean;
		private var keyRight:Boolean;
		private var mouseDown:Boolean;
		private var runAnim:Boolean;
		
		//UI
		public var barLives:int //makes the playerhealth available for Bars script
		
		//Sound
		private var damage:Sound;
		private var nearDead:Sound;
		private var bowPull:Sound;
		private var arrowShoot:Sound;
		private var soundChannel:SoundChannel;
		
		public var soundEffectsOff:Boolean = false;
		
		//Art
		private var bow:BowArt;
		private var arrow:ArrowArt;
		
		//animations
		//private var walkAnim:PlayerWalkArt;
		
		//Moving
		public var moveSpeedPower:Number = 1.0; //bonus from powerup
		private var runMoveSpeed:Number = 0.38;
		private var shootMoveSpeed:Number = 0.20;
		
		private var goRunning:Boolean; //if the player moves. used for running check
		
		//Shooting
		public var shootSpeedPower:Number = 1.0;
		private var maxShootCD:Number = 11;
		
		private var shootCd:Number = 0;
		
		public var upgradeClick:Boolean = false;
		
		private var lastRotSpeedSave:Number;
		
		//the closer accuracy is to 0, the better you shoot
		public var accuracy:Number = 20; //low = accurate, high(20) = unaccurate
		public var maxValueAccuracy:Number = 20;
		private var MediumAccuracy:Number = 10; //used for the shot you fire after having a good accuracy
		
		public var dmgCD:int;
		
		private var accSPenalty:Number; //lowers movement when aiming
		
		public function Player()
		{
			character = new PlayerArt();
			this.addChild(character);
			character.scaleX = character.scaleY = 0.2;
			
			bow = new BowArt();
			this.addChild(bow);
			
			bow.scaleY = 0.12 + accuracy * 0.0025;
			bow.scaleX = 0.15 - accuracy * 0.0045;
			
			arrow = new ArrowArt();
			arrow.scaleX = arrow.scaleY = 0.1;
			
			bowPull = new Sound();
			bowPull.load(new URLRequest("../lib/sound/bowpull1.mp3"));
			
			damage = new Sound();
			damage.load(new URLRequest("../lib/sound/damage.mp3"));
			
			nearDead = new Sound();
			nearDead.load(new URLRequest("../lib/sound/heartbeat.mp3"));
			
			speed = 0;
			
			isPlayer = true;
			
			lives = 20;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			mouseDown = true;
			//this.addChildAt(arrow, numChildren - 2);
			if (this.arrow != null)
				this.addChild(arrow);
			
			if (!soundEffectsOff)
			{
				var r:Number = Math.random();
				bowPull = new Sound();
				if (r < 0.33)
				{
					bowPull.load(new URLRequest("../lib/sound/bowpull1.mp3"));
				}
				else if (r < 0.77)
					bowPull.load(new URLRequest("../lib/sound/bowpull2.mp3"));
				else
					bowPull.load(new URLRequest("../lib/sound/bowpull3.mp3"));
				soundChannel = bowPull.play(0, 1);
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			soundChannel.stop();
			mouseDown = false;
			//trace(upgradeClick);
			if (aimMode == true)
			{
				if (shootCd <= 0 && upgradeClick == false)
				{
					if (arrow != null)
						this.removeChild(arrow);
					//this.removeChildAt(numChildren-2);
					var se:ShootEvent = new ShootEvent("onShoot");
					se.shooter = this;
					dispatchEvent(se);
					if (accuracy > (MediumAccuracy * shootSpeedPower / 2)) //if accuracy isnt good, you have a fire CD
					{
						shootCd = (maxShootCD * shootSpeedPower);
						accuracy = (maxValueAccuracy * shootSpeedPower);
					}
					else //accuracy becomes medium
					{
						accuracy = (MediumAccuracy * shootSpeedPower);
					}
					goRunning = false;
				}
			}
			else
			{
				aimMode = true;
				shootCd = 0;
			}
		}
		
		override public function loop(e:Event):void
		{
			//Player Movement Mode Running & Shooting
			if (shootCd <= -16.5 && accuracy >= (maxValueAccuracy * shootSpeedPower) && goRunning == true)
			{ //RUNNING
				//rotation
				rotateSpeed = 2.2;
				aimMode = false;
				rotationCheckLength = 1;
				if (this.rotation < 0)
					this.rotation = 180 - Math.abs(this.rotation);
				
				//movement
				if (speed < (runMoveSpeed * moveSpeedPower))
					speed += 0.01;
				if (keyUp)
				{
					if (keyLeft)
						angle = 112.5;
					else if (keyRight)
						angle = 157.5;
					else
						angle = 135;
				}
				else if (keyDown)
				{
					if (keyLeft)
						angle = 67.5;
					else if (keyRight)
						angle = 22.5;
					else
						angle = 45;
				}
				else if (keyRight)
					angle = 0;
				else if (keyLeft)
					angle = 90;
			}
			else
			{ //SHOOTING
				//rotation to cursor
				targetPosition.x = mouseX;
				targetPosition.y = mouseY;
				
				//rotatespeed:
				rotateSpeed = (Math.abs(angle - this.rotation) * 0.035) + 0.35;
				if (rotateSpeed > 10) rotateSpeed = lastRotSpeedSave;
				else lastRotSpeedSave = rotateSpeed;
				
				//movement
				accSPenalty = ((maxValueAccuracy * shootSpeedPower) - accuracy) * 0.006;
				if (speed > ((shootMoveSpeed * moveSpeedPower) - accSPenalty))
					speed -= 0.01;
				else
					speed += 0.01;
				goRunning = false;
			}
			
			//accuarcy
			if (mouseDown)
			{
				if (accuracy > 0)
				{
					accuracy -= 0.5;
					if (accuracy < 15)
						aimMode = true;
				}
				else
					accuracy = 0;
			}
			else if (accuracy < (maxValueAccuracy * shootSpeedPower))
				accuracy++; // max accuracy = 20
			if (shootCd > -20)
				shootCd -= 0.5;
			
			//rotation Player & Bow
			character.rotation = arrow.rotation = bow.rotation = this.rotation;
			
			var r:Number = this.rotation * Math.PI / 180; //van graden naar radians
			
			bowPosX = Math.cos(r);
			bowPosY = Math.sin(r);
			
			arrow.x = bow.x = 25 * bowPosX;
			arrow.y = bow.y = 25 * bowPosY;
			
			//bow kleiner maken als je richt
			bow.scaleY = 0.12 + accuracy * 0.0025;
			bow.scaleX = 0.15 - accuracy * 0.0045;
			
			//move the player
			this.x += transformX;
			this.y += transformY;
			
			//smoothing the movement of the player
			transformX -= transformX / 10;
			transformY -= transformY / 10;
			
			//input
			if (keyLeft)
				transformX -= speed; // move to the left if keyLeft is true
			else if (keyRight)
				transformX += speed; // move to the right if keyRight is true
			if (keyUp)
				transformY -= speed; // move up if keyUp is true
			else if (keyDown)
				transformY += speed; // move down if keyDown is true
			
			//gegevens doorgeven aan anderen scripts
			barLives = lives;
			
			dmgCD--;
			
			super.loop(e); //zorgt ervoor dat de code in FollowBase loop ook nog wordt uitgevoert	
		}
		
		public function getDamaged(otherX:int, otherY:int, liveloses:Number):void
		{
			if(lives < 5) soundChannel = nearDead.play(0, 1);
			if (dmgCD < 0)
			{
				dmgCD = 15;
				lives -= liveloses;
				if (otherX < this.x)
					transformX += 7;
				else
					transformX -= 7;
				if (otherY < this.y)
					transformY += 7;
				else
					transformY -= 7;
				if (!soundEffectsOff)
					soundChannel = damage.play(0, 1);
					if(lives < 5) soundChannel = nearDead.play(0, 1);
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (!runAnim)
				runAnim = true, removeChild(character), character = new PlayerWalkArt(), character.scaleX = character.scaleY = 0.2, addChild(character);
			if (e.keyCode == 37 || e.keyCode == 65)
				keyLeft = true;
			if (e.keyCode == 39 || e.keyCode == 68)
				keyRight = true;
			if (e.keyCode == 38 || e.keyCode == 87)
				keyUp = true;
			if (e.keyCode == 40 || e.keyCode == 83)
				keyDown = true;
			goRunning = true;
			
			//Stay In Area
			if (this.x < 0)
				this.x = 0; //left
			else if (this.x > 1280)
				this.x = 1280; //right
			else if (this.y < 0)
				this.y = 0; //up
			else if (this.y > 720)
				this.y = 720; //down
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 37 || e.keyCode == 65)
				keyLeft = false;
			if (e.keyCode == 39 || e.keyCode == 68)
				keyRight = false;
			if (e.keyCode == 38 || e.keyCode == 87)
				keyUp = false;
			if (e.keyCode == 40 || e.keyCode == 83)
				keyDown = false;
			else
				runAnim = false, removeChild(character), character = new PlayerArt(), character.scaleX = character.scaleY = 0.2, addChild(character);
		}
		
		override public function destroy():void
		{
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.removeEventListener(MouseEvent.CLICK, onMouseDown);
			this.removeEventListener(MouseEvent.CLICK, onMouseUp);
			this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.removeEventListener(Event.ENTER_FRAME, loop);
			super.destroy();
		}
	}
}