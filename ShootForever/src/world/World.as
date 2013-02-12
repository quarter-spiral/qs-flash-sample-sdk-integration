package world
{	
	import flash.geom.Rectangle;
	
	import math.RandomUtils;
	import math.Vec2;
	
	import starling.display.DisplayObjectContainer;
	
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
		
		//Logical boundaries of game world. Objects outside these bounds should be removed
		private var worldBounds:Rectangle;
		
		public var isPlayerAlive:Boolean = true;
		
		private var currTime:Number = 0;
		private var lastChestSpawnTime:Number = 0;
		private var lastEnemySpawnTime:Number = 0;
		private var lastStarSpawnTime:Number = 0;
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
		
		//Temp util objects to avoid a bunch of object creations on each frame
		private var playerMouseDelta:Vec2;
		
		//Object pools (to avoid lots of allocations & reuse game objects)
		private var bulletPool:BulletPool;
		private var enemyPool:EnemyPool;
		private var xpPool:XpPool;
		private var starPool:StarPool;
		
		//Creates a new game world with given container for the graphical images of game objects
		public function World(imageContainer:DisplayObjectContainer, bgLayer:DisplayObjectContainer)
		{
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
		}
		
		//Prepares world for a new game instance
		public function init(playerInfo:PlayerInfo):void {
			clear(); //remove existing world objects
			
			isPlayerAlive = true;
			currTime = 0;
			lastChestSpawnTime = 0;
			lastEnemySpawnTime = 0;
			lastStarSpawnTime = 0;
			playerDeathTime = 0;
			gameInfo = new GameInfo();
			gameInfo.init(playerInfo);
			
			//Create player at the bottom of the screen
			player = new Player(this, playerInfo.upgrades);
			player.pos.x = Constants.GameWidth/2;
			player.pos.y = Constants.GameHeight - player.image.height/2- 30;
			addObjectImage(player);
			
			//Give initial # of bombs
			gameInfo.currBombs = 3;
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
		
		//Updates logical gameplay elements of world
		public function update(dt:Number):void {
			currTime += dt;
			
			//INPUT: Move player toward mouse position
			if (isPlayerAlive) {
				//TODO: faster/slower player motion based on current upgrades?
				
				player.pos.x = mousePos.x;
				if (player.pos.x > Constants.GameWidth - Constants.PLAYER_WIDTH/2) player.pos.x = Constants.GameWidth - Constants.PLAYER_WIDTH/2;
				if (player.pos.y < Constants.PLAYER_WIDTH/2) player.pos.x = Constants.PLAYER_WIDTH/2;
			}
			
			updatePlayerShooting();
			updateEnemySpawning();
			updateChestSpawning();
			updateStarSpawning();
			
			//Update player first
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
			
			//Then the bg stars
			var numStars:int = stars.length;
			for (i = 0; i < numStars; i++) {
				stars[i].update(dt);
				
				//Remove xp once no longer active
				if (stars[i].alive == false) {
					removeStar(i);
					i--; numStars--;
				}
			}
			
			//Use bomb if able
			if (mouseClicked) {
				mouseClicked = false;
				usePlayerBomb();
			}
			
			updateEnemyCollisions();
			updatePlayerCollisions();
		}
		
		//Spawns shots from player periodically
		protected function updatePlayerShooting():void {
			//If enough time has passed, spawn a new shot
			var timeSinceShot:Number = currTime - player.lastShotTime;
			if (timeSinceShot > player.getTimeBetweenShots())
				spawnPlayerBullet();
		}
		
		//Creates enemies as necessary during main game loop
		protected function updateEnemySpawning():void {
			//PLACEHOLDER BASIC: Spawn an enemy every second or so
			var timeSinceEnemySpawn:Number = currTime - lastEnemySpawnTime;
			if (timeSinceEnemySpawn > 1.0) {
				//PLACEHOLDER: Spawn random enemy types
				var NumEnemyTypes:int = Constants.ENEMY_PROPERTIES.length;
				var enemyType:int = RandomUtils.randomInt(1, NumEnemyTypes-1);
				spawnEnemy(enemyType);
			}
		}
		
		protected function updateChestSpawning():void {
			//PLACEHOLDER BASIC: Spawn a chest every so often
			var timeSinceChestSpawn:Number = currTime - lastChestSpawnTime;
			if (timeSinceChestSpawn > 10.0) {
				spawnEnemy(Constants.TREASURE_CHEST_ID);
			}
		}
		
		protected function updateStarSpawning():void {
			//PLACEHOLDER BASIC: Spawn a chest every so often
			var timeSinceStarSpawn:Number = currTime - lastStarSpawnTime;
			if (timeSinceStarSpawn > 1.0* Math.random()) {
				lastStarSpawnTime = currTime;
				spawnStar();
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
						enemies[i].currHealth -= playerBullets[j].damage;
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
				
				//Player-XP collisions
				for (i = 0; i < numXpObjs; i++) {
					if (xpObjs[i].alive == false) continue;
					
					if (player.checkCollisionRect(xpObjs[i].boundBox)) {
						//Remove xp
						xpObjs[i].alive = false;
						
						
						awardXpToPlayer(xpObjs[i].getProperties().xpAmount);
						
						//TODO: Animate xp grab with pretty particles
					}
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
		
		public function spawnPlayerBullet():void {
			player.lastShotTime = currTime;	
			
			var bullet:Bullet = bulletPool.checkOut();
			bullet.alive = true;
			bullet.size.setVals(player.shotRadius, player.shotRadius);
			bullet.damage = player.shotDamage;
			bullet.pos.setValsFrom(player.pos);
			bullet.vel.setVals(0, -player.shotSpeed); //negative so we move updwards
			addObjectImage(bullet);
			
			playerBullets.push(bullet);
		}
		
		public function removePlayerBullet(bulletIdx:int):void {
			var removedBullet:Bullet = playerBullets.splice(bulletIdx, 1)[0];
			if (removedBullet.image && removedBullet.image.parent) 
				removedBullet.image.parent.removeChild(removedBullet.image);
			bulletPool.checkIn(removedBullet);
		}
		
		public function spawnEnemy(typeNum:int):void {
			if (typeNum == Constants.TREASURE_CHEST_ID)
				lastChestSpawnTime = currTime;
			else
				lastEnemySpawnTime = currTime;
			
			var enemy:Enemy = enemyPool.checkOut();
			enemy.alive = true;
			enemy.liveTime = 0;
			enemy.hasDarted = false;
			enemy.setType(typeNum);
			
			//Set enemy spawn position based on type
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
					break;
				}
				case Constants.HORIZONTAL_ENEMY_ID:
				case Constants.DART_HORIZONTAL_ENEMY_ID:
					//Start of left side of screen
					startYPct = 0.3 + Math.random()*0.1;
					enemy.setStartPos(-enemy.boundBox.width/2, startYPct * Constants.GameHeight);	
					break;
			}
			
			enemy.setInitialVelocity();
			
			addObjectImage(enemy);
			enemies.push(enemy);
		}
		
		public function removeEnemy(enemyIdx:int):void {
			var removedEnemy:Enemy = enemies.splice(enemyIdx, 1)[0];
			if (removedEnemy.image && removedEnemy.image.parent) 
				removedEnemy.image.parent.removeChild(removedEnemy.image);
			enemyPool.checkIn(removedEnemy);
		}
		
		public function spawnXpObj(props:XpProperties, startPos : Vec2):void {			
			var xpObj:XpObject = xpPool.checkOut();
			xpObj.alive = true;
			xpObj.setProperties(props);
			xpObj.pos.setValsFrom(startPos);
			//Start with a random "upward" velocity
			xpObj.vel.setVals((Math.random() - 0.5) * Constants.GameWidth*0.25, -100);
			
			addObjectImage(xpObj);
			xpObjs.push(xpObj);
		}
		
		public function removeXpObj(xpIdx:int):void {
			var removedXp:XpObject = xpObjs.splice(xpIdx, 1)[0];
			if (removedXp.image && removedXp.image.parent) 
				removedXp.image.parent.removeChild(removedXp.image);
			xpPool.checkIn(removedXp);
		}
		
		public function spawnStar():void {			
			var star:BackgroundStar = starPool.checkOut();
			star.alive = true;
			star.pos.setVals(Constants.GameWidth * Math.random(), -2);
			star.vel.setVals(0, 50 + 200 * Math.random());
			
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
			gameInfo.ingameScore += gameInfo.currMultiplier * enemy.props.killScore;
			
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
				gameInfo.ingameLevelups++;
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
			player.updateGraphics();
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
			//Not much to do.... most is handled by removeBullet()
		}
		
		private function createEnemy():Enemy {
			var enemy:Enemy = new Enemy(this);
			return enemy;
		}
		
		private function cleanEnemy(enemy:Enemy):void {
			//Not much to do.... most is handled by removeEnemy()
		}
		
		private function createXpObj():XpObject {
			var xpObj:XpObject = new XpObject(this);
			return xpObj;
		}
		
		private function cleanXpObj(xpObj:XpObject):void {
			//Not much to do.... most is handled by removeXpObj()
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