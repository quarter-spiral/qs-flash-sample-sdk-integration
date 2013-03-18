package world
{
	import math.Vec2;

	public class EnemyProperties
	{
		public var killScore:int		= 0;
		public var killXpCoins:int		= 1;	//xp coins spawned on kill
		public var maxHealth:int		= 1;
		public var size:Vec2			= new Vec2();
		public var speed:int			= 0;
		public var imageName:String		= "";
		public var harmsPlayer:Boolean	= true;	//false for the treasure chest
		
		//Darting behavior
		public var dartTarget:Boolean = false;		//darts in vector toward player at time of dart
		public var dartStraight:Boolean = false;	//darst straight forward at time of dart
		public var dartDelay:Number = 0;			//time after spawn that enemy pauses before dart, in seconds
		public var dartPause:Number = 0; 			//duration of pause before darting, in seconds
		public var postDartSpeedMult:Number = 1.0;	//multiplier on speed after darting
		
		//Misc
		public var hitSound:String = "";			//hit/death sound name
		
		public function EnemyProperties()
		{
		
		}
	}
}