package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
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
		protected var magnetRadiusSqrd:Number;	//convenience optimization (really necessary/helpful? I dunno...)
		
		public var lastShotTime:Number;
		
		//Graphical components
		protected var shipImg:Image;
		protected var magnetImg:Image;
		
		//Internal util values (to prevent a lot of object allocation)
		protected var delta:Vec2;
		protected var closest:Vec2;
		
		public function Player(parentWorld:World, upgrades:PlayerUpgrades)
		{
			super(parentWorld);
						 
			lastShotTime = 0;
			
			delta = new Vec2();
			closest = new Vec2();
			
			size.setVals(Constants.PLAYER_WIDTH, Constants.PLAYER_HEIGHT);
			
			var imageHolder:Sprite = new Sprite();
			this.image = imageHolder
			
			shipImg = new Image(Assets.getTexture("PlayerImage"));
			shipImg.pivotX = shipImg.width/2;
			shipImg.pivotY = shipImg.height/2;
			imageHolder.addChild(shipImg);
			
			magnetImg = new Image(Assets.getTexture("MagnetImage"));
			magnetImg.pivotX = magnetImg.width/2;
			magnetImg.pivotY = magnetImg.height/2;
			imageHolder.addChildAt(magnetImg, 0);	
			
			setUpgrades(upgrades); //inits stats
		}
		
		//Returns size of graphical ship component of player
		public function get ShipWidth():Number { return shipImg.width; }
		public function get ShipHeight():Number { return shipImg.height; }
		
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
			magnetRadiusSqrd = magnetRadius*magnetRadius;
			
			//No longer upgradeable, as of 2.24.2013
			shotSpeed = Constants.PLAYER_SHOT_SPEED_BASE;//		+ upgrades.shotSpeedLevel * Constants.PLAYER_SHOT_SPEED_UPGRADE;
			shotRadius = Constants.PLAYER_SHOT_RADIUS_BASE;//		+ upgrades.shotRadiusLevel * Constants.PLAYER_SHOT_RADIUS_UPGRADE;
			
			//Update visual magnet radius
			magnetImg.width = magnetImg.height = 2*magnetRadius;
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
		
		//Checks for and applies XP magnet force to given XP object, if within magnet's radius of effect
		public function checkAndApplyMagnet(xpObj:XpObject):void {
			delta.setValsFrom(this.pos);
			delta.sub(xpObj.pos);
			var distToPlayerSqrd:Number = delta.lensqrd();
			//Apply magnetic force if within magnets radius & in front of player
			if (distToPlayerSqrd < magnetRadiusSqrd && xpObj.pos.y < this.boundBox.top) {
				delta.normalize();
				//TODO: Decay magnetic force with distance from player? This would be more "realistic",
				//but may not be the effect we're going for. Just constant force if within magnetic field for now
				//Also, it's helpful to have force stronger in horizontal dir than in vertical
				//(prevents xp from "orbiting" past player as it falls into the magnet)
				//delta.scale(Constants.XP_MAGNET_FORCE_BASE);	
				//xpObj.vel.add(delta);
				var dx:Number = delta.x * Constants.XP_MAGNET_FORCE_BASE;
				var dy:Number = delta.y * Constants.XP_MAGNET_FORCE_BASE * 0.5;
				xpObj.vel.x += dx;
				xpObj.vel.y += dy;
			}
		}
	}
}