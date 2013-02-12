package
{
	import world.EnemyProperties;
	
    public class Constants
    {
        public static const GameWidth:int  = 400;
        public static const GameHeight:int = 600;
        
        public static const CenterX:int = GameWidth / 2;
        public static const CenterY:int = GameHeight / 2;
		
		public static const MAIN_FONT:String = "Verdana";	
		
		public static const PLAYER_RANK_NAMES:Array = [
			"Noob",
			"Rank 2",
			"Rank 3",
			"Rank 4",
			"Rank 5",
			"Rank 6",
			"Rank 7",
			"Rank 8",
		]
		
		//GAMEPLAY CONSTANTS
		
		//PLAYER
		public static const PLAYER_RADIUS:int = 64;
		
		public static const PLAYER_SHOTS_PER_SECOND_BASE:Number = 1.0;
		public static const PLAYER_SHOTS_PER_SECOND_UPGRADE:Number = 1.0;
		
		public static const PLAYER_SHOT_SPEED_BASE:Number = 100.0;
		public static const PLAYER_SHOT_SPEED_UPGRADE:Number = 50.0;
		
		public static const PLAYER_SHOT_DAMAGE_BASE:Number = 1;
		public static const PLAYER_SHOT_DAMAGE_UPGRADE:Number = 1;
		
		//Just in case we want upgradable shot radii
		public static const PLAYER_SHOT_RADIUS_BASE:Number = 16;
		public static const PLAYER_SHOT_RADIUS_UPGRADE:Number = 2;
		
		//ENEMIES
		public static var ENEMY_PROPERTIES:Vector.<EnemyProperties> = new Vector.<EnemyProperties>();
		
		public static const BASIC_ENEMY_ATTACK_ANGLE:Number = 0;	//angle away from vertical, in degrees (0 = fall straight down)
		
		public static function init():void {
			//Create the various enemy types
			
			ENEMY_PROPERTIES.push(new EnemyProperties(
					10,
					5,
					1,
					64,
					100,
					false,
					100.0,
					1.0,
					"Enemy1Image"
				));
			
			ENEMY_PROPERTIES.push(new EnemyProperties(
				10,
				5,
				2,
				100,
				10,
				false,
				100.0,
				1.0,
				"Enemy2Image"
			));
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
		
    }
}