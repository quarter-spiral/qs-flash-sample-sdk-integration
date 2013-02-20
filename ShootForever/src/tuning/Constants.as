package tuning
{
	import math.RandomUtils;
	import math.Vec2;
	
	import world.EnemyProperties;
	import world.XpProperties;
	import world.pools.XpPool;
	
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
		
		public static const MAIN_FONT:String = "Verdana";	
		
		public static const PLAYER_RANK_NAMES:Array = [
			"Noob",
			"Wimp",
			"Footman",
			"Veteran",
			"Mayor of the Town",
			"Regent of the World",
			"Lord of the Galaxy",
			"King of All Cosmos"
		]
		
		//GAMEPLAY CONSTANTS
		
		//PLAYER
		public static const PLAYER_WIDTH:int = 10;//50;
		public static const PLAYER_HEIGHT:int = 10;//30;
		
		public static const PLAYER_BULLET_RADIUS:int = 2;
		
		public static const PLAYER_START_BOMBS_BASE:int = 3;
		public static const PLAYER_START_BOMBS_UPGRADE:int = 0;
		
		public static const PLAYER_SHOTS_PER_SECOND_BASE:Number = 2;
		public static const PLAYER_SHOTS_PER_SECOND_UPGRADE:Number = 1.0;
		
		public static const PLAYER_SHOT_SPEED_BASE:Number = 500.0;
		public static const PLAYER_SHOT_SPEED_UPGRADE:Number = 100.0;
		
		public static const PLAYER_SHOT_DAMAGE_BASE:Number = 1;
		public static const PLAYER_SHOT_DAMAGE_UPGRADE:Number = 100;
		
		//Just in case we want upgradable shot radii
		public static const PLAYER_SHOT_RADIUS_BASE:Number = 16;
		public static const PLAYER_SHOT_RADIUS_UPGRADE:Number = 2;
		
		//LEVELING
		
		protected static var LEVELING_PROPERTIES:Vector.<PlayerLevelProperties>;
		
		//UPGRADE TYPES
		public static const UPGRADE_NONE:int				= 0;
		public static const UPGRADE_RANDOM:int				= 1;
		public static const UPGRADE_SHOTS_PER_SECOND:int 	= 2;	//rate at which player spawns bullets
		public static const UPGRADE_SHOT_SPEED:int			= 3;	//speed of bullet once spawned
		public static const UPGRADE_SHOT_DAMAGE:int 		= 4;	//damage on baddies for player bullets
		public static const UPGRADE_SHOT_NUMBER:int			= 5;	//increase number of at-once shots (not yet implemented as of 2.15.2013)
		public static const UPGRADE_BOMB_UP:int				= 6;	//a bit different than others... just gives a bomb to player... doesn't affect his/her upgrade stats
		public static const UPGRADE_MAGNET_RADIUS_UP:int	= 7;	//not yet implemented as of 2.15.2013
		//XP
		
		public static var XP_PROPERTIES:Vector.<XpProperties> = new Vector.<XpProperties>();
		private static var totalXpWeight:int = 0;
		
		public static const XP_GRAVITY:Number = 12; //Affects how quickly XP falls from baddies
		
		//Xp costs in upgrade store
		public static const UPGRADE_SHOTS_PER_SECOND_COST:Number = 500;
		public static const UPGRADE_SHOT_DAMAGE_COST:Number = 500;
		
		//ENEMIES
		public static var ENEMY_PROPERTIES:Vector.<EnemyProperties> = new Vector.<EnemyProperties>();

		public static var 	TREASURE_CHEST_ID:int;
		
		public static var 	BASIC_ANGLED_ENEMY_ID:int;
		public static const BASIC_ENEMY_ATTACK_ANGLE:Number = 0;		//angle away from vertical, in degrees (0 = fall straight down)
		
		public static var 	HORIZONTAL_ENEMY_ID:int;
		
		public static var   DART_ENEMY_ID:int;
		
		public static var 	DART_HORIZONTAL_ENEMY_ID:int;
		public static var   DART_LEFT_ENEMY_ID:int;
		
		public static var SINE_WAVE_ENEMY_ID:int;
		public static const WAVE_ENEMY_SIDE_MOTION_AMPLITUDE:Number = 100;	//Amplitude of sideways motion for sinusoid enemy
		public static const WAVE_ENEMY_SIDE_MOTION_PERIOD:Number = 2;	//Affects rate of sideways motion for sinusoid enemy

		//UI & ANIMATIONS
		public static const ACTION_MSG_SWEEP_IN_TIME:Number = 	0.3;		//Time for popup action msgs to "sweep in" from sides
		public static const ACTION_MSG_HOLD_TIME:Number		= 0.4;			//Time that action msgs sit still before starting to fade
		public static const ACTION_MSG_SWEEP_OUT_TIME:Number = 1.0;			//Time that action msgs take to fade/sweep out
		
		public static function init(gameInstance :Game):void {
			Constants.game = gameInstance;
			initXpProperties();
			initEnemyProperties();
			initLevelingProperties();
		}
		
		protected static function initXpProperties():void {
			var props:XpProperties;
			
			/*props = new XpProperties();
			props.spawnWeight = 5;
			props.xpAmount = 5;
			props.imageName = "XpTinyImage";
			XP_PROPERTIES.push(props);*/
			
			props = new XpProperties();
			props.spawnWeight = 10;
			props.xpAmount = 10;
			props.imageName = "XpSmallImage";
			XP_PROPERTIES.push(props);
			
			/*props = new XpProperties();
			props.spawnWeight = 35;
			props.xpAmount = 25;
			props.imageName = "XpMedSmallImage";
			XP_PROPERTIES.push(props);
			
			props = new XpProperties();
			props.spawnWeight = 30;
			props.xpAmount = 50;
			props.imageName = "XpMediumImage";
			XP_PROPERTIES.push(props);

			props = new XpProperties();
			props.spawnWeight = 15;
			props.xpAmount = 100;
			props.imageName = "XpMedLargeImage";
			XP_PROPERTIES.push(props);*/
			
			props = new XpProperties();
			props.spawnWeight = 5;
			props.xpAmount = 500;
			props.imageName = "XpLargeImage";
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
			props.size.setVals(32,32);
			props.speed = 30;
			props.imageName = "TreasureChestImage";
			props.harmsPlayer = false;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			BASIC_ANGLED_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 2;
			props.maxHealth = 1;
			props.size.setVals(25,25);
			props.speed = 200;
			props.imageName = "Enemy1Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			HORIZONTAL_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 1;
			props.maxHealth = 1;
			props.size.setVals(25,25);
			props.speed = 100;
			props.imageName = "Enemy1Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
			
			DART_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 10;
			props.maxHealth = 3;
			props.size.setVals(60,65);
			props.speed = 50;
			props.imageName = "Enemy4Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			props.dartStraight = true;
			props.dartDelay = 2.5;
			props.dartPause = 1.5;
			props.postDartSpeedMult = 7.0;
			ENEMY_PROPERTIES.push(props);
			
			DART_HORIZONTAL_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 2;
			props.maxHealth = 1;
			props.size.setVals(25,25);
			props.speed = 150;
			props.imageName = "Enemy3Image";
			props.harmsPlayer = true;
			props.dartTarget = true;
			props.dartDelay = .75;
			props.dartPause = 0.25;
			props.postDartSpeedMult = 2.5;
			ENEMY_PROPERTIES.push(props);
			
			DART_LEFT_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 2;
			props.maxHealth = 1;
			props.size.setVals(25,25);
			props.speed = -150;
			props.imageName = "Enemy3Image";
			props.harmsPlayer = true;
			props.dartTarget = true;
			props.dartDelay = .75;
			props.dartPause = 0.25;
			props.postDartSpeedMult = -2.5;
			ENEMY_PROPERTIES.push(props);
			
			SINE_WAVE_ENEMY_ID = enemyId++;
			props = new EnemyProperties();
			props.killScore = 10;
			props.killXpCoins = 2;
			props.maxHealth = 1;
			props.size.setVals(25,25);
			props.speed = 150;
			props.imageName = "Enemy2Image";
			props.harmsPlayer = true;
			props.dartTarget = false;
			ENEMY_PROPERTIES.push(props);
		}
		
		//Sets up how player levels up in-game
		protected static function initLevelingProperties():void {
			LEVELING_PROPERTIES = new Vector.<PlayerLevelProperties>();
			
			//Set xp per level and bonus upgrade on reach level here...
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(0, UPGRADE_NONE));		//level 0... not actually ever "reached"
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(500, UPGRADE_BOMB_UP));
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(1500, UPGRADE_SHOT_SPEED));
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(3000, UPGRADE_SHOTS_PER_SECOND));
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(5000, UPGRADE_SHOT_DAMAGE));
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(7500, UPGRADE_NONE));
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(11000, UPGRADE_NONE));
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(15000, UPGRADE_NONE));
			LEVELING_PROPERTIES.push(new PlayerLevelProperties(25000, UPGRADE_NONE));
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
						UPGRADE_SHOT_SPEED,
						UPGRADE_SHOT_DAMAGE,
						//UPGRADE_MAGNET_RADIUS_UP,
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