package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;

	//A logical enemy of the player in the game world
	public class Enemy extends GameObject
	{		
		//Velocity of enemy
		public var vel:Vec2;
		//Indicates if this enemy is active or not still (set to false when exiting game)
		public var alive:Boolean;
		public var enemyType:int = 0;
		
		//The properties object to which we're linked
		public var props:EnemyProperties;
		
		public var boundBox:Rectangle;
		
		//Internal util values (to prevent a lot of object allocation)
		protected var deltaPos:Vec2;
		protected var worldBoundsPadded:Rectangle;
		
		public function Enemy(parentWorld:World)
		{
			super(parentWorld);
			
			vel = new Vec2();
			
			deltaPos = new Vec2();
			boundBox = new Rectangle();
			worldBoundsPadded = new Rectangle();
			
			setType(0); //default type
		}
		
		public function setType(typeNum:int):void {
			this.enemyType = typeNum;
			
			props = Constants.ENEMY_PROPERTIES[typeNum];
			
			//Initialize velocity based on type
			switch (typeNum) {
				case 0:
				default:
					//Fall down toward bottom of screen at an angle
					var xVel:Number = props.speed * Math.sin(Constants.BASIC_ENEMY_ATTACK_ANGLE);
					var yVel:Number = props.speed * Math.cos(Constants.BASIC_ENEMY_ATTACK_ANGLE);
					vel.setVals(xVel, yVel); 	
					break;
				case 1:
					//TODO
					break;
			}
			
			loadImage();
		}
		
		//Loads the graphical image of this baddie. Override for specific enemy types
		public function loadImage():void {
			//TODO: clear any existing image?
			
			//Change image based on movement type
			image = new Image(Assets.getTexture(props.imageName));
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
		}

		public override function update(dt:Number):void {
			//Update enemy movement based on type
			switch (enemyType) {
				case 1:
				default:
					//No updates...
					break;
			}
			
			//Move in direction of current velocity
			deltaPos.setValsFrom(vel);
			deltaPos.scale(dt);
			pos.add(deltaPos);
			
			deltaPos.setValsFrom(vel);
			deltaPos.scale(dt);
			pos.add(deltaPos);
			
			boundBox.setTo(pos.x-props.radius*0.5, pos.y-props.radius*0.5, props.radius, props.radius);
			
			//If moved out of game bounds, no longer alive
			//(note that we expand the "out of bounds" area a bit so that enemies can start off-screen)
			var worldBounds:Rectangle = parentWorld.getWorldBounds();
			worldBoundsPadded.setTo(worldBounds.x - boundBox.width*0.5, 
									worldBounds.y - boundBox.height*0.5, 
									worldBounds.width + boundBox.width*0.5,
									worldBounds.height + boundBox.height*0.5);
			if (!worldBoundsPadded.intersects(boundBox))
				alive = false;
		}
	}
}