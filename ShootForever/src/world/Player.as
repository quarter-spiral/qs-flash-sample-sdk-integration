package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;
	
	import tuning.Constants;

	/** The player's ship in the game world */
	public class Player extends GameObject
	{
		
		//Current upgrades for this player
		public var upgrades:PlayerUpgrades;
		
		//Player traits (affected by levelups)
		public var shotDamage:Number;
		public var shotRate:Number;
		public var shotSpeed:Number;
		public var shotRadius:Number;
		public var shotNum:Number;
		public var magnetRadius:Number;
		
		public var lastShotTime:Number;
		
		//Internal util values (to prevent a lot of object allocation)
		protected var delta:Vec2;
		protected var closest:Vec2;
		
		public function Player(parentWorld:World, upgrades:PlayerUpgrades)
		{
			super(parentWorld);
			
			setUpgrades(upgrades); //inits stats
						 
			lastShotTime = 0;
			
			delta = new Vec2();
			closest = new Vec2();
			
			size.setVals(Constants.PLAYER_WIDTH, Constants.PLAYER_HEIGHT);
			
			//Placeholder static image. TODO: animated player image that depends on state
			image = new Image(Assets.getTexture("PlayerImage"));
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
		}
		
		//Sets the current upgrades for this player & sets its gameplay stats on those upgrades
		public function setUpgrades(upgrades : PlayerUpgrades):void {
			//Null upgrades object not allowed, so creat a default one if given null...
			if (upgrades == null)
				upgrades = new PlayerUpgrades();
			this.upgrades = upgrades;
	
			shotRate = Constants.PLAYER_SHOTS_PER_SECOND_BASE	+ upgrades.shotRateLevel * Constants.PLAYER_SHOTS_PER_SECOND_UPGRADE;
			shotDamage = Constants.PLAYER_SHOT_DAMAGE_BASE		+ upgrades.shotDamageLevel * Constants.PLAYER_SHOT_DAMAGE_UPGRADE;
			shotNum = Constants.PLAYER_SHOT_NUMBER_BASE 		+ upgrades.shotNumLevel * Constants.PLAYER_SHOT_NUMBER_UPGRADE;
			magnetRadius = Constants.PLAYER_MAGNET_RADIUS_BASE 	+ upgrades.magnetRadiusLevel * Constants.PLAYER_MAGNET_RADIUS_UPGRADE;
			
			//No longer upgradeable, as of 2.24.2013
			shotSpeed = Constants.PLAYER_SHOT_SPEED_BASE;//		+ upgrades.shotSpeedLevel * Constants.PLAYER_SHOT_SPEED_UPGRADE;
			shotRadius = Constants.PLAYER_SHOT_RADIUS_BASE;//		+ upgrades.shotRadiusLevel * Constants.PLAYER_SHOT_RADIUS_UPGRADE;
			
		}
		
		//Returns current upgrades for this player
		public function getUpgrades():PlayerUpgrades {
			return upgrades;
		}
		
		public function getTimeBetweenShots():Number {
			//Depends on fire rate
			return 1 / shotRate;
		}
		
		//Returns true if player is currently colliding with given rectangle
		public function checkCollisionRect(rect:Rectangle):Boolean {
			return boundBox.intersects(rect);
			
			//TODO: Switch back to circle-rectangle collisions if we have time in the future
		}
	}
}