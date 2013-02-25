package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;
	import tuning.Constants;

	/** Represents a falling experience object in the game world */
	public class XpObject extends GameObject
	{		
		//Velocity of this xp
		public var vel:Vec2;
		
		//Indicates if this xp is active or not still (set to false when exiting game)
		public var alive:Boolean;
		
		protected var props:XpProperties;
		
		//Internal util values (to prevent a lot of object allocation)
		protected var deltaPos:Vec2;
		
		public function XpObject(parentWorld:World)
		{
			super(parentWorld);
			
			this.size.setVals(16,16); //default radius for xp
			
			vel = new Vec2();
			
			alive = true;
			
			deltaPos = new Vec2(); 
		}
		
		public function setProperties(props:XpProperties):void {
			this.props = props;
			
			image = new Image(Assets.getTexture(props.imageName));
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
			
			//Scale collision box based on image
			boundBox.width = image.width;
			boundBox.height = image.height;
			
			updateBoundingBox();
		}
		
		public function getProperties():XpProperties {
			return props;
		}
		
		public override function update(dt:Number):void {
			if (alive == false) return;
			
			//Have xp "fall" downward
			//(note our rough "terminal velocity" approximation)
			//if (vel.y < 0 || vel.y < Constants.XP_TERMINAL_VEL_SQRD)
				vel.y += Constants.XP_GRAVITY;
				
			//Apply damping to XP motion (prevents excess speeds & oscillations from XP magnet)
			vel.scale(Constants.XP_DRAG);
			
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