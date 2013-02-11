package world
{
	import starling.display.Image;

	/** The player's ship in the game world */
	public class Player extends GameObject
	{
		
		//Player traits (affected by levelups)
		public var shotDamage:Number;
		public var shotRate:Number;
		public var shotSpeed:Number;
		public var shotRadius:Number;
		public var magnetRad:Number;
		
		public var lastShotTime:Number;
		
		public function Player(parentWorld:World)
		{
			super(parentWorld);
			
			shotDamage = 0;
			shotRate = Constants.PLAYER_SHOTS_PER_SECOND_BASE;
			shotSpeed = Constants.PLAYER_SHOT_SPEED_BASE;
			shotRadius = Constants.PLAYER_SHOT_RADIUS_BASE;
			magnetRad = 0;
						 
			lastShotTime = 0;
			
			//Placeholder static image. TODO: animated player image that depends on state
			image = new Image(Assets.getTexture("PlayerImage"));
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
		}
		
		public function getTimeBetweenShots():Number {
			//Depends on fire rate
			return 1 / shotRate;
		}
		
		public function collideWithEnemies(enemies:Vector.<Enemy>):void {
			//TODO: check for collision with bad guys, run update logic if collision occurs
			//use Constants.PLAYER_RADIUS to check
		}
	}
}