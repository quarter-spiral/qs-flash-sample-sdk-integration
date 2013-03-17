package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;
	
	import tuning.Constants;

	/** Just a pretty background star.... no more, no less */
	public class BackgroundStar extends GameObject
	{
		public var baseVel:Vec2;		//basic velocity of this star
		public var alive:Boolean;
		
		protected var speedMult:Number;	//multiplier used to set actual velocity of star
		
		//Internal util values (to prevent a lot of object allocation)
		protected var deltaPos:Vec2;
		
		public function BackgroundStar(parentWorld:World)
		{
			super(parentWorld);
			
			size.setVals(Constants.PLAYER_BULLET_RADIUS*2,Constants.PLAYER_BULLET_RADIUS*2); //default shot radius
			
			baseVel = new Vec2();
			
			alive = true;
			
			image = new Image(Assets.getTexture("StarImage"));
			image.width = 1;
			image.height = 3;
			//image.width = image.height = 2;
			//image.pivotX = image.width/2;
			//image.pivotY = image.height/2;
			
			deltaPos = new Vec2(); 
		}
		
		public function setSpeedMultiplier(mult:Number):void {
			this.speedMult = mult;
		}
		
		public override function update(dt:Number):void {
			if (alive == false) return;
			
			deltaPos.setValsFrom(baseVel);
			deltaPos.scale(dt * speedMult);
			pos.add(deltaPos);
			
			//If moved out of game bounds, no longer alive
			var worldBounds:Rectangle = parentWorld.getWorldBounds();
			if (!worldBounds.intersects(boundBox))
				alive = false;
			
			super.update(dt);
		}
	}
}