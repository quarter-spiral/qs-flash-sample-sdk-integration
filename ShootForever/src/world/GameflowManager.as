package world
{
	import math.RandomUtils;
	
	import tuning.Constants;

	/** Holds all the various scripting for spawning baddies/chests/etc in the world
	 * Calling this "GameflowManager" since its role may expand beyond spawning in the future.... */
	public class GameflowManager
	{
		//Counter of # of times enemies have been spawned
		private var spawnCounter:int;
		
		private var lastChestSpawnTime:Number = 0;
		private var lastEnemySpawnTime:Number = 0;
		private var lastStarSpawnTime:Number = 0;
		
		//Reference to parent game world that this manager affects
		protected var parentWorld:World;
		
		public function GameflowManager(parent:World)
		{
			this.parentWorld = parent;
			reset(); //init state
		}
		
		/** Runs all chest/enemy spawning updates */
		public function updateMobSpawning():void {
			updateEnemySpawning();
			updateChestSpawning();
			//updateStarSpawning(); //since this runs even on main menu & game over screens, we call this elsewhere
		}
		
		/** Resets all game flow state (use this in case we add "restart" later) */
		public function reset():void {
			spawnCounter = 0;
			lastChestSpawnTime = 0;
			lastEnemySpawnTime = 0;
			lastStarSpawnTime = 0;
		}
		
		//Creates enemies as necessary during main game loop
		protected function updateEnemySpawning():void {
			//PLACEHOLDER BASIC: Spawn an enemy every second or so
			var timeSinceEnemySpawn:Number = parentWorld.getPlayerLiveTime() - lastEnemySpawnTime;
			if (timeSinceEnemySpawn > .75) {
				//PLACEHOLDER: Spawn random enemy types
				/*var NumEnemyTypes:int = Constants.ENEMY_PROPERTIES.length;
				var enemyType:int = RandomUtils.randomInt(1, NumEnemyTypes-1);
				spawnEnemy(enemyType);*/
				
				//spawn single enemy
				//spawnEnemy(Constants.BASIC_ANGLED_ENEMY_ID);
				
				var enemy:Enemy;
				var waveType:int = math.RandomUtils.randomInt(0,3);
				var tempMove:int = math.RandomUtils.randomInt(0,4);
				
				//5 singles then a wave
				if(spawnCounter<20) {
					switch(waveType) {
						case 0:
							//3 basics in a v
							for(var i:int = 0;i<3;i++) {
								enemy = spawnObject(Constants.BASIC_ANGLED_ENEMY_ID);
								
								switch(i) {
									case 0:
										enemy.setStartPos(100 + i*50, -70);
										break;
									case 1:
										enemy.setStartPos(100 + i*50, -20);
										break;
									case 2:
										enemy.setStartPos(100 + i*50, -70);
										break;
								}
								
								enemy.moveType = tempMove;	
								enemy.setInitialVelocity();
							}
							break;
						case 1:
							//3 sine in a line
							var spawnAnchor:int = Math.floor(200*Math.random());
							
							for(i=0;i<3;i++) {
								enemy = spawnObject(Constants.SINE_WAVE_ENEMY_ID);
								enemy.setStartPos(75*i+spawnAnchor,-20);
								enemy.setInitialVelocity();
							}
							break;
						case 2:
							//horizontal dart enemy
							enemy = spawnObject(Constants.DART_LEFT_ENEMY_ID);
							enemy.moveType = tempMove;
							enemy.setStartPos(450,75+200*Math.random());
							enemy.setInitialVelocity();
							break;
						case 3:
							//big straight on dart
							enemy = spawnObject(Constants.DART_ENEMY_ID);
							enemy.setStartPos(75+250*Math.random(),-30);
							enemy.setInitialVelocity();
							break;
					}
				} else {
					switch(waveType) {
						case 0:
							//v of 5 basic
							for(i = 0;i<5;i++) {
								enemy = spawnObject(Constants.BASIC_ANGLED_ENEMY_ID);
								
								switch(i) {
									case 0:
										enemy.setStartPos(100 + i*50, -120);
										break;
									case 1:
										enemy.setStartPos(100 + i*50, -70);
										break;
									case 2:
										enemy.setStartPos(100 + i*50, -20);
										break;
									case 3:
										enemy.setStartPos(100 + i*50, -70);
										break;
									case 4:
										enemy.setStartPos(100 + i*50, -120);
										break;
								}
								
								enemy.moveType = tempMove;	
								enemy.setInitialVelocity();
							}
							break;
						case 1:
							//4 sine in a line
							spawnAnchor = Math.floor(125*Math.random());
							
							for(i=0;i<4;i++) {
								enemy = spawnObject(Constants.SINE_WAVE_ENEMY_ID);
								enemy.setStartPos(75*i+spawnAnchor,-20);
								enemy.setInitialVelocity();
							}
							break;
						case 2:
							spawnAnchor = 200*Math.random();
							
							//2 darters at once
							for(i=0;i<3;i++) {
								enemy = spawnObject(Constants.DART_HORIZONTAL_ENEMY_ID);
								enemy.moveType = tempMove;
								enemy.setStartPos(-25-50*i,100*i+spawnAnchor);
								enemy.setInitialVelocity();
							}
							break;
						case 3:
							//big dart with a v of normals
							//TODO - SLOW ASS SINE ENEMIES
							for(i = 0;i<5;i++) {
								switch(i) {
									case 0:
										enemy = spawnObject(Constants.SINE_WAVE_ENEMY_ID);
										enemy.setStartPos(100 + i*50, -120);
										break;
									case 1:
										enemy = spawnObject(Constants.SINE_WAVE_ENEMY_ID);
										enemy.setStartPos(100 + i*50, -70);
										break;
									case 2:
										enemy = spawnObject(Constants.DART_ENEMY_ID);
										enemy.setStartPos(100 + i*50, -20);
										break;
									case 3:
										enemy = spawnObject(Constants.SINE_WAVE_ENEMY_ID);
										enemy.setStartPos(100 + i*50, -70);
										break;
									case 4:
										enemy = spawnObject(Constants.SINE_WAVE_ENEMY_ID);
										enemy.setStartPos(100 + i*50, -120);
										break;
								}
								
								enemy.moveType = 3;	
								enemy.setInitialVelocity();
							}
							break;
							
					}
						
				}
				
				spawnCounter += 1;
			}
		}
		
		protected function updateChestSpawning():void {
			//PLACEHOLDER BASIC: Spawn a chest every so often
			var timeSinceChestSpawn:Number = parentWorld.getPlayerLiveTime() - lastChestSpawnTime;
			if (timeSinceChestSpawn > 10.0) {
				var enemy:Enemy = spawnObject(Constants.TREASURE_CHEST_ID);
				enemy.setInitialVelocity();
			}
		}
		
		/** Spawns an enemy/chest in the world of given type and records the spawn time*/
		protected function spawnObject(typeNum:int):Enemy {
			if (typeNum == Constants.TREASURE_CHEST_ID)
				lastChestSpawnTime = parentWorld.getPlayerLiveTime();
			else
				lastEnemySpawnTime = parentWorld.getPlayerLiveTime();
			
			return parentWorld.spawnObject(typeNum);
		}
		
		
		public function updateStarSpawning():void {
			//PLACEHOLDER BASIC: Spawn a chest every so often
			//(note that we use world time so that we can run even while not in the main game loop)
			var timeSinceStarSpawn:Number = parentWorld.getWorldTime() - lastStarSpawnTime;
			if (timeSinceStarSpawn > .25* Math.random()) {
				lastStarSpawnTime = parentWorld.getWorldTime();
				for(var i:int=0;i<3;i++) {
					parentWorld.spawnStar();
				}
			}
		}
		
		//Increments player's in-game level & gives that level's upgrade award
		//Note that this does *not* modify player XP, so it's a good idea to be sure
		//the level up is warranted by current XP levels first.
		public function levelupPlayer():void {
			parentWorld.gameInfo.ingameLevelups++;
			
			//Give player the upgrade award
			var upgrade:int = Constants.getLevelupUpgrade(parentWorld.gameInfo.getLevel());
			switch (upgrade) {
				case Constants.UPGRADE_NONE:
				default:
					//Do nothing
					break;
				case Constants.UPGRADE_SHOTS_PER_SECOND:
					parentWorld.gameInfo.ingameUpgrades.shotRateLevel++;
					break;
				case Constants.UPGRADE_SHOT_SPEED:
					parentWorld.gameInfo.ingameUpgrades.shotSpeedLevel++;
					break;
				case Constants.UPGRADE_SHOT_DAMAGE:
					parentWorld.gameInfo.ingameUpgrades.shotDamageLevel++;
					break;
				case Constants.UPGRADE_BOMB_UP:
					parentWorld.gameInfo.currBombs++;
					break;
			}
			
			parentWorld.getPlayer().updateStatsFromUpgrades(parentWorld.gameInfo.ingameUpgrades);
			
			//TODO: Message upgrade to player w/ popup text
		}
	}
}