package world
{	
	import flash.geom.Rectangle;
	
	import math.RandomUtils;
	import math.Vec2;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	import tuning.Constants;
	
	import world.GameObject;
	import world.pools.BulletPool;
	import world.pools.EnemyPool;
	import world.pools.StarPool;
	import world.pools.XpPool;
	
	/** Logical game world that is updated every frame */
	public class World
	{
		public var gameInfo:GameInfo;
		
		public var mousePos:Vec2;
		public var mouseClicked:Boolean; 	//true if player clicked mouse and we need to handle it
		
		//Sets whether main gameplay loop should be run (false on most game screens,
		//but we run things like stars in the bg, etc)
		public var mainGameRunning:Boolean;
		
		//Logical boundaries of game world. Objects outside these bounds should be removed
		private var worldBounds:Rectangle;
		
		public var isPlayerAlive:Boolean = true;
		
		private var currTime:Number = 0;
		private var playerDeathTime:Number = 0;
		
		//Render layers
		private var imageContainer:DisplayObjectContainer;
		private var bgLayer:DisplayObjectContainer;
		
		//The main player object in the world
		private var player:Player; 	
		//All active enemies in the world
		private var enemies:Vector.<Enemy>;
		//All active player-spawned bullets in the world
		private var playerBullets:Vector.<Bullet>;
		//All active enemy-spawned bullets in the world
		private var enemyBullets:Vector.<Bullet>;
		//All active XP objects in the world
		private var xpObjs:Vector.<XpObject>;
		//All active background stars in the world
		private var stars:Vector.<BackgroundStar>;
		
		//Handles pretty much all spawning logic
		private var flowMan:GameflowManager;
		
		//Temp util objects to avoid a bunch of object creations on each frame
		private var playerMouseDelta:Vec2;
		
		//Object pools (to avoid lots of allocations & reuse game objects)
		private var bulletPool:BulletPool;
		private var enemyPool:EnemyPool;
		private var xpPool:XpPool;
		private var starPool:StarPool;
		
		public function get FlowMan():GameflowManager {return flowMan;}
		
		//Creates a new game world with given container for the graphical images of game objects
		//Note thate game is not in "running" mode by default (use "startMainGame()" for this)
		public function World(imageContainer:DisplayObjectContainer, bgLayer:DisplayObjectContainer)
		{
			mainGameRunning = false;
			
			mousePos = new Vec2();
			mouseClicked = false;
			
			//Note that world bounds are a bit looser than actual game size
			worldBounds = new Rectangle();
			worldBounds.setTo(-5, -5, Constants.GameWidth + 5, Constants.GameHeight + 5);
			
			this.imageContainer = imageContainer;
			this.bgLayer = bgLayer;
			
			//Init object lists
			enemies = new Vector.<Enemy>();
			playerBullets = new Vector.<Bullet>();
			enemyBullets = new Vector.<Bullet>();
			xpObjs = new Vector.<XpObject>();
			stars = new Vector.<BackgroundStar>();
			
			playerMouseDelta = new Vec2();
			
			bulletPool = new BulletPool(createBullet, cleanBullet, 20, 200);
			enemyPool = new EnemyPool(createEnemy, cleanEnemy, 20, 200);
			xpPool = new XpPool(createXpObj, cleanXpObj, 30, 200);
			starPool = new StarPool(createStar, cleanStar, 50, 200);
			
			flowMan = new GameflowManager(this);
		}
		
		//Prepares world for a new game instance
		public function startMainGame(playerInfo:PlayerInfo):void {
			clear(); //remove existing world objects
			
			mainGameRunning = true;
			
			currTime = 0;
			
			flowMan.reset();
			
			isPlayerAlive = true;
			currTime = 0;
			playerDeathTime = 0;
			gameInfo = new GameInfo();
			gameInfo.init(playerInfo);
			
			//Create player at the bottom of the screen
			player = new Player(this, playerInfo.upgrades);
			player.pos.x = Constants.GameWidth/2;
			player.pos.y = Constants.GameHeight - player.ShipHeight/2- 30;
			addObjectImage(player);
			
			//Give initial # of bombs
			gameInfo.currBombs = Constants.PLAYER_START_BOMBS_BASE + Constants.PLAYER_START_BOMBS_UPGRADE * playerInfo.upgrades.startBombsLevel;
		}
		
		public function endMainGame():void {
			mainGameRunning = false;
			
			var i:int = 0;
			
			//Remove main game stuff, like player, bullets, etc
			//Note: For now, keeping enemies around... just seems right...
			//Then enemies
			
			removePlayer();
			removeAllXp();
			removeAllBullets();
			removeAllEnemies();
		}
		
		//Adds given game object's image to this world so it may be updated & rendered
		public function addObjectImage(object:GameObject, addToBG:Boolean = false):void {
			//Add object's image to rendered scene
			if (object.image) {
				if (!addToBG && imageContainer)
					imageContainer.addChild(object.image);
				else if (addToBG && bgLayer)
					bgLayer.addChild(object.image);
			}
			
			object.updateBoundingBox(); //init the bound box pos
		}
		
		public function getWorldBounds():Rectangle {
			return worldBounds;
		}
		
		public function getPlayer():Player {
			return player;
		}
		
		//Returns current world runtime, in seconds, starting at 0 when this world was first init'd
		//NOTE: This is NOT necessarily the same as the player live time (likely greater)
		public function getWorldTime():Number {
			return currTime;
		}
		
		//Returns amount of time player has been alive in current game run
		//Note that this may be different from total game runtime (getTime())
		public function getPlayerLiveTime():Number {
			if (gameInfo)
				return gameInfo.getPlayerLiveTime();
			return 0;
		}
		
		//Updates logical gameplay elements of world
		public function updateLogic(dt:Number):void {
			currTime += dt;
			
			if (mainGameRunning) {
				//INPUT: Move player toward mouse position
				if (isPlayerAlive) {
					gameInfo.playerLiveTime = currTime;
					
					//TODO: faster/slower player motion based on current upgrades?
					
					if (player) {
						player.pos.x = mousePos.x;
						if (player.pos.x > Constants.GameWidth - Constants.PLAYER_WIDTH/2) player.pos.x = Constants.GameWidth - Constants.PLAYER_WIDTH/2;
						if (player.pos.y < Constants.PLAYER_WIDTH/2) player.pos.x = Constants.PLAYER_WIDTH/2;
					}
				}
				
				//Use bomb if able
				if (mouseClicked) {
					mouseClicked = false;
					usePlayerBomb();
				}
				
				updatePlayerShooting();
				flowMan.updateMobSpawning();
				
				//Update player first
				if (player)
					player.update(dt);
				
				var i:int = 0;
				
				//Then enemies
				var numEnemies:int = enemies.length;
				for (i = 0; i < numEnemies; i++) {
					enemies[i].update(dt);
					
					//Remove enemy once dead
					if (enemies[i].alive == false) {
						removeEnemy((i));
						i--; numEnemies--;
					}
				}
				
				//Then player bullets
				var numPlayerBullets:int = playerBullets.length;
				for (i = 0; i < numPlayerBullets; i++) {
					playerBullets[i].update(dt);
					
					if (playerBullets[i].alive == false) {
						removePlayerBullet(i);
						i--; numPlayerBullets--;
					}
				}
				
				//Then enemy bullets
				var numEnemyBullets:int = enemyBullets.length;
				for (i = 0; i < numEnemyBullets; i++) {
					enemyBullets[i].update(dt);
					
					//TODO: If bullet hit something, remove it (and animated removal)
				}
				
				//Then falling XP
				var numXpObjs:int = xpObjs.length;
				for (i = 0; i < numXpObjs; i++) {
					xpObjs[i].update(dt);
					
					//Remove xp once no longer active
					if (xpObjs[i].alive == false) {
						removeXpObj(i);
						i--; numXpObjs--;
					}
				}
				
				updateEnemyCollisions();
				updatePlayerCollisions();
			}
			
			//Update bg stars (note that we run these even when mainGame isn't running)
			flowMan.updateStarSpawning();
			var numStars:int = stars.length;
			for (i = 0; i < numStars; i++) {
				stars[i].update(dt);
				
				//Remove xp once no longer active
				if (stars[i].alive == false) {
					removeStar(i);
					i--; numStars--;
				}
			}
		}
		
		//Spawns shots from player periodically
		protected function updatePlayerShooting():void {
			//If enough time has passed, spawn a new shot
			var timeSinceShot:Number = currTime - player.lastShotTime;
			if (timeSinceShot > player.getTimeBetweenShots()) {
				firePlayerBullets();
			}
		}
		
		//Check for enemy's being hit by player bullets
		//If hit occurs, hurt the enemy and check if it needs to die
		protected function updateEnemyCollisions():void {
			var numEnemies:int = enemies.length;
			var numPlayerBullets:int = playerBullets.length;
			
			//For lack of an acceleration data structure, do a full m*n intersection of everything...
			for (var i:int = 0; i < numEnemies; i++) {
				if (enemies[i].alive == false) continue;
				for (var j:int = 0; j < numPlayerBullets; j++) {
					if (playerBullets[j].alive == false) continue;
					
					if (enemies[i].boundBox.intersects(playerBullets[j].boundBox)) {
						//Remove bullet
						playerBullets[j].alive = false;
						
						//Hurt enemy, or kill if health is 0
						enemies[i].currHealth -= playerBullets[j].getDamage();
						if (enemies[i].currHealth <= 0) {
							enemies[i].currHealth = 0;
							enemies[i].alive = false;
							
							//Award points to player
							rewardPlayerForEnemyKill(enemies[i]);
							
							//TODO: Animate hurt/death with pretty particles
						}
					}
				}
			}
		}
		
		//Check for player being hit by enemies, enemy bullets, or falling XP
		//If hit occurs, run appropriate response
		protected function updatePlayerCollisions():void {
			if (isPlayerAlive) {
				var numEnemies:int = enemies.length;
				var numEnemyBullets:int = enemyBullets.length;
				var numXpObjs:int = xpObjs.length;
				
				var i:int;
				
				//Player-enemy collisions
				for (i = 0; i < numEnemies; i++) {
					if (enemies[i].alive == false) continue;
			
					if (player.checkCollisionRect(enemies[i].boundBox)) {
						//Remove enemy
						enemies[i].alive = false;
							
						killPlayer(true);
					}
				}
				
				//TODO: Player-enemy-bullet collisions
				
				//Player-XP collisions (also, magnet pull)
				for (i = 0; i < numXpObjs; i++) {
					if (xpObjs[i].alive == false) continue;
					
					//Check for player collision
					if (player.checkCollisionRect(xpObjs[i].boundBox)) {
						xpObjs[i].alive = false;
						awardXpToPlayer(xpObjs[i].getProperties().xpAmount);
						
						//TODO: Animate xp grab with pretty particles
					}
					
					//Apply magnetic force, if necessary
					if (xpObjs[i].alive)
						player.checkAndApplyMagnet(xpObjs[i]);
				}
			}
		}
		
		public function usePlayerBomb():void {
			if (gameInfo.currBombs > 0) {
				//Kill all enemies
				gameInfo.currBombs--;
				var numEnemies:int = enemies.length;
				for (var i:int = 0; i < numEnemies; i++) {
					enemies[i].alive = false;
					
					//Award points to player (except for treasure chest!)
					//Note that bombs explode treasure chests, but don't give their rewards
					if (enemies[i].enemyType != Constants.TREASURE_CHEST_ID)
						rewardPlayerForEnemyKill(enemies[i]);
					
					//TODO: Spawn some pretty enemy-dead animation
				}
			}
		}
		
		//Runs the logic for a player firing action (spawns 1 or more player bullets) 
		public function firePlayerBullets():void {
			player.lastShotTime = currTime;	
			
			//Create # of bullets based on player's shot number level
			//We could define bullet spawn locations using a one-size-fits-all mathematical equation,
			//but using a per-case switch gives us flexibility to make custom patterns per level if we want
			var pwidth:Number = player.ShipWidth;
			switch (player.getUpgrades().shotNumLevel) {
				case 0:	
					spawnPlayerBullet(0,0);
					break
				case 1:
					spawnPlayerBullet(-0.15 * pwidth, 0);
					spawnPlayerBullet(0.15 * pwidth, 0);
					break;
				case 2:
					spawnPlayerBullet(-0.2 * pwidth, 0);
					spawnPlayerBullet(0, 0);
					spawnPlayerBullet(0.2 * pwidth, 0);
					break;
				case 3:
					spawnPlayerBullet(-0.3 * pwidth, 0);
					spawnPlayerBullet(-0.1 * pwidth, 0);
					spawnPlayerBullet(0.1 * pwidth, 0);
					spawnPlayerBullet(0.3 * pwidth, 0);
					break;
				case 4:
					spawnPlayerBullet(-0.3 * pwidth, 0);
					spawnPlayerBullet(-0.15 * pwidth, 0);
					spawnPlayerBullet(0, 0);
					spawnPlayerBullet(0.15 * pwidth, 0);
					spawnPlayerBullet(0.3 * pwidth, 0);
					break;
				default:
					//In the general case, spawn n+1 bullets in a row
					var numBulletsToSpawn:int = player.getUpgrades().shotNumLevel + 1;
					var bulletX:Number = 0;
					var dx:Number = pwidth / (numBulletsToSpawn + 1);
					for (var i:int = 0; i < numBulletsToSpawn; i++) {
						spawnPlayerBullet(bulletX, 0);
						bulletX += dx;
					}
					break
			}
		}
		
		//Creates a new bullet fired by player, with starting position offset from player's position by given values
		public function spawnPlayerBullet(playerXOffset:Number, playerYOffset:Number):void {
			var bullet:Bullet = bulletPool.checkOut();
			bullet.alive = true;
			bullet.size.setVals(player.shotRadius, player.shotRadius);
			bullet.setDamageLevel(player.shotDamage, player.getUpgrades().shotDamageLevel);
			bullet.pos.setValsFrom(player.pos);
			bullet.pos.x += playerXOffset;
			bullet.pos.y += playerYOffset;
			bullet.vel.setVals(0, -player.shotSpeed); //negative so we move updwards
			addObjectImage(bullet);
			
			playerBullets.push(bullet);
		}
		
		public function spawnObject(typeNum:int):Enemy {
			var enemy:Enemy = enemyPool.checkOut();
			enemy.alive = true;
			enemy.liveTime = 0;
			enemy.hasDarted = false;
			enemy.setType(typeNum);
			
			//Set enemy spawn initial variables based on type
			var startXPct:Number = 0;
			var startYPct:Number = 0;
			switch (typeNum) {
				case Constants.TREASURE_CHEST_ID:
					startYPct = 0.2 + Math.random()*0.1;
					enemy.setStartPos(-enemy.boundBox.width/2, startYPct * Constants.GameHeight);	
					break;
				case Constants.DART_ENEMY_ID:
				case Constants.SINE_WAVE_ENEMY_ID:
				default: {
					startXPct = 0.3 + Math.random()*0.4;
					enemy.setStartPos(startXPct * Constants.GameWidth, -enemy.boundBox.height/2);	
					break;
				}
				case Constants.BASIC_ANGLED_ENEMY_ID: {
					startXPct = 0.3 + Math.random()*0.4;
					enemy.setStartPos(startXPct * Constants.GameWidth, -enemy.boundBox.height/2);
					enemy.moveType = math.RandomUtils.randomInt(0,4);
					break;
				}
				case Constants.HORIZONTAL_ENEMY_ID:
				case Constants.DART_HORIZONTAL_ENEMY_ID:
					//Start of left side of screen
					startYPct = 0.3 + Math.random()*0.1;
					enemy.setStartPos(-enemy.boundBox.width/2, startYPct * Constants.GameHeight);	
					break;
			}
			
			//enemy.setInitialVelocity(); //TEST veloticy is only set by enemy creation
			
			addObjectImage(enemy);
			enemies.push(enemy);
			
			return enemy;
		}
		
		
		//Removes player avatar from game
		public function removePlayer():void {
			if (player) {
				if (player.image && player.image.parent)
					player.image.parent.removeChild(player.image);
				player.dispose();
				player = null;
			}
		}
		
		public function removePlayerBullet(bulletIdx:int):void {
			var removedBullet:Bullet = playerBullets.splice(bulletIdx, 1)[0];
			bulletPool.checkIn(removedBullet);
		}
		
		//Removes all bullets (more efficiently than removing one-by-one)
		public function removeAllBullets():void {
			var i:int = 0;
			
			var numPlayerBullets:int = playerBullets.length;
			for (i = 0; i < numPlayerBullets; i++)
				bulletPool.checkIn(playerBullets[i]);
			playerBullets.length = 0;
			
			var numEnemyBullets:int = enemyBullets.length;
			for (i = 0; i < numEnemyBullets; i++)
				bulletPool.checkIn(enemyBullets[i]);
			enemyBullets.length = 0;
		}
		
		public function removeEnemy(enemyIdx:int):void {
			var removedEnemy:Enemy = enemies.splice(enemyIdx, 1)[0];
			enemyPool.checkIn(removedEnemy);
		}
		
		//Removes all enemies (more efficiently than removing one-by-one)
		public function removeAllEnemies():void {
			var i:int = 0;
			var numEnemies:int = enemies.length;
			for (i = 0; i < numEnemies; i++)
				enemyPool.checkIn(enemies[i]);
			enemies.length = 0;
		}
		
		public function spawnXpObj(props:XpProperties, startPos : Vec2):void {			
			var xpObj:XpObject = xpPool.checkOut();
			xpObj.alive = true;
			xpObj.setProperties(props);
			xpObj.pos.setValsFrom(startPos);
			//Start with a random "upward" velocity
			xpObj.vel.setVals((Math.random() - 0.5) * Constants.GameWidth*0.5, -200-Math.random()*100);
			
			addObjectImage(xpObj);
			xpObjs.push(xpObj);
		}
		
		public function removeXpObj(xpIdx:int):void {
			var removedXp:XpObject = xpObjs.splice(xpIdx, 1)[0];
			xpPool.checkIn(removedXp);
		}
		
		//Removes all xp (more efficiently than removing one-by-one)
		public function removeAllXp():void {
			var i:int = 0;
			var numXpObjs:int = xpObjs.length;
			for (i = 0; i < numXpObjs; i++)
				xpPool.checkIn(xpObjs[i]);
			xpObjs.length = 0;
		}
		
		public function spawnStar():void {			
			var star:BackgroundStar = starPool.checkOut();
			star.alive = true;
			star.pos.setVals(Constants.GameWidth * Math.random(), -2);
			star.vel.setVals(0, 300 + 500 * Math.random());
			
			addObjectImage(star);
			stars.push(star);
		}
		
		public function removeStar(idx:int):void {
			var removedStar:BackgroundStar = stars.splice(idx, 1)[0];
			if (removedStar.image && removedStar.image.parent) 
				removedStar.image.parent.removeChild(removedStar.image);
			starPool.checkIn(removedStar);
		}
		
		public function rewardPlayerForEnemyKill(enemy:Enemy):void {			
			//Add kill score
			//DISABLED FOR NEW "SuperHex" mode. 
			//gameInfo.currScore += enemy.props.killScore;
			
			//Spawn falling XP
			for (var i:int = 0; i < enemy.props.killXpCoins; i++) {
				var xpProps:XpProperties = Constants.getRandomXpProps();
				spawnXpObj(xpProps, enemy.pos);
			}
			
			//If treasure chest, restore a bomb
			//TODO: other treasure chest functionality
			if (enemy.enemyType == Constants.TREASURE_CHEST_ID)
				gameInfo.currBombs++;
		}
		
		public function awardXpToPlayer(amount:int):void {
			gameInfo.ingameXp += amount;
			//Record an in-game levelup(s) if we have enough xp
			while (gameInfo.getXp() >= Constants.getXpForLevel(gameInfo.getLevel()+1)) {
				flowMan.levelupPlayer();
			}
		}
		
		public function killPlayer(animate:Boolean):void {
			isPlayerAlive = false;
			playerDeathTime = currTime;
			
			//TODO: Animate hurt/death with pretty particles
			if (animate) { 
				
			}
		}
		
		//Updates graphical elements of objects in world
		public function updateGraphics():void {
			var i:int;
			if (player) player.updateGraphics();
			var numEnemies:int = enemies.length;
			for (i = 0; i < numEnemies; i++)
				enemies[i].updateGraphics();
			var numPlayerBullets:int = playerBullets.length;
			for (i = 0; i < numPlayerBullets; i++)
				playerBullets[i].updateGraphics();
			var numEnemyBullets:int = enemyBullets.length;
			for (i = 0; i < numEnemyBullets; i++)
				enemyBullets[i].updateGraphics();
			var numXpObjs:int = xpObjs.length;
			for (i = 0; i < numXpObjs; i++)
				xpObjs[i].updateGraphics();
			var numStars:int = stars.length;
			for (i = 0; i < numStars; i++)
				stars[i].updateGraphics();
		}
		
		//Removes everything currently in the world
		public function clear():void {
			var i:int = 0;
			if (player) player.dispose();
			var numEnemies:int = enemies.length;
			for (i = 0; i < numEnemies; i++)
				enemies[i].dispose();
			var numPlayerBullets:int = playerBullets.length;
			for (i = 0; i < numPlayerBullets; i++)
				playerBullets[i].dispose();
			var numEnemyBullets:int = enemyBullets.length;
			for (i = 0; i < numEnemyBullets; i++)
				enemyBullets[i].dispose();
			
			player = null;
			enemies.length = 0;
			playerBullets.length = 0;
			enemyBullets.length = 0;
		}
		
		//Disposes of the resources for this world
		public function dispose():void  {
			clear();
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		//Object pool creators/cleaners
		///////////////////////////////////////////////////////////////////////////////////////////////
		private function createBullet():Bullet {
			var bullet:Bullet = new Bullet(this);
			return bullet;
		}
		
		private function cleanBullet(bullet:Bullet):void {
			if (bullet.image && bullet.image.parent) 
				bullet.image.parent.removeChild(bullet.image);
		}
		
		private function createEnemy():Enemy {
			var enemy:Enemy = new Enemy(this);
			return enemy;
		}
		
		private function cleanEnemy(enemy:Enemy):void {
			if (enemy.image && enemy.image.parent) 
				enemy.image.parent.removeChild(enemy.image);
		}
		
		private function createXpObj():XpObject {
			var xpObj:XpObject = new XpObject(this);
			return xpObj;
		}
		
		private function cleanXpObj(xpObj:XpObject):void {
			if (xpObj.image && xpObj.image.parent) 
				xpObj.image.parent.removeChild(xpObj.image);
		}
		
		private function createStar():BackgroundStar {
			var star:BackgroundStar = new BackgroundStar(this);
			return star;
		}
		
		private function cleanStar(star:BackgroundStar):void {
			//Not much to do.... most is handled by cleanStar()
		}
		///////////////////////////////////////////////////////////////////////////////////////////////
	}
}