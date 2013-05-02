package world
{
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import tuning.Constants;

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
		public var hurtTime:Number = 0;	//time at which this enemy was last damaged
		
		public var currHealth:int;
		public var hasDarted:Boolean;
		
		//The properties object to which we're linked
		public var props:EnemyProperties;
		
		//sets the existence of moveType variable
		public var moveType:int;
		
		//Internal util values (to prevent a lot of object allocation)
		protected var deltaPos:Vec2;
		protected var worldBoundsPadded:Rectangle;
		
		protected var imgHolder:Sprite;
		protected var normalImg:Image;
		protected var hurtImg:Image;
		
		//Time this enemy was hurt
		
		public function Enemy(parentWorld:World)
		{
			super(parentWorld);
			
			startPos = new Vec2();
			vel = new Vec2();
			
			deltaPos = new Vec2();
			worldBoundsPadded = new Rectangle();
			
			//Create a centered holder for enemy graphics
			imgHolder = new Sprite();
			image = imgHolder;
			
			setType(0); //default type
			
			reset();
		}
		
		public function setType(typeNum:int):void {
			this.enemyType = typeNum;
			
			props = Constants.ENEMY_PROPERTIES[typeNum];
			
			//Init health from props
			currHealth = props.maxHealth;
			
			size.setValsFrom(props.size);
			
			loadImages();
		}
		
		//Called when enemy is removed from game, but may be used again
		//(eg: for a pooling system)
		public function reset():void {
			alive = true;
			liveTime = 0;
			hasDarted = false;
			endHurtFlash();
		}
		
		public function setInitialVelocity():void {
			//Initialize velocity based on type
			switch (this.enemyType) {
				case Constants.TREASURE_CHEST_ID:
					vel.setVals(props.speed, 0);
					break;
				case Constants.BASIC_ANGLED_ENEMY_ID:
				case Constants.MEDIUM_ANGLED_ENEMY_ID:
				default:
					switch (this.moveType) {
						case 0:
							vel.setMovement(80,props.speed);
							break;
						case 1:
							vel.setMovement(85,props.speed);
							break;
						case 2:
							vel.setMovement(90,props.speed);
							break;
						case 3:
							vel.setMovement(95,props.speed);
							break;
						case 4:
							vel.setMovement(100,props.speed);
							break;
					}
					
					break;
				case Constants.HORIZONTAL_ENEMY_ID:
					vel.setVals(props.speed, 0);
					break;
				case Constants.DART_ENEMY_ID:
					this.props.dartDelay = 2 + Math.random()*1.5;
					vel.setVals(0, props.speed);
					break;
				case Constants.DART_RIGHT_ENEMY_ID:
					vel.setVals(props.speed, 0);					
					this.props.dartDelay = .5 + Math.random()*.5;
					break;
				case Constants.DART_RIGHT_MED_ID:
					vel.setVals(props.speed, 0);					
					this.props.dartDelay = .5 + Math.random()*.5;
					break;
				case Constants.DART_LEFT_ENEMY_ID:
					vel.setVals(props.speed, 0);			
					this.props.dartDelay = .5 + Math.random()*.5;
					break;
				case Constants.DART_LEFT_MED_ID:
					vel.setVals(props.speed, 0);					
					this.props.dartDelay = .5 + Math.random()*.5;
					break;
				case Constants.SINE_WAVE_ENEMY_ID:
					//Fall down toward bottom of screen (will move sideways as needed)
					vel.setVals(0, props.speed);
					break;
				case Constants.SINE_WAVE_MED_ID:
					//Fall down toward bottom of screen (will move sideways as needed)
					vel.setVals(0, props.speed);
					break;
				case Constants.BASIC_HEAVY_ENEMY_ID:
					//slow movement
					vel.setVals(0, props.speed);
			}
		}
		
		//Loads the graphical image of this baddie. Override for specific enemy types
		public function loadImages():void {
			imgHolder.removeChildren(0, imgHolder.numChildren-1);
			
			//Change image based on movement type
			normalImg = new Image(Assets.getTexture(props.imageName));
			hurtImg = new Image(Assets.getTexture(props.imageName + "Hurt"));
			
			//Be sure image is centered
			imgHolder.pivotX = normalImg.width/2;
			imgHolder.pivotY = normalImg.height/2;
			
			//May have changed type images, so refresh current image
			refreshCurrentEnemyImage();
		}
		
		public function setStartPos(startX:Number, startY:Number):void {
			this.startPos.setVals(startX, startY);
			this.pos.setVals(startX, startY);
		}

		public override function update(dt:Number):void {
			if (alive == false) return;
			
			liveTime += dt;
			
			//Update image based on whether we're doing a "hurt" flash
			if (hurtTime >= 0) {
				if (liveTime > hurtTime + Constants.ENEMY_HURT_FLASH_LENGTH)
					endHurtFlash();
			}
			
			//Update enemy movement based on type
			switch (enemyType) {
				case Constants.SINE_WAVE_ENEMY_ID:
				case Constants.SINE_WAVE_MED_ID:
					var xOffset:Number = Constants.WAVE_ENEMY_SIDE_MOTION_AMPLITUDE * Math.sin(liveTime * 2 * Math.PI / Constants.WAVE_ENEMY_SIDE_MOTION_PERIOD);
					//Find velocity that will snap this bad guy to where he should be, horizontally
					var xDelta:Number = xOffset - (pos.x - startPos.x);
					vel.setVals(xDelta, vel.y);
					break;
				/*case Constants.SINE_WAVE_MED_ID:
					var xOffset:Number = Constants.WAVE_ENEMY_SIDE_MOTION_AMPLITUDE * Math.sin(liveTime * 2 * Math.PI / Constants.WAVE_ENEMY_SIDE_MOTION_PERIOD);
					//Find velocity that will snap this bad guy to where he should be, horizontally
					var xDelta:Number = xOffset - (pos.x - startPos.x);
					vel.setVals(xDelta, vel.y);
					break;*/
			}
			
			//If this enemy dartTarget, do so if it's time
			if (props.dartTarget) {
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
			
			//If this enemy dartStraigth, do so if it's time
			if (props.dartStraight) {
				if (!hasDarted && liveTime > props.dartDelay) {
					//Pause...
					if (liveTime < props.dartDelay + props.dartPause)
						vel.setVals(0,0);
					else {
						//Dart straight forward
						//getDirectionToPlayer(vel);
						//vel.scale(props.speed * props.postDartSpeedMult);
						vel.setVals(0,props.speed * props.postDartSpeedMult);
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
			/*var worldBounds:Rectangle = parentWorld.getWorldBounds();
			worldBoundsPadded.setTo(worldBounds.x - boundBox.width*0.5, 
									worldBounds.y - boundBox.height*0.5, 
									worldBounds.width + boundBox.width*0.5,
									worldBounds.height + boundBox.height*0.5);
			if (!worldBoundsPadded.intersects(boundBox))
				alive = false;
			
			super.update(dt);*/
			
			//ETHAN TEST - kill enemies below screen
			if(pos.y>Constants.GameHeight+50||pos.x<-500||pos.x>Constants.GameHeight+500) 
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
		
		protected function startHurtFlash():void {
			hurtTime = liveTime;
			refreshCurrentEnemyImage();
		}
		
		protected function endHurtFlash():void {
			hurtTime = -1;
			refreshCurrentEnemyImage();
		}
		
		protected function refreshCurrentEnemyImage():void {
			if (imgHolder.numChildren > 0)
				imgHolder.removeChildAt(0);
			
			if (hurtTime < 0 || Constants.ENEMY_FLASH_WHEN_HURT == false)
				imgHolder.addChild(normalImg);
			else
				imgHolder.addChild(hurtImg);
		}
		
		//Applies damage to this enemy and shows graphical "hurt" flash if specified
		public function applyDamage(damage:int, showGraphicalFlash:Boolean):void {
			currHealth -= damage; 
			//"Kill" if health is 0
			if (currHealth <= 0) {
				currHealth = 0;
				alive = false;
				
				switch (this.enemyType) {
					case Constants.BASIC_ANGLED_ENEMY_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_02);
						break;
					case Constants.SINE_WAVE_ENEMY_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_02);
						break;
					case Constants.DART_LEFT_ENEMY_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_02);
						break;
					case Constants.DART_RIGHT_ENEMY_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_02);
						break;
					case Constants.MEDIUM_ANGLED_ENEMY_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_03);
						break;
					case Constants.SINE_WAVE_MED_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_03);
						break;
					case Constants.DART_LEFT_MED_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_03);
						break;
					case Constants.DART_RIGHT_MED_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_03);
						break;
					case Constants.DART_ENEMY_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_01);
						break;
					case Constants.BASIC_HEAVY_ENEMY_ID:
						SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DIE_01);
						break;
				}
			}
			
			if (showGraphicalFlash && damage > 0)
				startHurtFlash();
			
			switch (this.enemyType) {
				case Constants.MEDIUM_ANGLED_ENEMY_ID:
					SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DAMAGE_01);
					break;
				case Constants.SINE_WAVE_MED_ID:
					SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DAMAGE_01);
					break;
				case Constants.DART_LEFT_MED_ID:
					SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DAMAGE_01);
					break;
				case Constants.DART_RIGHT_MED_ID:
					SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DAMAGE_01);
					break;
				case Constants.DART_ENEMY_ID:
					SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DAMAGE_02);
					break;
				case Constants.BASIC_HEAVY_ENEMY_ID:
					SoundManager.getInstance().playSound(SoundManager.SOUND_ENEMY_DAMAGE_02);
					break;
			}
		}
	}
}