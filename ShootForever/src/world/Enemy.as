package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;

	//A logical enemy of the player in the game world
	public class Enemy extends GameObject
	{		
		//Start position of enemy
		public var startPos:Vec2;
		
		//Velocity of enemy
		public var vel:Vec2;
		//Indicates if this enemy is active or not still (set to false when exiting game)
		public var alive:Boolean;
		public var enemyType:int = 0;
		
		public var liveTime:Number = 0; //time this enemy has been alive
		
		public var currHealth:int;
		public var hasDarted:Boolean;
		
		//The properties object to which we're linked
		public var props:EnemyProperties;
		
		//Internal util values (to prevent a lot of object allocation)
		protected var deltaPos:Vec2;
		protected var worldBoundsPadded:Rectangle;
		
		public function Enemy(parentWorld:World)
		{
			super(parentWorld);
			
			startPos = new Vec2();
			vel = new Vec2();
			
			deltaPos = new Vec2();
			worldBoundsPadded = new Rectangle();
			
			setType(0); //default type
		}
		
		public function setType(typeNum:int):void {
			this.enemyType = typeNum;
			
			props = Constants.ENEMY_PROPERTIES[typeNum];
			
			//Init health from props
			currHealth = props.maxHealth;
			
			size.setValsFrom(props.size);
			
			loadImage();
		}
		
		public function setInitialVelocity():void {
			//Initialize velocity based on type
			switch (this.enemyType) {
				case Constants.TREASURE_CHEST_ID:
					vel.setVals(props.speed, 0);
					break;
				case Constants.BASIC_ANGLED_ENEMY_ID:
				default:					
					//Set movement direction toward player's position
					getDirectionToPlayer(vel);
					vel.scale(props.speed);
					break;
				case Constants.HORIZONTAL_ENEMY_ID:
					vel.setVals(props.speed, 0);
					break;
				case Constants.DART_ENEMY_ID:
					vel.setVals(0, props.speed);
					break;
				case Constants.DART_HORIZONTAL_ENEMY_ID:
					vel.setVals(props.speed, 0);
					break;
				case Constants.SINE_WAVE_ENEMY_ID:
					//Fall down toward bottom of screen (will move sideways as needed)
					vel.setVals(0, props.speed);
					break;
			}
		}
		
		//Loads the graphical image of this baddie. Override for specific enemy types
		public function loadImage():void {
			//TODO: clear any existing image?
			
			//Change image based on movement type
			image = new Image(Assets.getTexture(props.imageName));
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
		}
		
		public function setStartPos(startX:Number, startY:Number):void {
			this.startPos.setVals(startX, startY);
			this.pos.setVals(startX, startY);
		}

		public override function update(dt:Number):void {
			if (alive == false) return;
			
			liveTime += dt;
			
			//Update enemy movement based on type
			switch (enemyType) {
				case Constants.SINE_WAVE_ENEMY_ID:
					var xOffset:Number = Constants.WAVE_ENEMY_SIDE_MOTION_AMPLITUDE * Math.sin(liveTime * 2 * Math.PI / Constants.WAVE_ENEMY_SIDE_MOTION_PERIOD);
					//Find velocity that will snap this bad guy to where he should be, horizontally
					var xDelta:Number = xOffset - (pos.x - startPos.x);
					vel.setVals(xDelta, vel.y);
					break;
			}
			
			//If this enemy darts, do so if it's time
			if (props.darts) {
				if (!hasDarted && liveTime > props.dartDelay) {
					//Pause...
					if (liveTime < props.dartDelay + props.dartPause)
						vel.setVals(0,0);
					else {
						//Dart toward the player's current position
						getDirectionToPlayer(vel);
						vel.scale(props.speed * props.postDartSpeedMult);
						hasDarted = true;
					}
						
				}
			}
			
			//Move in direction of current velocity
			deltaPos.setValsFrom(vel);
			deltaPos.scale(dt);
			pos.add(deltaPos);
			
			deltaPos.setValsFrom(vel);
			deltaPos.scale(dt);
			pos.add(deltaPos);
			
			//If moved out of game bounds, no longer alive
			//(note that we expand the "out of bounds" area a bit so that enemies can start off-screen)
			var worldBounds:Rectangle = parentWorld.getWorldBounds();
			worldBoundsPadded.setTo(worldBounds.x - boundBox.width*0.5, 
									worldBounds.y - boundBox.height*0.5, 
									worldBounds.width + boundBox.width*0.5,
									worldBounds.height + boundBox.height*0.5);
			if (!worldBoundsPadded.intersects(boundBox))
				alive = false;
			
			super.update(dt);
		}
		
		//Sets given vector to be a unit vector in the direction of the player, or a zero-length vector
		//if the player is not currently in the world
		public function getDirectionToPlayer(dir:Vec2):void {
			if (parentWorld.getPlayer()) {
				dir.setValsFrom(parentWorld.getPlayer().pos);
				dir.sub(this.pos);
				dir.normalize();
			}
			else {
				dir.setVals(0,0);
			}
		}
	}
}