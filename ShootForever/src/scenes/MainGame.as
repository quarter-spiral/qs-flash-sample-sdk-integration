package scenes
{
    import flash.ui.Keyboard;
    
    import math.Vec2;
    
    import scenes.ui.XpBar;
    
    import starling.display.BlendMode;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    import world.World;
    import world.pools.ImagePool;

	/** Runs the primary gameplay for ShootForever */
    public class MainGame extends Screen
    {
//        private var mStartButton:Button;
//        private var mResultText:TextField;
		
		private var bg:DisplayObject;		//the absolute farthest backdrop
		private var mainPlane:Sprite;		//container for most gameplay object images
		private var bgPlane:Sprite;			//container for bg gameplay object images;
        
		//UI elements
		private var pauseBtn : Button;
		private var scoreTxt : TextField;	
		private var scoreMultTxt : TextField;
		private var xpBar : XpBar;
		private var pauseImage : Image;
		private var bombContainer : Sprite;
		
		private var bombPool:ImagePool;
		private var bombsOnBar:Vector.<Image>;
		
		//Most recent mouse position
		private var mousePos:Vec2;
		
		private var paused:Boolean = false;
		
		private var gameWorld:World;
        
        public function MainGame(parentGame : Game)
        {
            super(parentGame);
			
			bombPool = new ImagePool(createBomb, cleanBomb, 3, 20);
			bombsOnBar = new Vector.<Image>();
            
			bg = new Image(Assets.getTexture("Background"));
			bg.blendMode = BlendMode.NONE;
			addChild(bg);
			
			bgPlane = new Sprite();
			bgPlane.touchable = false;
			addChild(bgPlane);
			
			mainPlane = new Sprite();
			mainPlane.touchable = false;
			addChild(mainPlane);	

			// Score
			scoreTxt = new TextField(150, 75, "000000", Constants.MAIN_FONT, 20, 0xffffff);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.TOP;
			scoreTxt.x = int(Constants.GameWidth/2 - scoreTxt.width/2);
			this.addChild(scoreTxt);
			
			//Score multiplier
			scoreMultTxt = new TextField(100,75, "", Constants.MAIN_FONT, 30, 0xffffff);
			scoreMultTxt.hAlign = HAlign.CENTER;
			scoreMultTxt.vAlign = VAlign.TOP;
			scoreMultTxt.x = int(Constants.GameWidth/2 - scoreMultTxt.width/2);
			scoreMultTxt.y = scoreTxt.y + 25;
			this.addChild(scoreMultTxt);
			
			//XP
			xpBar = new XpBar(true);
			xpBar.x = Constants.GameWidth - xpBar.width - 5;
			xpBar.y = Constants.GameHeight - xpBar.height - 5;
			this.addChild(xpBar);
			
			//Bomb container
			bombContainer = new Sprite();
			bombContainer.x = 5;
			bombContainer.y = Constants.GameHeight - 20;
			this.addChild(bombContainer);
			
			//Pause button/cover image
			pauseImage = new Image(Assets.getTexture("BlackSquare"));
			pauseImage.scaleX = Constants.GameWidth;
			pauseImage.scaleY = Constants.GameHeight;
			pauseImage.alpha = 0.6;
			addChild(pauseImage);
			pauseImage.touchable = false;
			pauseImage.visible = false;
			pauseBtn = new Button(Assets.getTexture("PauseImage"));
			pauseBtn.addEventListener(Event.TRIGGERED, onPauseClick);
			pauseBtn.x = Constants.GameWidth - pauseBtn.width;
			pauseBtn.y = 0;
			addChild(pauseBtn);
			
			//Create the game world
			gameWorld = new World(mainPlane, bgPlane);
			gameWorld.init(parentGame.getPlayerInfo());
        }
		
		public override function start():void {
			//Start listening to the mouse
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//Start main game loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
			//Init XP bar limits for player's current level (may be updated during game as xp is collected) 
			xpBar.setLevel(parentGame.getPlayerInfo().playerLevel);
			updateXPBar();
		}
		
		public override function close(): void {
			if (stage) stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
        
        public override function dispose():void
        {
			close();
			
			if (gameWorld) {
				gameWorld.dispose();
				gameWorld = null;
			}
            super.dispose();
        }
        
        private function onEnterFrame(event:EnterFrameEvent):void
        {
			if (!paused) {
				//Limit size of updates to about 10 Hz to prevent big update steps
				var updateDt:Number = Math.min(event.passedTime, 0.1);
					
				//Basically, just update logical game world...
				gameWorld.update(updateDt);
				//Then update the graphical representation thereof
				gameWorld.updateGraphics();
				
				//Update score/XP (TODO: these don't always need to be updated every frame. Update only on events from gameWorld)
				updateScoreText();
				updateXPBar();
				updateBombsBar();
				
				//If player is dead, finish the game 
				if (gameWorld.isPlayerAlive == false)
					runGameEnd();
			}
        }
		
		private function onTouch(event:TouchEvent):void
		{
			if (gameWorld) {
				//Just extract the mouse position, which is all we want
				var touch:Touch = event.getTouch(stage);
				if (touch)
				{
					gameWorld.mousePos.x = touch.globalX;
					gameWorld.mousePos.y = touch.globalY;
					
					if (touch.phase == TouchPhase.BEGAN)
						gameWorld.mouseClicked = true;
				}
			}
		}
		
		private function updateScoreText():void {
			scoreMultTxt.text = "x" + gameWorld.gameInfo.currMultiplier.toString();
			scoreTxt.text = gameWorld.gameInfo.getScore().toString();
		}
		
		private function updateXPBar():void {
			xpBar.setCurrXp(gameWorld.gameInfo.getXp());
			
			//If player leveled up, update the XP bar limits
			if (gameWorld.gameInfo.getLevel() >  xpBar.getLevel()) 
				xpBar.setLevel(gameWorld.gameInfo.getLevel());
		}
		
		private function updateBombsBar():void {
			var numBombsDelta:int = gameWorld.gameInfo.currBombs - bombsOnBar.length;
			var i:int = 0;
			//Remove as needed...
			if (numBombsDelta < 0) {
				var removedBombs:Vector.<Image> = bombsOnBar.splice(bombsOnBar.length + numBombsDelta, -numBombsDelta);
				for (i = 0; i < removedBombs.length; i++) 
					bombPool.checkIn(removedBombs[i]);
			}
			//Add as needed...
			else if (numBombsDelta > 0) {
				for (i = 0; i < numBombsDelta; i++) {
					var bomb:Image = bombPool.checkOut();
					bomb.x = bombsOnBar.length * bomb.width;
					bombContainer.addChild(bomb);
					bombsOnBar.push(bomb);
				}
			}
		}
		
		private function onPauseClick(event:Event):void {
			paused = !paused;
			pauseImage.visible = paused;
		}
		
		public override function onKey(event:KeyboardEvent):void {
			//Debug hotkeys
			if (event.keyCode == Keyboard.K) {
				gameWorld.killPlayer(false);
				runGameEnd();
			}
			else if (event.keyCode == Keyboard.X) {
				gameWorld.awardXpToPlayer(200);
			}
			else if (event.keyCode == Keyboard.T) {
				gameWorld.spawnEnemy(Constants.TREASURE_CHEST_ID);
			}
			else if (event.keyCode == Keyboard.B) {
				gameWorld.gameInfo.currBombs++;
			}
		}
		
		private function runGameEnd():void {
			//Save the game info
			parentGame.getPlayerInfo().latestGameInfo = gameWorld.gameInfo;
			
			//Open the game over screen
			parentGame.showScreen("GameOver");
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		//Object pool creators/cleaners
		///////////////////////////////////////////////////////////////////////////////////////////////
		private function createBomb():Image {
			var bomb:Image = new Image(Assets.getTexture("BombImage"));
			return bomb;
		}
		
		private function cleanBomb(bomb:Image):void {
			if (bomb.parent) bomb.parent.removeChild(bomb);
		}
    }
}