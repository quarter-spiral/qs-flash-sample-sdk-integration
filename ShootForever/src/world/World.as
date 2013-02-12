package world
{	
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.DisplayObjectContainer;
	
	import world.GameObject;
	import world.pools.BulletPool;
	import world.pools.EnemyPool;
	
	/** Logical game world that is updated every frame */
	public class World
	{
		public var mousePos:Vec2;
		public var mouseClicked:Boolean; 	//true if player clicked mouse and we need to handle it
		
		//Logical boundaries of game world. Objects outside these bounds should be removed
		private var worldBounds:Rectangle;
		
		private var currTime:Number = 0;
		private var lastEnemySpawnTime:Number = 0;
		
		//Player traits
		private var imageContainer:DisplayObjectContainer;
		
		//The main player object in the world
		private var player:Player; 	
		//All active enemies in the world
		private var enemies:Vector.<Enemy>;
		//All active player-spawned bullets in the world
		private var playerBullets:Vector.<Bullet>;
		//All active enemy-spawned bullets in the world
		private var enemyBullets:Vector.<Bullet>;
		
		//Temp util objects to avoid a bunch of object creations on each frame
		private var playerMouseDelta:Vec2;
		
		//Object pools (to avoid lots of allocations & reuse game objects)
		private var bulletPool:BulletPool;
		private var enemyPool:EnemyPool;
		
		//Creates a new game world with given container for the graphical images of game objects
		public function World(imageContainer:DisplayObjectContainer)
		{
			mousePos = new Vec2();
			mouseClicked = false;
			
			worldBounds = new Rectangle();
			worldBounds.setTo(0, 0, Constants.GameWidth, Constants.GameHeight);
			
			this.imageContainer = imageContainer;
			
			//Init object lists
			enemies = new Vector.<Enemy>();
			playerBullets = new Vector.<Bullet>();
			enemyBullets = new Vector.<Bullet>();
			
			playerMouseDelta = new Vec2();
			
			bulletPool = new BulletPool(createBullet, cleanBullet);
			enemyPool = new EnemyPool(createEnemy, cleanEnemy);
		}
		
		//Prepares world for a new game instance
		public function init(playerInfo:PlayerInfo):void {
			clear(); //remove existing world objects
			
			currTime = 0;
			lastEnemySpawnTime = 0;
			
			//Create player at the bottom of the screen
			player = new Player(this, playerInfo.upgrades);
			player.pos.x = Constants.GameWidth/2;
			player.pos.y = Constants.GameHeight - player.image.height/2;
			addObjectImage(player);
		}
		
		//Adds given game object's image to this world so it may be updated & rendered
		public function addObjectImage(object:GameObject):void {
			//Add object's image to rendered scene
			if (imageContainer && object.image)
				imageContainer.addChild(object.image);
		}
		
		public function getWorldBounds():Rectangle {
			return worldBounds;
		}
		
		//Updates logical gameplay elements of world
		public function update(dt:Number):void {
			currTime += dt;
			
			//INPUT: Move player toward mouse position
//			playerMouseDelta.setValsFrom(mousePos);
//			playerMouseDelta.sub(player.pos);
			player.pos.x = mousePos.x;
			if (player.pos.x > Constants.GameWidth - Constants.PLAYER_RADIUS/2) player.pos.x = Constants.GameWidth - Constants.PLAYER_RADIUS/2;
			if (player.pos.y < Constants.PLAYER_RADIUS/2) player.pos.x = Constants.PLAYER_RADIUS/2;
			
			updatePlayerShooting();
			updateEnemySpawning();
			
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
			var numEnemyBullets:int = playerBullets.length;
			for (i = 0; i < numPlayerBullets; i++) {
				playerBullets[i].update(dt);
				
				//TODO: If bullet hit something, remove it (and animated removal)
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
				spawnEnemy(0);
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
							
							//TODO: Animate hurt/death with pretty particles
						}
					}
				}
			}
		}
		
		
		//Check for player being hit by enemies, enemy bullets, or falling XP
		//If hit occurs, run appropriate response
		protected function updatePlayerCollisions():void {
			var numEnemies:int = enemies.length;
			var numEnemyBullets:int = enemyBullets.length;
			//var numXP //TODO, once we have falling XP
			
			//Player-enemy collisions
			for (var i:int = 0; i < numEnemies; i++) {
				if (enemies[i].alive == false) continue;
		
				if (player.checkCollisionRect(enemies[i].boundBox)) {
					//Remove enemy
					enemies[i].alive = false;
						
					//TODO: Hurt or kill player
					//TODO: Animate hurt/death with pretty particles
				}
			}
			
			//TODO: Player-enemy-bullet collisions
			
			//TODO: Player-XP collisions
		}
		
		public function spawnPlayerBullet():void {
			player.lastShotTime = currTime;	
			
			var bullet:Bullet = bulletPool.checkOut();
			bullet.alive = true;
			bullet.radius = player.shotRadius;
			bullet.damage = player.shotDamage;
			bullet.pos.setValsFrom(player.pos);
			bullet.updateBoundingBox(); //init the bound box pos
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
			lastEnemySpawnTime = currTime;
			
			var enemy:Enemy = enemyPool.checkOut();
			enemy.alive = true;
			enemy.setType(typeNum);
			
			//Set enemy spawn position based on type
			switch (typeNum) {
				case 0:
				default:
					enemy.pos.setVals(Constants.GameWidth * 0.25, -enemy.boundBox.height/2);	
					break;
				
				//TODO: Starting pos for other enemy types
			}
			
			addObjectImage(enemy);
			
			enemies.push(enemy);
		}
		
		public function removeEnemy(enemyIdx:int):void {
			var removedEnemy:Enemy = enemies.splice(enemyIdx, 1)[0];
			if (removedEnemy.image && removedEnemy.image.parent) 
				removedEnemy.image.parent.removeChild(removedEnemy.image);
			enemyPool.checkIn(removedEnemy);
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
		
		private function cleanEnemy(bullet:Enemy):void {
			//Not much to do.... most is handled by removeEnemy()
		}
		///////////////////////////////////////////////////////////////////////////////////////////////
	}
}