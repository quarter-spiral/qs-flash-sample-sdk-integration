package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	import tuning.Constants;

	//A bullet/laser/what-have-you fired by the player or an enemy
	public class Bullet extends GameObject
	{
		//Velocity of bullet
		public var vel:Vec2;
		
		//Indicates if this bullet is active or not still (set to false when exiting game)
		public var alive:Boolean;
		
		protected var damage:Number;
	
		//Internal util values (to prevent a lot of object allocation)
		protected var deltaPos:Vec2;
		
		public function Bullet(parentWorld:World)
		{
			super(parentWorld);
			
			size.setVals(Constants.PLAYER_BULLET_RADIUS*2,Constants.PLAYER_BULLET_RADIUS*2); //default shot radius
			
			vel = new Vec2();
			
			alive = true;
			
			//Set initial bullet properties (no damage)
			setDamageLevel(0,0);
			
			deltaPos = new Vec2(); 
		}
		
		//Sets the damage value for this bullet, along with a damage level 
		//(level determines visual appearance of bullet)
		public function setDamageLevel(damage:int, level:int):void {
			this.damage = damage;
			
			var bulletTexture:Texture = null;			
			
			switch (level) {
				case 0: bulletTexture = Assets.getTexture("Bullet0Image"); break;
				case 1: bulletTexture = Assets.getTexture("Bullet1Image"); break;
				case 2: bulletTexture = Assets.getTexture("Bullet2Image"); break;
				case 3: bulletTexture = Assets.getTexture("Bullet3Image"); break;
				case 4:
				default:
					bulletTexture = Assets.getTexture("Bullet4Image"); break;
			}
			
			//Create/update texture for this bullet's image
			var img:Image = Image(this.image); //we know it's an Image, so cast is ok...
			if (img == null) {
				img = new Image(bulletTexture);
				this.image = img;
			}
			else
				img.texture = bulletTexture; 	
			img.pivotX = img.width/2;
			img.pivotY = img.height/2;
		}
		
		public function getDamage():int {
			return damage;
		}
		
		public override function update(dt:Number):void {
			if (alive == false) return;
			
			deltaPos.setValsFrom(vel);
			deltaPos.scale(dt);
			pos.add(deltaPos);
			
			//If moved out of game bounds, no longer alive
			var worldBounds:Rectangle = parentWorld.getWorldBounds();
			if (!worldBounds.intersects(boundBox))
				alive = false;
			
			super.update(dt);
		}
	}
}