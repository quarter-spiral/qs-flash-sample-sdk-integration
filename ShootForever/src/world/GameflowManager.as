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
			//TURNING OFF CHESTS updateChestSpawning();
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
			var timeSinceEnemySpawn:Number = parentWorld.getPlayerLiveTime() - lastEnemySpawnTime;
			if (timeSinceEnemySpawn > .75) {				
				var enemy:Enemy;
				var waveType:int = math.RandomUtils.chooseInt([0,0,0,1,1,1,2,2,2,3,3,4]);
				
				if(spawnCounter < 100) {
					switch(waveType) {
						case 0:
							spawnFiveTightV(Constants.BASIC_ANGLED_ENEMY_ID);
							break;
						case 1:
							spawnFiveTightV(Constants.BASIC_ANGLED_ENEMY_ID);
							break;
						case 2:
							spawnThreeLooseV(Constants.SINE_WAVE_ENEMY_ID);
							break;
						case 3:
							spawnFiveTightV(Constants.SINE_WAVE_ENEMY_ID);
							break;
						case 4:
							spawnSingle(Constants.DART_ENEMY_ID);
							break;
					}
				}
				
				if(spawnCounter >= 100) {
					if(math.RandomUtils.chooseInt([0,1])) {
						spawnDoubleMoveLeft(Constants.DART_LEFT_MED_ID);
					} else {
						spawnDoubleMoveRight(Constants.DART_RIGHT_MED_ID);
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
		
		//Ethan's functions for spawning enemies
		public function spawnSingle(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			enemy = spawnObject(enemyType);
			enemy.setStartPos(25 + 250*Math.random(), -20);
				
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				enemy.moveType = tempMove;
			}
				
			enemy.setInitialVelocity();	
		}
		
		public function spawnSingleMoveRight(enemyType:int):void {
			var enemy:Enemy;
			
			enemy = spawnObject(enemyType);
			enemy.setStartPos(-25 - 50*Math.random(), 50 + 150*Math.random());
			
			enemy.setInitialVelocity();	
		}
		
		public function spawnSingleMoveLeft(enemyType:int):void {
			var enemy:Enemy;
			
			enemy = spawnObject(enemyType);
			enemy.setStartPos(425 + 50*Math.random(), 50 + 150*Math.random());
			
			enemy.setInitialVelocity();	
		}
		
		public function spawnDoubleMoveRight(enemyType:int):void {
			var enemy:Enemy;
			var anchorX:int = -50*Math.random();
			var anchorY:int = 150*Math.random();
			
			for(var i:int=0;i<2;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(-25 + anchorX, 50 + anchorY + i*75);
				enemy.setInitialVelocity();	
			}
		}
		
		public function spawnDoubleMoveLeft(enemyType:int):void {
			var enemy:Enemy;
			var anchorX:int = 50*Math.random();
			var anchorY:int = 150*Math.random();
			
			for(var i:int=0;i<2;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(425 + anchorX, 50 + anchorY + i*75);
				enemy.setInitialVelocity();	
			}
		}
		
		public function spawnTripleMoveRight(enemyType:int):void {
			var enemy:Enemy;
			var anchorX:int = -50*Math.random();
			var anchorY:int = 150*Math.random();
			
			for(var i:int=0;i<3;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(-25 + anchorX, 50 + anchorY + i*75);
				enemy.setInitialVelocity();	
			}
		}
		
		public function spawnTripleMoveLeft(enemyType:int):void {
			var enemy:Enemy;
			var anchorX:int = 50*Math.random();
			var anchorY:int = 150*Math.random();
			
			for(var i:int=0;i<3;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(425 + anchorX, 50 + anchorY + i*75);
				enemy.setInitialVelocity();	
			}
		}
		
		public function spawnThreeTightV(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 200*Math.random();
			
			for(var i:int = 0;i<3;i++) {
				enemy = spawnObject(enemyType);
						
				switch(i) {
					case 0:
						enemy.setStartPos(anchor + i*50, -70);
						break;
					case 1:
						enemy.setStartPos(anchor + i*50, -20);
						break;
					case 2:
						enemy.setStartPos(anchor + i*50, -70);
						break;
					}
						
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
					
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnThreeLooseV(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 70*Math.random();
			
			for(var i:int = 0;i<3;i++) {
				enemy = spawnObject(enemyType);
				
				switch(i) {
					case 0:
						enemy.setStartPos(anchor + i*140, -120);
						break;
					case 1:
						enemy.setStartPos(anchor + i*140, -20);
						break;
					case 2:
						enemy.setStartPos(anchor + i*140, -120);
						break;
				}
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnFiveTightV(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 100*Math.random();
			
			for(var i:int = 0;i<5;i++) {
				enemy = spawnObject(enemyType);
				
				switch(i) {
					case 0:
						enemy.setStartPos(anchor + i*50, -120);
						break;
					case 1:
						enemy.setStartPos(anchor + i*50, -70);
						break;
					case 2:
						enemy.setStartPos(anchor + i*50, -20);
						break;
					case 3:
						enemy.setStartPos(anchor + i*50, -70);
						break;
					case 4:
						enemy.setStartPos(anchor + i*50, -120);
						break;
				}
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnTwoTightLine(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 250*Math.random();
			
			for(var i:int = 0;i<2;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(anchor + i*50, -20);
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnTwoLooseLine(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 210*Math.random();
			
			for(var i:int = 0;i<2;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(anchor + i*140, -20);
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnThreeTightLine(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 200*Math.random();
			
			for(var i:int = 0;i<3;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(anchor + i*50, -20);
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnThreeLooseLine(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 70*Math.random();
			
			for(var i:int = 0;i<3;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(anchor + i*140, -20);
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnFiveTightLine(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			var anchor:int = 25 + 100*Math.random();
			
			for(var i:int = 0;i<5;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(anchor+i*50,-25);
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
		}
		
		public function spawnSevenTightLine(enemyType:int):void {
			var enemy:Enemy;
			
			if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
				var tempMove:int = math.RandomUtils.randomInt(0,4);	
			}
			
			for(var i:int = 0;i<7;i++) {
				enemy = spawnObject(enemyType);
				enemy.setStartPos(25+i*50,-25);
				
				if(enemyType == Constants.BASIC_ANGLED_ENEMY_ID || enemyType == Constants.MEDIUM_ANGLED_ENEMY_ID) {
					enemy.moveType = tempMove;
				}
				
				enemy.setInitialVelocity();
			}		
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
			var upgradeType:int = Constants.getLevelupUpgrade(parentWorld.gameInfo.getLevel());
			upgradePlayer(upgradeType, true);
		}
		
		//Upgrades player stats for given upgrade type in current game, optionally
		//messaging this upgrade using the game UI
		public function upgradePlayer(upgradeType:int, showMsg:Boolean):void {
			var upgradeMsg:String = "";
			switch (upgradeType) {
				case Constants.UPGRADE_NONE:
				default:
					//Do nothing
					break;
				case Constants.UPGRADE_SHOTS_PER_SECOND:
					parentWorld.gameInfo.ingameUpgrades.shotRateLevel++;
					upgradeMsg = "Fire Up";
					break;
				case Constants.UPGRADE_SHOT_DAMAGE:
					parentWorld.gameInfo.ingameUpgrades.shotDamageLevel++;
					upgradeMsg = "Damage Up";
					break;
				case Constants.UPGRADE_SHOT_NUMBER:
					parentWorld.gameInfo.ingameUpgrades.shotNumLevel++;
					upgradeMsg = "Bullet Up";
					break;
				case Constants.UPGRADE_MAGNET_RADIUS_UP:
					parentWorld.gameInfo.ingameUpgrades.magnetRadiusLevel++;
					upgradeMsg = "Magnet Up";
					break;
				case Constants.UPGRADE_BOMB_UP:
					parentWorld.gameInfo.currBombs++;
					upgradeMsg = "Bomb Up";
					break;
			}
			
			parentWorld.getPlayer().setUpgrades(parentWorld.gameInfo.ingameUpgrades);
			
			//Message upgrade to player w/ popup text (hacky & global-reach, but meh...)
			if (upgradeMsg.length > 0)
				Constants.getGameInstance().addActionMessage(upgradeMsg);
		}
	}
}