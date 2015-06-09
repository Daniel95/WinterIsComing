package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	//import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.display.StageQuality;
	import Maths;
	
	/**
	 * ...
	 * @author Daniel Brand, David Zwitser, Niels Hus
	 */
	public class Main extends Sprite
	{
		//music
		private var inGameTheme:Sound;
		private var gameOverTheme:Sound;
		private var arrowShoot:Sound;
		private var pickUpSound:Sound;
		private var growl1:Sound;
		private var growl2:Sound;
		private var summonerComing:Sound;
		private var soundChannel:SoundChannel;
		private var growlCD:int = 200;
		
		//characters
		public static var player:Player;
		private var enemies:Array;
		private var walkers:Vector.<Walker>;
		
		//objects in arrays/vectors
		private var projectile:Array;
		private var walls:Vector.<Wall>;
		private var pickUps:Vector.<PickUp>;
		
		//scripts
		private var followBase:RotateBase;
		private var mainretry:mainRetry;
		
		//object scripts
		private var cursor:Cursor;
		private var arrow:Arrow;
		private var bars:Bars;
		private var wall:Wall;
		private var summoner:Summoner;
		private var pickUp:PickUp;
		private var UpgradeMenu:upgradeMenu;
		private var background:MovieClip;
		private var barDecoration:BarDecoration;
		public var scoreboard:ScoreBoard;
		private var enemy:MovieClip;
		
		//Arts
		private var muteSoundEffectsOff:MuteSoundEffectsOff;
		private var muteSoundEffectsOn:MuteSoundEffectsOn;
		private var muteMusicOff:MuteMusicOff;
		private var muteMusicOn:MuteMusicOn;
		
		//counters
		private var spawnCounter:Number = -300; //counter to let the enemies know when they have to spawn
		private var enemyCounter:int = 0; // keeps track of the amound of enemies in the field
		private var spawnRate:Number = 1; //The speed at wich the counter goes
		private var SkeletonCount:int = 0; //keeps track of the amound of skellentons
		private var _timesSumSpawned:int;
		private var _maxSkelentons:int = 3;
		
		//Booleans
		private var SummonerActive:Boolean; //checks if the summoner is active
		private var playerShoots:Boolean = true; //tels if a arrow needs to deal dammige 
		private var sum:Boolean; //an other bool for spawning of the summoner 
		private var onlyOnce:Boolean; //removes arrows one time when earthquake comes
		public var musicOff:Boolean = false;
		
		//coördinates
		private var direction:Point;
		private var pos:Point;
		
		public function Main():void
		{	
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			
			//random art
			var wall:Wall = new Wall();
			if (mainMenu.forrestStyle == true)
				background = new BackgroundArt(), Wall.wallRandomArt = false, addChild(background);
			else if (Math.random() > 0.5)
				background = new BackgroundSnow(), Wall.wallRandomArt = true, addChild(background);
			else
				background = new SnowArt2(), Wall.wallRandomArt = true, addChild(background);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.quality = StageQuality.LOW;
			
			//spawn player
			player = new Player();
			this.addChild(player);
			player.x = 540;
			player.y = 360;
			player.addEventListener("onShoot", createprojectile);
			
			enemies = new Array();
			walls = new Vector.<Wall>();
			
			bars = new Bars();
			addChild(bars);
			
			projectile = new Array;
			
			pickUps = new Vector.<PickUp>();
			
			inGameTheme = new Sound();
			inGameTheme.load(new URLRequest("../lib/sound/soundtrack_inGame.mp3"));
			soundChannel = inGameTheme.play(0, 10);
			
			gameOverTheme = new Sound();
			gameOverTheme.load(new URLRequest("../lib/sound/soundtrack_die.mp3"));
			
			growl1 = new Sound();
			growl1.load(new URLRequest("../lib/sound/roar.mp3"));
			
			growl2 = new Sound();
			growl2.load(new URLRequest("../lib/sound/roar_2.mp3"));
			
			summonerComing = new Sound();
			summonerComing.load(new URLRequest("../lib/sound/summoner_sfx.mp3"));
			
			arrowShoot = new Sound();
			arrowShoot.load(new URLRequest("../lib/sound/arrowshoot.mp3"));
			
			pickUpSound = new Sound();
			pickUpSound.load(new URLRequest("../lib/sound/PickupSound.mp3"));
			
			muteSoundEffectsOn = new MuteSoundEffectsOn();
			muteSoundEffectsOn.x = 1210, muteSoundEffectsOn.y = 650;
			muteSoundEffectsOn.alpha = 0;
			addChild(muteSoundEffectsOn);
			
			muteSoundEffectsOff = new MuteSoundEffectsOff();
			muteSoundEffectsOff.x = 1210, muteSoundEffectsOff.y = 650;
			addChild(muteSoundEffectsOff);
			
			muteMusicOn = new MuteMusicOn();
			muteMusicOn.x = 1140, muteMusicOn.y = 650;
			muteMusicOn.alpha = 0;
			addChild(muteMusicOn);
			
			muteMusicOff = new MuteMusicOff();
			muteMusicOff.x = 1140, muteMusicOff.y = 650;
			addChild(muteMusicOff);
			
			//drawing upgrade menu	
			UpgradeMenu = new upgradeMenu();
			addChild(UpgradeMenu);
			UpgradeMenu.y = 20;
			UpgradeMenu.x = 330;
			UpgradeMenu.alpha = 0;
			
			//draws scoreboard
			scoreboard = new ScoreBoard();
			scoreboard.x = 550;
			addChild(scoreboard);
			
			//drawing trees
			drawWalls(760, 610, 100);
			drawWalls(700, 110, 150);
			drawWalls(510, 550, 130);
			drawWalls(350, 380, 120);
			
			//drawing barDecoration
			barDecoration = new BarDecoration();
			addChild(barDecoration);
			barDecoration.x = 125;
			barDecoration.y = 70;
			barDecoration.scaleX = barDecoration.scaleY = 1;
			
			//adds cursor
			cursor = new Cursor();
			addChild(cursor);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		private function loop(e:Event):void
		{
			if (player != null)
			{
				//player.lives = 4;
				if (bars.chooseUpgrades > 0)
				{
					UpgradeMenu.alpha += 0.01;
					//player.skillPoint();
					if (bars.upgrade == 1)
						player.lives += 3, bars.upgrade = 0, bars.chooseUpgrades--, scoreboard._upgradeScore--, scoreboard.score(), bars.bars();
					if (bars.upgrade == 2)
						player.moveSpeedPower += 0.1, bars.upgrade = 0, bars.chooseUpgrades--, scoreboard._upgradeScore--, scoreboard.score(), bars.bars();
					if (bars.upgrade == 3)
						player.shootSpeedPower -= 0.05, bars.upgrade = 0, bars.chooseUpgrades--, scoreboard._upgradeScore--, scoreboard.score(), bars.bars();
				}
				else
					UpgradeMenu.alpha = 0;
				
				if (!player.soundEffectsOff)
				{
					if (growlCD < 0)
					{
						if (Math.random() < 0.50)
							soundChannel = growl1.play(0, 1);
						else
							soundChannel = growl2.play(0, 1);
						growlCD = (Math.random() * 1300) + 400;
					}
					else
						growlCD--;
				}
				
				collisions(); //handles the collisions
				if (enemyCounter < 9)
				{
					spawnEnemies(); //spawnes the enemies
				}
				seeIfSpawnSummoner(); //checks if summenor needs to spawn
			}
		}
		
		private function seeIfSpawnSummoner():void
		{
			if (scoreboard._score % 30 == 0 && scoreboard._score != 0)
			{
				sum = true;
			}
			if (sum == true)
			{
				if (!SummonerActive)
				{
					spawnSummoner();
					if (_maxSkelentons <= 15) _maxSkelentons += 3;
					
					_timesSumSpawned++, scoreboard._summonersSpawned++, scoreboard._score++, scoreboard.score();
				}
				if (SummonerActive) 
				{
					if (SkeletonCount <= _maxSkelentons) spawnSkeletons();
					
					if (_timesSumSpawned < 4) screenShake(_timesSumSpawned * 2);
					else screenShake(8);
				}
			}
		}
		
		//spawnEnemies
		private function spawnEnemies():void
		{
			if (spawnCounter >= 160 && !SummonerActive)
			{
				if (Math.random() < 0.6)
				{
					//------spawns a walker------
					enemy = new Walker(scoreboard._score);
					
					enemies.push(enemy);
					addChild(enemy);
					
					pos = Maths.spawnOutScreen();
					
					enemy.x = pos.x;
					enemy.y = pos.y;
					
					enemyCounter++;
				}
				else
				{
					//------spawns a wildling------
					enemy = new Wildling(scoreboard._score);
					enemies.push(enemy);
					addChild(enemy);
					
					pos = Maths.spawnOutScreen();
					enemy.x = pos.x;
					enemy.y = pos.y;
					enemy.addEventListener("onShoot", createprojectile);
					
					enemyCounter++;
				}
				spawnCounter = 0;
				spawnRate += 0.01;
			}
			else
				spawnCounter += spawnRate;
		}
		
		private function spawnSummoner():void
		{
			//------spawns the Summoner------
			enemy = new Summoner(scoreboard._score);
			enemies.push(enemy);
			addChild(enemy);
			
			pos = Maths.spawnOutScreen();
			enemy.x = pos.x;
			enemy.y = pos.y;
			
			SummonerActive = true;
			
			if (!player.soundEffectsOff)
				soundChannel = summonerComing.play(0, 1);
		}
		
		private function spawnSkeletons():void
		{
			//------spawns the skeletons------
			
			enemy = new Skeleton(scoreboard._score);
			enemies.push(enemy);
			
			addChild(enemy);
			
			SkeletonCount++;
			
			pos = Maths.spawnOutScreen();
			enemy.x = pos.x; 
			enemy.y = pos.y; 
		}
		
		private function collisions():void
		{
			//-----collison enemies------
			for (var y:int = 0; y < enemies.length; y++)
			{
				//collision enemies with player
				if (player.hitTestPoint(enemies[y].x, enemies[y].y, true))
				{
					bars.bars()
					player.getDamaged(enemies[y].x, enemies[y].y, enemies[y].meleeDamage);
					//enemies[y].attackAnim();
					if (player.lives <= 0)
					{
						dead();
					}
				}
				
				//collision enemies with enemies
				for (var h:int = 0; h < enemies.length; h++)
				{
					if (enemies[h].hitTestObject(enemies[y]) && Maths.hitTest(enemies[y], enemies[h]) == true && enemies[h] != enemies[y])
					{
						direction = Maths.fromAngleToPos(Maths.fromPosToAngle(enemies[h], enemies[y]) - 90);
						
						enemies[y].x = enemies[h].x + (direction.x * -1) * (enemies[y].radius + enemies[h].radius);
						enemies[y].y = enemies[h].y + direction.y * (enemies[y].radius + enemies[h].radius);
					}
					
				}
				
				for (var w:int = 0; w < walls.length; w++)
				{
					//collision enemies with wall
					if (walls[w].hitTestObject(enemies[y]) && Maths.hitTest(enemies[y], walls[w]) == true)
					{
						direction = Maths.fromAngleToPos(Maths.fromPosToAngle(walls[w], enemies[y]) - 90);
						
						enemies[y].x = walls[w].x + (direction.x * -1) * (enemies[y].radius + walls[w].radius);
						enemies[y].y = walls[w].y + direction.y * (enemies[y].radius + walls[w].radius);
					}
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
			}
			
			for (var wl:int = 0; wl < walls.length; wl++)
			{
				//collision player with wall
				if (player.hitTestObject(walls[wl]) && Maths.hitTest(player, walls[wl]) == true)
				{
					//trace("collided");
					direction = Maths.fromAngleToPos(Maths.fromPosToAngle(walls[wl], player) - 90);
					
					player.x = walls[wl].x + (direction.x * -1) * (player.radius + walls[wl].radius);
					player.y = walls[wl].y + direction.y * (player.radius + walls[wl].radius);
				}
				for (var wl2:int = 0; wl2 < walls.length; wl2++)
				{
					if (walls[wl].hitTestObject(walls[wl2]) && walls[wl] != walls[wl2] && Maths.hitTest(walls[wl], walls[wl2]))
					{
						direction = Maths.fromAngleToPos(Maths.fromPosToAngle(walls[wl], walls[wl2]) - 90);
						
						walls[wl2].x = walls[wl].x + (direction.x * -1) * (walls[wl2].radius + walls[wl].radius);
						walls[wl2].y = walls[wl].y + direction.y * (walls[wl2].radius + walls[wl].radius);
					}
				}
			}
			//collision player with pickup
			for (var pu:int = 0; pu < pickUps.length; pu++)
			{
				if (player.hitTestObject(pickUps[pu]))
				{
					removeChild(pickUps[pu]); //remove from display
					pickUps.splice(pu, 1); //remove from array(pos, amount)
					
					bars.chooseUpgrades++;
					bars.bars();
					scoreboard._upgradeScore++;
					scoreboard.score();
					
					if (!player.soundEffectsOff)
						soundChannel = pickUpSound.play(0, 1);
				}
			}
			//------collison projectile------
			for (var i:int = 0; i < projectile.length; i++)
			{
				//collision wall with projectile
				for (var wa:int = 0; wa < walls.length; wa++)
				{
					//collision projectile with wall
					if (projectile[i].hitTestObject(walls[wa]) && Maths.hitTest(projectile[i], walls[wa]) == true)
					{
						projectile[i].collWall();
					}
				}
				
				//collison enemies - projectile
				for (var k:int = 0; k < enemies.length; k++)
				{
					var targetColCount:int;
					if (enemies[k].hitTestPoint(projectile[i].x, projectile[i].y, true))
					{
						targetColCount = 0;
						if (projectile[i].didDamage == false)
						{
							if (playerShoots == true)
							{
								enemies[k].lives -= projectile[i].speed * 0.2;
								enemies[k].speed *= 0.7;
							}
							projectile[i].didDamage = true;
						}
						else
							projectile[i].didDamage = true;
						if (enemies[k].lives <= 0)
						{
							if (enemies[k] is Skeleton == false)
							{
								//handles enemy deaths
								if (Math.random() < 0.35)
								{
									var pickUp:PickUp = new PickUp();
									pickUps.push(pickUp);
									addChild(pickUp);
									pickUp.scaleX = pickUp.scaleY = 0.6;
									
									pickUp.x = enemies[k].x;
									pickUp.y = enemies[k].y;
								}
								enemyCounter--;
								
								if (SummonerActive == false)
								{
									scoreboard._score++, scoreboard.score(), bars.bossScore++, bars.bars();
								}
							}
							
							if (SummonerActive == true)
							{
								if (enemies[k] is Skeleton)
								{
									//skeleton deaths
									SkeletonCount--;
									player.lives += 0.5;
								}
								else if (enemies[k] is Summoner)
								{
									//summoner death
									sum = false;
									SummonerActive = false;
								}
							}
							
							enemies[k].dead = true;
						}
						else if (projectile[i].isArrow == true)
							projectile[i].stuckInTarget(enemies[k], enemies[k].rotation);
					}
					else if (projectile[i].isArrow == true)
					{
						targetColCount++;
						if (projectile[i].didDamage == true && targetColCount == enemies.length && projectile[i].dieSoon == false)
							projectile[i].toRemove = true;
					}
					if (enemies[k].toRemove)
					{
						enemies[k].destroy();
						removeChild(enemies[k]);
						enemies.splice(k, 1);
					}
				}
				//collision projectile with projectile
				for (var o:int = 0; o < projectile.length; o++)
				{
					if (projectile[i].didDamage == false && projectile[o].hitTestPoint(projectile[i].x, projectile[i].y, true) && projectile[o] != projectile[i] && projectile[i].isArrow)
					{
						projectile[o].arrowCol();
						projectile[i].arrowCol();
					}
				}
				//collision player with projectile
				if (player.hitTestPoint(projectile[i].x, projectile[i].y, true) && projectile[i].didDamage == false)
				{
					bars.bars();
					projectile[i].toRemove = true;
					player.getDamaged(projectile[i].x, projectile[i].y, projectile[i].damage);
					if (player.lives <= 0)
					{
						dead();
					}
				}
				if (projectile[i].x > 1280 || projectile[i].x < 0 || projectile[i].y > 720 || projectile[i].y < 0)
					projectile[i].toRemove = true;
				if (projectile[i].toRemove) //haalt de projectile weg
				{
					projectile[i].destroy();
					removeChild(projectile[i]); //remove from display
					projectile.splice(i, 1); //remove from array(pos, amount)
				}
			}
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			if (muteSoundEffectsOff.hitTestPoint(mouseX, mouseY) || muteSoundEffectsOn.hitTestPoint(mouseX, mouseY))
			{
				if (player.soundEffectsOff == false)
					muteSoundEffectsOff.alpha = 0, muteSoundEffectsOn.alpha = 1, player.soundEffectsOff = true;
				else if (player.soundEffectsOff == true)
					muteSoundEffectsOn.alpha = 0, muteSoundEffectsOff.alpha = 1, player.soundEffectsOff = false;
			}
			if (muteMusicOff.hitTestPoint(mouseX, mouseY) || muteMusicOn.hitTestPoint(mouseX, mouseY))
			{
				if (musicOff == false)
					muteMusicOff.alpha = 0, muteMusicOn.alpha = 1, soundChannel.stop(), musicOff = true;
				else if (musicOff == true)
					muteMusicOn.alpha = 0, muteMusicOff.alpha = 1, soundChannel = inGameTheme.play(0, 10), musicOff = false;
			}
		}
		
		private function drawWalls(xPos:int, yPos:int, scale:int):void
		{
			//function to draw walls
			var wall:Wall = new Wall();
			walls.push(wall);
			addChild(wall);
			wall.width = wall.height = scale;
			wall.x = xPos, wall.y = yPos;
			wall.radius = wall.width / 2;
		}
		
		private function createprojectile(e:ShootEvent):void
		{
			//arrow shooting
			if (player != null)
			{
				var r:Number; //rotation of projectile
				var s:Number; //speed of projectile
				var tPos:Point = new Point(e.shooter.x, e.shooter.y);
				var dmg:int;
				if (e.shooter.isPlayer) //if player shoots. if this doesnt work, the instance name is probably not right, use trace(e.shooter.name);
				{
					r = e.shooter.rotation * 2 + (Math.ceil(Math.random() * (player.accuracy - -player.accuracy)) + -player.accuracy);
					s = 13 - player.accuracy / 2; //schiet harder als je accuacy beter is, werkt niet goed atm ik ga t fixen dus niet aanpassen
					playerShoots = true;
				}
				else //if enemies shoots
				{
					playerShoots = false;
					r = e.shooter.rotation;
					s = 8 + (scoreboard._score / 50);
					dmg = (scoreboard._score / 25) + 1;
				}
				if (e.shooter.isMage == false)
				{
					var a:Arrow = new Arrow(r, tPos, s, dmg); //hier wordt de rotatie van Arrow berekend;
					projectile.push(a);
					addChild(a);
					a.scaleX = a.scaleY = 0.1;
				}
				else
				{
					var b:Fireball = new Fireball(r, tPos, s, dmg); //hier wordt de rotatie van Arrow berekend;
					projectile.push(b);
					addChild(b);
					b.scaleX = b.scaleY = 0.1;
				}					
				if (!player.soundEffectsOff)
					soundChannel = arrowShoot.play(0, 1);
			}
		}
		
		private function OnKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 32)
				screenShake(5);
		}
		
		//shake opbjects
		private function screenShake(shakynes:int):void
		{
			var sameShake:Point = new Point(Maths.ShakeScreen(shakynes).x, Maths.ShakeScreen(shakynes).y);
			
			background.x = 0, background.y = 0;
			//shake enemies
			for (var en:int; en < enemies.length; en++)
			{
				if (enemies[en] is Summoner == false)
					enemies[en].x += Maths.ShakeScreen(shakynes).x, enemies[en].y += Maths.ShakeScreen(shakynes).y;
			}
			//shake pickups
			for (var pc:int; pc < pickUps.length; pc++)
				pickUps[pc].x += Maths.ShakeScreen(shakynes).x, pickUps[pc].y += Maths.ShakeScreen(shakynes).y;
			//shake trees
			for (var tr:int = walls.length - 1; tr >= 0; tr--)
				walls[tr].x += Maths.ShakeScreen(shakynes).x, walls[tr].y += Maths.ShakeScreen(shakynes).y;
			//shake cursor
			cursor.x += Maths.ShakeScreen(shakynes).x * 2, cursor.y += Maths.ShakeScreen(shakynes).y * 2;
			//shake player
			player.x += Maths.ShakeScreen(shakynes).x, player.y += Maths.ShakeScreen(shakynes).y;
			//shake background
			background.x += sameShake.x, background.y += sameShake.y;
		}
		
		public function dead():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			for (var d:int = 0; d < enemies.length; d++)
			{
				enemies[d].destroy();
			}
			for (var a:int = 0; a < projectile.length; a++)
			{
				projectile[a].destroy();
			}
			soundChannel.stop();
			//soundChannel = gameOverTheme.play(0, 1);
			player.destroy();
			removeChild(player);
			mainretry = new mainRetry();
			addChild(mainretry);
		}
	}
}