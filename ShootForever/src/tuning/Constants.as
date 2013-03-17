package tuning
{
	import math.RandomUtils;
	
	import world.EnemyProperties;
	import world.XpProperties;
	
    public class Constants
    {
		//Hacky, but maintain a global game instance for access by various bits
		protected static var game:Game;
		public static function getGameInstance():Game {return game;}
		
		public static const LOCAL_DATA_NAME:String = "ShootForeverData";
		
        public static const GameWidth:int  = 400;
        public static const GameHeight:int = 600;
        
        public static const CenterX:int = GameWidth / 2;
        public static const CenterY:int = GameHeight / 2;
		
		public static const MAIN_FONT:String = "Arial";	
		
		public static const PLAYER_RANK_NAMES:Array = [
			"Ensign I",
			"Ensign II",
			"Junior Lieutenant I",
			"Junior Lieutenant II",
			"Lieutenant I",
			"Lieutenant II",
			"Captain I",
			"Captain II",
			"Major I",
			"Major II",
			"Lieutenant Colonel I",
			"Lieutenant Colonel II",
			"Colonel",
			"Senior Colonel",
			"Commander",
			"Supreme Commander",
			"Rear Admiral",
			"Vice Admiral",
			"Senior Vice Admiral",
			"Admiral",
			"Supreme High Admiral"
		]
		
		//GAMEPLAY CONSTANTS
			
		public static const WORLD_MAX_TIMESTEP:Number = 0.03;	//prevents overlarge timestep sizes (at the cost of not having real-time updates)
		
		//PLAYER
		public static const PLAYER_WIDTH:int = 10;//50;
		public static const PLAYER_HEIGHT:int = 10;//30;
		
		public static const PLAYER_BULLET_RADIUS:int = 2;
		
		public static const PLAYER_START_BOMBS_BASE:int = 0;
		public static const PLAYER_START_BOMBS_UPGRADE:int = 0;
		
		public static const PLAYER_SHOTS_PER_SECOND_BASE:Number = 2;
		public static const PLAYER_SHOTS_PER_SECOND_UPGRADE:Number = .5;
		
		public static const PLAYER_SHOT_SPEED_BASE:Number = 500.0;
		//public static const PLAYER_SHOT_SPEED_UPGRADE:Number = 100.0; //not upgradeable as of 2.24.2013
		
		public static const PLAYER_SHOT_DAMAGE_BASE:Number = 1;
		public static const PLAYER_SHOT_DAMAGE_UPGRADE:Number = 1;
		
		public static const PLAYER_SHOT_NUMBER_BASE:int = 1;
		public static const PLAYER_SHOT_NUMBER_UPGRADE:int = 1;
		
		public static const PLAYER_MAGNET_RADIUS_BASE:Number = 50.0;
		public static const PLAYER_MAGNET_RADIUS_UPGRADE:Number = 10.0;
		
		//Just in case we want upgradable shot radii
		public static const PLAYER_SHOT_RADIUS_BASE:Number = 16;
		//public static const PLAYER_SHOT_RADIUS_UPGRADE:Number = 2; //not upgradeable as of 2.24.2013
		
		//LEVELING
		
		protected static var LEVELING_PROPERTIES:Vector.<PlayerLevelProperties>;
		
		//UPGRADE TYPES
		public static const UPGRADE_NONE:int				= 0;
		public static const UPGRADE_RANDOM:int				= 1;
		public static const UPGRADE_SHOTS_PER_SECOND:int 	= 2;	//rate at which player spawns bullets
		public static const UPGRADE_SHOT_DAMAGE:int 		= 3;	//damage on baddies for player bullets
		public static const UPGRADE_SHOT_NUMBER:int			= 4;	//increase number of at-once shots
		public static const UPGRADE_MAGNET_RADIUS_UP:int	= 5;	//not yet implemented as of 2.15.2013
		public static const UPGRADE_BOMB_UP:int				= 6;	//a bit different than others... just gives a bomb to player... doesn't affect his/her upgrade stats
		//XP
		
		public static var XP_PROPERTIES:Vector.<XpProperties> = new Vector.<XpProperties>();
		private static var totalXpWeight:int = 0;
		
		//XP motion tuning (note that these guys generally need to be tuned as a group,
		//as changing one will usually create an imbalance among the others)
		public static const XP_DRAG:Number = 0.98;					//A constant drag coefficient applied to XP each update (prevents oscillations & excessive speeds)
		public static const XP_GRAVITY:Number = 10; 				//Affects how quickly XP falls from baddies
		public static const XP_MAGNET_FORCE_BASE:Number = 50.0;		//Strength of xp magnet (basically an "acceleration" value) (See Player.checkAndApplyMagnet())
		
		//Xp costs in upgrade store
		public static const UPGRADE_SHOTS_PER_SECOND_COST:Number = 500;
		public static const UPGRADE_SHOT_DAMAGE_COST:Number = 500;
		
		//ENEMIES
		public static var ENEMY_PROPERTIES:Vector.<EnemyProperties> = new Vector.<EnemyProperties>();

		public static var 	TREASURE_CHEST_ID:int;
		
		public static var 	BASIC_ANGLED_ENEMY_ID:int;
		public static var 	MEDIUM_ANGLED_ENEMY_ID:int; 				//angled enemy with more hp
		public static const BASIC_ENEMY_ATTACK_ANGLE:Number = 0;		//angle away from vertical, in degrees (0 = fall straight down)
		
		public static var 	HORIZONTAL_ENEMY_ID:int;
		
		public static var   DART_ENEMY_ID:int;
		
		public static var 	DART_RIGHT_ENEMY_ID:int;
		public static var   DART_LEFT_ENEMY_ID:int;
		
		public static var 	DART_RIGHT_MED_ID:int;
		public static var 	DART_LEFT_MED_ID:int;
		
		public static var SINE_WAVE_ENEMY_ID:int;
		public static const WAVE_ENEMY_SIDE_MOTION_AMPLITUDE:Number = 100;	//Amplitude of sideways motion for sinusoid enemy
		public static const WAVE_ENEMY_SIDE_MOTION_PERIOD:Number = 2;	//Affects rate of sideways motion for sinusoid enemy
		
		public static var SINE_WAVE_MED_ID:int;
		
		public static var BASIC_HEAVY_ENEMY_ID:int; //large ship with slow motion and high hp
		
		public static const ENEMY_FLASH_WHEN_HURT:Boolean = true;		//enable/disable flashing graphic when enemies are hurt by player
		public static const ENEMY_HURT_FLASH_LENGTH:Number = 0.15;		//length of graphical flash when enemies are hurt, in seconds

		//UI & ANIMATIONS
		public static const ACTION_MSG_SWEEP_IN_TIME:Number = 	0.3;		//Time for popup action msgs to "sweep in" from sides
		public static const ACTION_MSG_HOLD_TIME:Number		= 0.4;			//Time that action msgs sit still before starting to fade
		public static const ACTION_MSG_SWEEP_OUT_TIME:Number = 1.0;			//Time that action msgs take to fade/sweep out
		
		//Background star speed controls
		public static const STAR_BASE_SPEED_MIN:Number = 50;
		public static const STAR_BASE_SPEED_MAX:Number = 100;
		public static const STAR_BASE_SPEED_RANGE:Number = STAR_BASE_SPEED_MAX - STAR_BASE_SPEED_MIN;
		public static const STAR_SPEED_MULT_INCREMENT_TIME:Number = 3.0;			//Game time over which speed of background stars increases by 1x
		public static const STAR_SPEED_POST_DEATH_DECAY_TIME:Number = 1.5;			//Time after player dies over which star speeds returns to baseline values 
		
		public static function init(gameInstance :Game):void {
			Constants.game = gameInstance;
			initXpProperties();
			initEnemyProperties();
			initLevelingProperties();
		}
		
		protected static function initXpProperties():void {
			var props:XpProperties;
			
			props = new XpProperties();
			props.spawnWeight = 35;
			props.xpAmount = 5;
			props.imageName = "Xp5Image";
			XP_PROPERTIES.push(props);
			
			props = new XpProperties();
			props.spawnWeight = 40;
			props.xpAmount = 10;
			props.imageName = "Xp10Image";
			XP_PROPERTIES.push(props);
			
			props = new XpProperties();
			props.spawnWeight = 15;
			props.xpAmount = 25;
			props.imageName = "Xp25Image";
			XP_PROPERTIES.push(props);
			
			props = new XpProperties();
			props.spawnWeight = 9;
			props.xpAmount = 50;
			props.imageName = "Xp50Image";
			XP_PROPERTIES.push(props);

			props = new XpProperties();
			props.spawnWeight = 1;
			props.xpAmount = 100;
			props.imageName = "Xp100Image";
			XP_PROPERTIES.push(props);
			
			for (var i:int = 0; i < XP_PROPERTIES.length; i++) {
				totalXpWeight += XP_PROPERTIES[i].spawnWeight;
			}
		}
		
		protected static function initEnemyProperties():void {
			var enemyId:int = 0;
			var props:EnemyProperties;
			
			//Create the various enemy types
			TREASURE_CHEST_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 0;
			props.killXpCoins = 0;
			props.maxHealth = 1;
			props.size.setVals(28,30);
			props.speed = 30;
			props.imageName = "TreasureChestImage";
			props.harmsPlayer = false;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			BASIC_ANGLED_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 3;
			props.maxHealth = 1;
			props.size.setVals(37,34);
			props.speed = 200;
			props.imageName = "Enemy1Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			MEDIUM_ANGLED_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 4;
			props.maxHealth = 3;
			props.size.setVals(56,40);
			props.speed = 225;
			props.imageName = "Enemy8Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			DART_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 6;
			props.maxHealth = 3;
			props.size.setVals(65,72);
			props.speed = 50;
			props.imageName = "Enemy4Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			props.dartStraight = true;
			props.dartDelay = 3.5;
			props.dartPause = 1.5;
			props.postDartSpeedMult = 7.0;
			ENEMY_PROPERTIES.push(props);
			
			DART_RIGHT_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 3;
			props.maxHealth = 1;
			props.size.setVals(37,32);
			props.speed = 150;
			props.imageName = "Enemy3Image";
			props.harmsPlayer = true;
			props.dartTarget = true;
			props.dartDelay = .75;
			props.dartPause = 0.25;
			props.postDartSpeedMult = 2.5;
			ENEMY_PROPERTIES.push(props);
			
			DART_RIGHT_MED_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 5;
			props.maxHealth = 2;
			props.size.setVals(40,30);
			props.speed = 175;
			props.imageName = "Enemy7Image";
			props.harmsPlayer = true;
			props.dartTarget = true;
			props.dartDelay = .75;
			props.dartPause = 1;
			props.postDartSpeedMult = 2.5;
			ENEMY_PROPERTIES.push(props);
			
			DART_LEFT_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 3;
			props.maxHealth = 1;
			props.size.setVals(37,32);
			props.speed = -150;
			props.imageName = "Enemy3Image";
			props.harmsPlayer = true;
			props.dartTarget = true;
			props.dartDelay = .75;
			props.dartPause = 0.25;
			props.postDartSpeedMult = -2.5;
			ENEMY_PROPERTIES.push(props);
			
			DART_LEFT_MED_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 5;
			props.maxHealth = 2;
			props.size.setVals(40,30);
			props.speed = -175;
			props.imageName = "Enemy7Image";
			props.harmsPlayer = true;
			props.dartTarget = true;
			props.dartDelay = .75;
			props.dartPause = 1;
			props.postDartSpeedMult = -2.5;
			ENEMY_PROPERTIES.push(props);
			
			SINE_WAVE_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 3;
			props.maxHealth = 1;
			props.size.setVals(43,32);
			props.speed = 150;
			props.imageName = "Enemy2Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			SINE_WAVE_MED_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 5;
			props.maxHealth = 3;
			props.size.setVals(66,51);
			props.speed = 175;
			props.imageName = "Enemy6Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			BASIC_HEAVY_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 10;
			props.maxHealth = 10;
			props.size.setVals(109,86);
			props.speed = 50;
			props.imageName = "Enemy5Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
		}
		
		//Sets up how player levels up in-game
		protected static function initLevelingProperties():void {
			LEVELING_PROPERTIES = new Vector.<PlayerLevelProperties>();
			
			//Set xp per level and bonus upgrade on reach level here...
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(0, UPGRADE_NONE));						//level 0... not actually ever "reached"
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(100, UPGRADE_SHOTS_PER_SECOND));			//Ensign I
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(225, UPGRADE_BOMB_UP));					//Ensign II
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(425, UPGRADE_MAGNET_RADIUS_UP));			//Junior Lieutenant I
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(650, UPGRADE_SHOTS_PER_SECOND));		//Junior Lieutenant II
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(975, UPGRADE_SHOT_NUMBER));				//5 - Lieutenant I
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(1325, UPGRADE_SHOTS_PER_SECOND));		//Lieutenant II
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(1700, UPGRADE_BOMB_UP));					//Captain I
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(2150, UPGRADE_MAGNET_RADIUS_UP));		//Captain II
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(2625, UPGRADE_BOMB_UP));					//Major I
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(3200, UPGRADE_SHOT_DAMAGE));				//10 - Major II
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(3800, UPGRADE_SHOTS_PER_SECOND));		//Lieutenant Colonel I
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(4425, UPGRADE_BOMB_UP));					//Lieutenant Colonel II
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(5125, UPGRADE_MAGNET_RADIUS_UP));		//Colonel
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(5850, UPGRADE_SHOTS_PER_SECOND));					//Senior Colonel
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(6675, UPGRADE_SHOT_NUMBER));			//15 - Commander
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(7525, UPGRADE_SHOTS_PER_SECOND));		//Supreme Commander
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(8400, UPGRADE_BOMB_UP));				//Rear Admiral
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(9350, UPGRADE_MAGNET_RADIUS_UP));		//Vice Admiral
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(10325, UPGRADE_BOMB_UP));					//Senior Vice Admiral
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(11400, UPGRADE_SHOT_DAMAGE));			//20 - Admiral
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(12625, UPGRADE_SHOT_NUMBER));			//Supreme High Admiral
		}	
		
		//Returns a random Xp property, with the probability of returning any 
		//given property weighted by its spawnWeight value.
		public static function getRandomXpProps():XpProperties {
			var weightRoll:int = RandomUtils.randomInt(0, totalXpWeight);
			var numXpProps:int = XP_PROPERTIES.length;
			
			//TODO: could really optimize this weighted die roll...
			var chosenProps:XpProperties = null;
			var currentWeight:int = 0;
			for (var i:int = 0; i < numXpProps; i++) {
				currentWeight += XP_PROPERTIES[i].spawnWeight;
				if (weightRoll <= currentWeight) {
					chosenProps = XP_PROPERTIES[i];
					break;
				}
			}
			return chosenProps;
		}
		
		//Returns fancy rank name based on given rank level
		public static function getPlayerRankName(rankLvl : int):String {
			var rankName:String = "";
			
			if (rankLvl < PLAYER_RANK_NAMES.length)
				rankName = PLAYER_RANK_NAMES[rankLvl];
			else 
				rankName = PLAYER_RANK_NAMES[PLAYER_RANK_NAMES.length - 1];
			
			return rankName;
		}
		
		//Returns amount of xp required to reach given rank level
		public static function getXpForLevel(level : int):int {
			var numLevels:int = LEVELING_PROPERTIES.length;
			if (level < numLevels) 
				return LEVELING_PROPERTIES[level].xpNeeded;
			//If requested level is beyond the number of scripted levels, just extrapolate the highest level...
			else if (numLevels >= 2) {
				var highestXpDelta:int = LEVELING_PROPERTIES[numLevels-1].xpNeeded - LEVELING_PROPERTIES[numLevels-2].xpNeeded;
				var numLevelsBeyondScripted:int = level - numLevels;
				return LEVELING_PROPERTIES[numLevels-1].xpNeeded + (numLevelsBeyondScripted*highestXpDelta);
			}
			else
				return 0;
		}
		
		//Returns the player upgrade type for achieving given level
		public static function getLevelupUpgrade(level : int):int {
			var numLevels:int = LEVELING_PROPERTIES.length;
			if (level < numLevels) {
				var upgradeType:int =  LEVELING_PROPERTIES[level].upgradeType;
				//Select a random if needed
				if (upgradeType == UPGRADE_RANDOM) {
					//NOTE: Be sure to modify this if we want additional future upgrade included in random roll
					//Not ideal setup.... should fix this later
					upgradeType = RandomUtils.chooseInt( [
						UPGRADE_SHOTS_PER_SECOND,
						UPGRADE_SHOT_DAMAGE,
						UPGRADE_SHOT_NUMBER,
						UPGRADE_MAGNET_RADIUS_UP,
						UPGRADE_BOMB_UP
						]);
				}
				return upgradeType;
			}
			//If no scripted level, return nothing...
			else
				return UPGRADE_NONE;
		}
		
    }
}