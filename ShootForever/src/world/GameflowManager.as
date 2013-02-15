package world
{
	import math.RandomUtils;

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
		public function updateSpawning():void {
			updateEnemySpawning();
			updateChestSpawning();
			updateStarSpawning();
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
			var timeSinceEnemySpawn:Number = parentWorld.getTime() - lastEnemySpawnTime;
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
			var timeSinceChestSpawn:Number = parentWorld.getTime() - lastChestSpawnTime;
			if (timeSinceChestSpawn > 10.0) {
				var enemy:Enemy = spawnObject(Constants.TREASURE_CHEST_ID);
				enemy.setInitialVelocity();
			}
		}
		
		protected function updateStarSpawning():void {
			//PLACEHOLDER BASIC: Spawn a chest every so often
			var timeSinceStarSpawn:Number = parentWorld.getTime() - lastStarSpawnTime;
			if (timeSinceStarSpawn > .25* Math.random()) {
				lastStarSpawnTime = parentWorld.getTime();
				for(var i:int=0;i<3;i++) {
					parentWorld.spawnStar();
				}
			}
		}
		
		/** Spawns an enemy/chest in the world of given type and records the spawn time*/
		protected function spawnObject(typeNum:int):Enemy {
			if (typeNum == Constants.TREASURE_CHEST_ID)
				lastChestSpawnTime = parentWorld.getTime();
			else
				lastEnemySpawnTime = parentWorld.getTime();
			
			return parentWorld.spawnObject(typeNum);
		}
		
		
	}
}