package world
{
	public class EnemyProperties
	{
		public var killScore:int;
		public var killXp:int;
		public var radius:int;
		public var speed:int;
		public var shoots:Boolean;
		public var shotSpeed:Number;
		public var shotsPerSecond:Number;
		public var imageName:String;
		
		public function EnemyProperties(
			killScore:int,
			killXp:int,
			radius:int,
			speed:int,
			shoots:Boolean,
			shotSpeed:Number,
			shotsPerSecond:Number,
			imageName:String
		)
		{
			this.killScore = killScore;
			this.killXp = killXp;
			this.radius = radius;
			this.speed = speed;
			this.speed = speed;
			this.shoots = shoots;
			this.shotSpeed = shotSpeed;
			this.shotsPerSecond = shotsPerSecond;
			this.imageName = imageName;
		}
	}
}