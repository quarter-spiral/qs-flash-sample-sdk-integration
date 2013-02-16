package scenes
{
    import flash.ui.Keyboard;
    
    import math.Vec2;
    
    import scenes.ui.XpBar;
    
    import starling.display.Button;
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
    
    import tuning.Constants;
    
    import world.World;
    import world.pools.ImagePool;

	/** Runs the primary gameplay for ShootForever */
    public class MainGame extends Screen
    {
//        private var mStartButton:Button;
//        private var mResultText:TextField;
        
		//UI elements
		private var pauseBtn : Button;
		private var scoreTxt : TextField;	
		private var xpBar : XpBar;
		private var pauseImage : Image;
		private var bombContainer : Sprite;
		
		private var bombPool:ImagePool;
		private var bombsOnBar:Vector.<Image>;
		
		//Most recent mouse position
		private var mousePos:Vec2;
		
		private var paused:Boolean = false;
        
        public function MainGame(parentGame : Game)
        {
            super(parentGame);
			
			bombPool = new ImagePool(createBomb, cleanBomb, 3, 20);
			bombsOnBar = new Vector.<Image>();	

			// Score
			scoreTxt = new TextField(150, 75, "000000", Constants.MAIN_FONT, 20, 0xffffff);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.TOP;
			scoreTxt.x = int(Constants.GameWidth/2 - scoreTxt.width/2);
			this.addChild(scoreTxt);
			
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
			
			//Start the main game
			GameWorld().startMainGame(parentGame.getPlayerInfo());
        }
		
		//Returns game world that this screen affects
		public function GameWorld():World {
			return parentGame.getGameWorld();
		}
		
		public override function start():void {
			//Start listening to the mouse
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		
			//Init XP bar limits for player's current level (may be updated during game as xp is collected) 
			xpBar.setLevel(parentGame.getPlayerInfo().playerLevel);
			updateXPBar();
		}
		
		public override function close(): void {
			if (stage) stage.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
        
        public override function dispose():void
        {
			close();
			
            super.dispose();
        }
        
        public override function update(dt:Number):void
        {
			if (!paused) {
				//Limit size of updates to about 10 Hz to prevent big update steps
				var updateDt:Number = Math.min(dt, 0.1);
					
				//Basically, just update logical game world...
				GameWorld().updateLogic(updateDt);
				//Then update the graphical representation thereof
				GameWorld().updateGraphics();
				
				//Update score/XP (TODO: these don't always need to be updated every frame. Update only on events from GameWorld())
				updateTimeText();
				updateXPBar();
				updateBombsBar();
				
				//If player is dead, finish the game 
				if (GameWorld().isPlayerAlive == false)
					runGameEnd();
			}
        }
		
		private function onTouch(event:TouchEvent):void
		{
			if (GameWorld()) {
				//Just extract the mouse position, which is all we want
				var touch:Touch = event.getTouch(stage);
				if (touch)
				{
					GameWorld().mousePos.x = touch.globalX;
					GameWorld().mousePos.y = touch.globalY;
					
					//Record a mouse click to the game for handling
					if (touch.phase == TouchPhase.BEGAN) {
						//Hacky, but ignore the touch if its on the pause button (nested 2 levels deep)
						var isPauseClick:Boolean = touch.target && touch.target.parent && touch.target.parent.parent == pauseBtn
						
						if (!isPauseClick)
							GameWorld().mouseClicked = true;
					}
				}
			}
		}
		
		private function updateTimeText():void {
			scoreTxt.text = GameWorld().gameInfo.getPlayerLiveTime().toFixed(2);
		}
		
		private function updateXPBar():void {
			xpBar.setCurrXp(GameWorld().gameInfo.getXp());
			
			//If player leveled up, update the XP bar limits
			if (GameWorld().gameInfo.getLevel() >  xpBar.getLevel()) 
				xpBar.setLevel(GameWorld().gameInfo.getLevel());
		}
		
		private function updateBombsBar():void {
			var numBombsDelta:int = GameWorld().gameInfo.currBombs - bombsOnBar.length;
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
				GameWorld().killPlayer(false);
				runGameEnd();
			}
			else if (event.keyCode == Keyboard.X) {
				GameWorld().awardXpToPlayer(200);
			}
			else if (event.keyCode == Keyboard.T) {
				GameWorld().spawnObject(Constants.TREASURE_CHEST_ID);
			}
			else if (event.keyCode == Keyboard.B) {
				GameWorld().gameInfo.currBombs++;
			}
		}
		
		private function runGameEnd():void {
			GameWorld().endMainGame();
			
			//Save the game info
			parentGame.getPlayerInfo().latestGameInfo = GameWorld().gameInfo;
			
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