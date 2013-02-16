package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;
	import tuning.Constants;

	//A bullet/laser/what-have-you fired by the player or an enemy
	public class Bullet extends GameObject
	{
		//Velocity of bullet
		public var vel:Vec2;
		
		//Indicates if this bullet is active or not still (set to false when exiting game)
		public var alive:Boolean;
		
		public var damage:Number;
	
		//Internal util values (to prevent a lot of object allocation)
		protected var deltaPos:Vec2;
		
		public function Bullet(parentWorld:World)
		{
			super(parentWorld);
			
			size.setVals(Constants.PLAYER_BULLET_RADIUS*2,Constants.PLAYER_BULLET_RADIUS*2); //default shot radius
			
			vel = new Vec2();
			
			alive = true;
			
			image = new Image(Assets.getTexture("BulletImage"));
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
			
			deltaPos = new Vec2(); 
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