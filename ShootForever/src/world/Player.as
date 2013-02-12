package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;

	/** The player's ship in the game world */
	public class Player extends GameObject
	{
		
		//Player traits (affected by levelups)
		public var shotDamage:Number;
		public var shotRate:Number;
		public var shotSpeed:Number;
		public var shotRadius:Number;
		public var magnetRadius:Number;
		

		public var lastShotTime:Number;
		
		//Internal util values (to prevent a lot of object allocation)
		protected var delta:Vec2;
		protected var closest:Vec2;
		
		public function Player(parentWorld:World, upgrades:PlayerUpgrades)
		{
			super(parentWorld);
			
			updateStatsFromUpgrades(upgrades); //inits stats
						 
			lastShotTime = 0;
			
			delta = new Vec2();
			closest = new Vec2();
			
			//Placeholder static image. TODO: animated player image that depends on state
			image = new Image(Assets.getTexture("PlayerImage"));
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
		}
		
		//Sets game stats on this player based on current upgrades
		//Called after user upgrades player traits
		public function updateStatsFromUpgrades(upgrades : PlayerUpgrades):void {
			shotDamage = Constants.PLAYER_SHOT_DAMAGE_BASE		+ upgrades.shotDamageLevel * Constants.PLAYER_SHOT_DAMAGE_UPGRADE;
			shotRate = Constants.PLAYER_SHOTS_PER_SECOND_BASE	+ upgrades.shotRateLevel * Constants.PLAYER_SHOTS_PER_SECOND_UPGRADE;
			shotSpeed = Constants.PLAYER_SHOT_SPEED_BASE		+ upgrades.shotSpeedLevel * Constants.PLAYER_SHOT_SPEED_UPGRADE;
			shotRadius = Constants.PLAYER_SHOT_RADIUS_BASE		+ upgrades.shotRadiusLevel * Constants.PLAYER_SHOT_RADIUS_UPGRADE;
			//magnetRadius = ; //TODO
		}
		
		public function getTimeBetweenShots():Number {
			//Depends on fire rate
			return 1 / shotRate;
		}
		
		//Returns true if player is currently colliding with given rectangle
		public function checkCollisionRect(rect:Rectangle):Boolean {
			//We consider the player to be circular, so do a rectangle-circle collision check
			//(assuming rectangle is axis-aligned)
			
			//Source: http://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection
	
			// Find the closest point to the circle within the rectangle
			closest.setVals(Math.max(Math.min(pos.x, rect.left), rect.right), Math.max(Math.min(pos.y, rect.top), rect.bottom));
			
			// Calculate the distance between the circle's center and this closest point
			delta.setValsFrom(pos);
			delta.sub(closest);
			
			// If the distance is less than the circle's radius, an intersection occurs
			var distSqrd:Number = delta.lensqrd();
			if (distSqrd < Constants.PLAYER_RADIUS * Constants.PLAYER_RADIUS)
				return true;
			
			return false;
		}
		
		//Returns true if player is currently colliding with given point
		public function checkCollisionPoint(x:Number, y:Number):Boolean {
			delta.setVals(x, y);
			delta.sub(this.pos);
			
			if (delta.lensqrd() < Constants.PLAYER_RADIUS*Constants.PLAYER_RADIUS)
				return true;
			
			return false;
		}
	}
}