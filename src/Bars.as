package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Daniël Brand & David Zwitser
	 */
	public class Bars extends Sprite
	{
		private var pointer:PointerArt;
		private var pointers:Vector.<PointerArt>;
		
		private var bossIndicator:SkullArt;
		private var healthBar1:HealthBarArt;
		private var healthBar2:HealthBarArt;
		private var moveSpeedBar:WalkSpeedBar;
		private var shootSpeedBar:ArrowSpeedBar;
		public var chooseUpgrades:int = 0;
		public var upgrade:int = 0;
		
		private var maxHealth:int = 50;
		private var maxMoveSpeed:int = 2;
		private var maxShootSpeed:int = 0;
		
		public var bossScore:int;
		
		private var scoreboard:ScoreBoard;
		
		private var healthOP:Number = 0.05;
		
		public function Bars()
		{
			pointers = new Vector.<PointerArt>();
			for (var a:int = 0; a <= 2; a++)
			{
				pointer = new PointerArt;
				addChild(pointer);
				pointer.scaleX = pointer.scaleY = 0.7;
				pointers.push(pointer);
			}
			
			healthBar1 = new HealthBarArt();
			this.addChild(healthBar1);
			healthBar1.scaleY = 0.3;
			healthBar1.y = 29;
			
			healthBar2 = new HealthBarArt();
			this.addChild(healthBar2);
			healthBar2.scaleX = 0.46;
			healthBar2.scaleY = 0.3;
			healthBar2.y = 29;
			healthBar2.x = -1000;
			
			moveSpeedBar = new WalkSpeedBar();
			this.addChild(moveSpeedBar);
			moveSpeedBar.scaleY = 0.3;
			
			moveSpeedBar.y = 65;
			
			shootSpeedBar = new ArrowSpeedBar();
			this.addChild(shootSpeedBar);
			shootSpeedBar.scaleY = 0.3;
			
			shootSpeedBar.y = 105;
			
			bossIndicator = new SkullArt();
			this.addChild(bossIndicator);
			bossIndicator.scaleY = bossIndicator.scaleX = 0.22;
			bossIndicator.x = 1239;
			bossIndicator.y = 60;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			healthBar1.scaleX = 20 * 0.01;
			healthBar1.x = (healthBar1.width / 2) + 43;
			
			moveSpeedBar.scaleX = (Main.player.moveSpeedPower * 0.1);
			moveSpeedBar.x = (moveSpeedBar.width / 2) + 40;
			
			shootSpeedBar.scaleX = (Main.player.maxValueAccuracy - (Main.player.accuracy - Main.player.shootSpeedPower)) * 0.01 + 0.03;
			shootSpeedBar.x = (shootSpeedBar.width / 2) + 36;
			
			bossIndicator.alpha = 0;
			
			if (chooseUpgrades > 0)
			{
				for (var i:int = 0; i < 3; i++)
				{
					pointers[i].y = (i * 42) + 23;
				}
				pointers[0].x = healthBar1.x + (healthBar1.width / 1.9);
				pointers[1].x = moveSpeedBar.x + (moveSpeedBar.width / 1.9);
			}
			else
				for (var b:int = 0; b < pointers.length; b++)
					pointers[b].y = -100;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void
		{
			bossIndicator.x = 1239;
			
			shootSpeedBar.scaleX = (Main.player.maxValueAccuracy - (Main.player.accuracy - Main.player.shootSpeedPower)) * 0.01 + 0.03;
			shootSpeedBar.x = (shootSpeedBar.width / 2) + 36;
			
			if (chooseUpgrades > 0) pointers[2].x = shootSpeedBar.x + (shootSpeedBar.width / 1.9);
			
			if (Main.player.lives <= 5) {
				if (healthBar2.alpha > 1) healthOP *= -1;
				else if (healthBar2.alpha < 0) healthOP *= -1;
				healthBar2.alpha += healthOP;
			}
			
			bossIndicator.x += Maths.ShakeScreen(bossScore / 2).x;
		}
		
		public function bars():void
		{
			if (Main.player.lives <= 5) {
				healthBar2.x = (healthBar2.width / 2) + 42;
			}
			else healthBar2.x = -1000;
			
			healthBar1.scaleX = Main.player.barLives * 0.015;
			healthBar1.x = (healthBar1.width / 2) + 42;
			
			moveSpeedBar.scaleX = (Main.player.moveSpeedPower * 0.1);
			moveSpeedBar.x = (moveSpeedBar.width / 2) + 40;
			
			if (bossScore > 30) bossScore = 0;
			
			bossIndicator.alpha = bossScore / 30;
			
			if (chooseUpgrades > 0)
			{
				for (var i:int = 0; i < 3; i++)
				{
					pointers[i].y = (i * 42) + 23;
				}
				pointers[0].x = healthBar1.x + (healthBar1.width / 1.9);
				pointers[1].x = moveSpeedBar.x + (moveSpeedBar.width / 1.9);
			}
			else{
				for (var b:int = 0; b < pointers.length; b++) pointers[b].y = -100;
			}
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			if (healthBar1.hitTestPoint(mouseX, mouseY) || healthBar2.hitTestPoint(mouseX, mouseY) && Main.player.lives < maxHealth)
				upgrade = 1, Main.player.upgradeClick = true;
			else if (moveSpeedBar.hitTestPoint(mouseX, mouseY) && Main.player.moveSpeedPower < maxMoveSpeed)
				upgrade = 2, Main.player.upgradeClick = true;
			else if (shootSpeedBar.hitTestPoint(mouseX, mouseY) && Main.player.shootSpeedPower > maxShootSpeed)
				upgrade = 3, Main.player.upgradeClick = true;
			else
				Main.player.upgradeClick = false;
		}
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
	}

}