package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.KeyboardEvent;
	import Maths;
	
	/**
	 * ...
	 * @author Daniel Brand, Niels Hus, David Zwitser
	 */
	public class Main extends Sprite 
	{
		public static var player:Player;
		private var enemies:Array;
		private var levels:Levels;
		private var arrows:Vector.<Arrow>;
		private var followBase:FollowBase;
		private var spawnCounter:Number = 0;
		private var spawnRate:Number = 1;
		private var walkers:Vector.<Walker>;
		private var mainretry:mainRetry;
		private var arrow:Arrow;
		private var randomNumber:Number;
		private var randomPosX:Number;
		private var randomPosY:Number;
		private var distancePlayerObject:int;
		private var scoreboard:ScoreBoard;
		private var bars:Bars;
		private var wall:Wall;
		private var summoner:Summoner;
		private var cursor:Cursor;
		private var obImage:Obsidian;
		private var SummonerActive: Boolean;
		private var sum: Boolean;
		private var SkeletonCount: int = 0;
		private var power:int = 1;
		
		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			levels = new Levels();
			addChild(levels);
			
			player = new Player();
			this.addChild(player);
			player.x = 300;
			player.y = 300;
			player.addEventListener("onShoot", createArrows);
			
			enemies = new Array();
			
			bars = new Bars();
			addChild(bars);
			
			wall = new Wall();
			addChild(wall);
			
			arrows = new Vector.<Arrow>();
			
			scoreboard = new ScoreBoard();
			scoreboard.x = 1000;
			addChild(scoreboard);
			
			obImage = new Obsidian();
			//addChild(obImage);
			
			cursor = new Cursor();
			addChild(cursor);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function spawnOutScreen():void
		{
			randomNumber = Math.random();
				
			if (randomNumber < 0.25){
				randomPosX = 1310;
				randomPosY = Math.random() * stage.stageHeight;
			}
			else if (randomNumber > 0.25 && randomNumber < 0.50){
				randomPosX = Math.random() * stage.stageWidth;
				randomPosY = 790;
			}
			else if (randomNumber > 0.50 && randomNumber < 0.75){
				randomPosX = -30;
				randomPosY = Math.random() * stage.stageHeight;
			}
			else if (randomNumber > 0.75){
				randomPosX = Math.random() * stage.stageWidth;
				randomPosY = -30;
			}
			
			//trace(randomNumber);
		}
		
		private function spawnSummoner():void 
		{
			var summoner:Summoner = new Summoner();
			enemies.push(summoner);
			addChild(summoner);
				
			spawnOutScreen();
			summoner.x = randomPosX;
			summoner.y = randomPosY;
				
			SummonerActive = true;
		}
		
		private function spawnSkeletons():void
		{
			if (SummonerActive == true)
			{	
				if (spawnCounter >= 160)
				{
					if (SkeletonCount <= 11)
					{
						var skelenton:Skeleton = new Skeleton();
						enemies.push(skelenton);
						
						addChild(skelenton);
						
						SkeletonCount ++;
						
						spawnOutScreen();
						skelenton.x = randomPosX; //summoner.x + Math.random() * 20;
						skelenton.y = randomPosY;//summoner.y + Math.random() * 20;
					}
				}
			}
		}
		
		
		private function loop(e:Event):void 
		{
			//trace(mouseX, mouseY);
			if (player != null)
			{
				distancePlayerObject = Maths.distanceBetween(player, wall);
				
				collisions();
				player.lives += 0.8;
				if (scoreboard.score == 15)
				{
					sum = true;
				}
				if (sum == true)
				{
					if (SummonerActive == false)
					{
						spawnSummoner();
					}
					if (SummonerActive == true)
					{
						spawnSkeletons();
					}
				}
				
				//spawning
				//spawnCounter += spawnRate;
				if (spawnCounter >= 160) {
					if (SummonerActive != true)
					{
						if (Math.random() <= 0.5)
						{
							var walker:Walker = new Walker();
							enemies.push(walker);
							addChild(walker);
							
							spawnOutScreen();
							
							walker.x = randomPosX;
							walker.y = randomPosY;
						}
						else
						{
							if (Math.random() <= 0.5)
							{
								var wildling:Wildling = new Wildling();
								enemies.push(wildling);
								addChild(wildling);
								
								spawnOutScreen();
								wildling.x = randomPosX;								
								wildling.addEventListener("onShoot", createArrows);
							}
							else 
							{
								walker = new Walker();
								enemies.push(walker);
								addChild(walker);
								
								spawnOutScreen();
								walker.x = randomPosX;
								walker.y = randomPosY;
							}
						}
						spawnCounter = 0;
						spawnRate += 0.02;
					}
				}
			}
		}
		
		private function collisions():void
		{
			
			if (player.hitTestPoint(obImage.x, obImage.y, true))
			{
				player.speed + 0.05 ;
				removeChild(obImage);
			}
			//-----collison enemies------
			for (var y:int = 0; y < enemies.length; y++ )
			{
				//collision enemies with player
				if (player.hitTestPoint(enemies[y].x, enemies[y].y, true))
				{
					toRemove = true;
					player.getDamaged(enemies[y].x,enemies[y].y);
					if (player.lives <= 0)
					{
						dead();
					}
				}
				//collision enemies with wall
				if (wall.hitTestObject(enemies[y]))
				{
					//enemies[y].wallCol(wall.x, wall.y,wall.width,wall.height);
				}
				
				//collision enemies with enemies
				for (var h:int = 0; h < enemies.length; h++ )
				{
					if (enemies[h].hitTestPoint(enemies[y].x, enemies[y].y, true) && enemies[h] != enemies[y])
					{
						enemies[h].enemyCol(enemies[h].x,enemies[h].y);
					}
				}
			}
			//collision player with wall
			//if (player.hitTestObject(wall))
			//{
				if (Maths.hitTest(player, wall) ==  true)
				{
					//player.x -= 10;
				}
				trace (Maths.hitTest(player, wall));
			//}
			
			//------collison Arrows------
			for (var i:int = 0; i < arrows.length; i++ )
			{
				var toRemove:Boolean = false;
					
				arrows[i].update();
				//collison enemies - arrows
				for (var k:int = 0; k < enemies.length; k++)
				{
					var enemyColCount:int;
					if (enemies[k].hitTestPoint(arrows[i].x, arrows[i].y, true))
					{
						enemyColCount = 0;
						//trace(enemyColCount);
						if (arrows[i].didDamage == false)
						{
							enemies[k].lives -= power;
							enemies[k].speed / 2;
							arrows[i].didDamage = true;
							//trace("enemy lives = " + enemies[k].lives);
						}
						if (enemies[k].lives <= 0)
						{
							
							trace(enemies[k].x , enemies[k].y);
							trace(obImage.x , obImage.y);
							
							if (SummonerActive == true)
							{
								SkeletonCount
								if (enemies[k] is Skeleton)
								{
									SkeletonCount--;
									player.lives += 1;
								}
								
								if (enemies[k] is Summoner)
								{
									SummonerActive = false;
									sum = false;
									
									obImage.x = enemies[k].x;
									obImage.y =	enemies[k].y;
									addChild(obImage);
								}
							}
							
							scoreboard.score += 1;
							
							enemies[k].destroy();
							removeChild(enemies[k]);
							enemies.splice(k, 1);
						}
						else
						{
							arrows[i].stuckInTarget(enemies[k], enemies[k].rotation );
						}
					} else {
						enemyColCount++;
						//trace(enemyColCount);
						if (arrows[i].didDamage == true && enemyColCount == enemies.length)
						{
							toRemove = true;
							//trace("no enemy col & did damage");
						}
					 
					}
				}
				//collision arrows with arrows
				for (var o:int = 0; o < arrows.length; o++ )
				{
					if (arrows[i].didDamage == false)
					{
						if (arrows[o].hitTestPoint(arrows[i].x, arrows[i].y, true) && arrows[o] != arrows[i])
						{
							arrows[o].arrowCol();
							arrows[i].arrowCol();
						}
					}
				}
				//collision arrows with wall
				if (arrows[i].hitTestObject(wall))
				{
					toRemove = true;
				}
				//collision player with arrows
				if (player.hitTestPoint(arrows[i].x, arrows[i].y, true))
				{
					if (arrows[i].didDamage == false)
					{
						toRemove = true;
						player.getDamaged(arrows[i].x,arrows[i].y);
						if (player.lives <= 0)
						{
							dead();
						}
					}
				}
				//als arrows buiten het veld zijn
				if (arrows[i].x > stage.stageWidth ||
				arrows[i].x < 0 ||
				arrows[i].y > stage.stageHeight ||
				arrows[i].y < 0)
				{
					toRemove = true;
				}				
				if (toRemove)//haalt de arrows weg
				{
					removeChild(arrows[i]);//verwijderen uit de display list
					arrows.splice(i, 1);//verwijderen uit de array geheugen
				}
			}
		}
		
		private function createArrows(e:ShootEvent):void 
		{
			if (player != null)
			{
				var r:Number;//rotation of arrows
				var s:Number;//speed of arrows
				//trace(e.shooter.name);
				if (e.shooter.name == "instance11")//if player shoots. if this doesnt work, the instance name is probably not right, use trace(e.shooter.name);
				{
					r = e.shooter.rotation * 2 + (Math.ceil(Math.random() * (player.accuracy - -player.accuracy)) + -player.accuracy);
					s = 13 - player.accuracy / 2; //schiet harder als je accuacy beter is, werkt niet goed atm ik ga t fixen dus niet aanpassen
					//trace("main rot" + player.rotation);
				}
				else//if enemies shoot
				{
					r = e.shooter.rotation /*+ e.shooter.rotation*/;
					s = 8;
				}
				var tPos:Point = new Point(e.shooter.x, e.shooter.y);
				var b:Arrow = new Arrow(r,tPos,s);//hier wordt de rotatie van Arrow berekend		
				arrows.push(b);			
				addChild(b);
				b.scaleX = b.scaleY = 0.1;
			}
		}
		public function dead():void
		{
			player.destroy();
			removeChild(player);
			for (var v:int = 0; v < enemies.length; v++ )
			{
				removeChild(enemies[v]);
			}
			for (var c:int = 0; c < arrows.length; c++ )
			{
				removeChild(arrows[c]);
			}
			mainretry = new mainRetry();
			addChild(mainretry);
		}
	}
}