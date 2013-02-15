package
{
	import math.RandomUtils;
	import math.Vec2;
	
	import world.EnemyProperties;
	import world.XpProperties;
	import world.pools.XpPool;
	
    public class Constants
    {
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
		
		public static const PLAYER_SHOTS_PER_SECOND_BASE:Number = 2;
		public static const PLAYER_SHOTS_PER_SECOND_UPGRADE:Number = 1.0;
		
		public static const PLAYER_SHOT_SPEED_BASE:Number = 500.0;
		public static const PLAYER_SHOT_SPEED_UPGRADE:Number = 100.0;
		
		public static const PLAYER_SHOT_DAMAGE_BASE:Number = 1;
		public static const PLAYER_SHOT_DAMAGE_UPGRADE:Number = 1;
		
		//Just in case we want upgradable shot radii
		public static const PLAYER_SHOT_RADIUS_BASE:Number = 16;
		public static const PLAYER_SHOT_RADIUS_UPGRADE:Number = 2;
		
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

		
		public static function init():void {
			initXpProperties();
			initEnemyProperties();
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
		public static function getXpForLevel(rankLvl : int):int {
			//Modify as desired...
			switch (rankLvl) {
				case 0: return 0; break;
				case 1: return 500; break;
				case 2: return 1500; break;
				case 3: return 3000; break;
				case 4: return 5000; break;
				case 5: return 7500; break;
				case 6: return 11000; break;
				case 7: return 15000; break;
				case 8: return 25000; break;
				default: return 25000 + (rankLvl - 8) * 15000; break;
			}
		}
		
    }
}