package 
{
    import flash.net.SharedObject;
    import flash.net.registerClassAlias;
    import flash.ui.Keyboard;
    
    import scenes.GameOverScreen;
    import scenes.MainGame;
    import scenes.MainMenu;
    import scenes.Screen;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    
    import world.PlayerInfo;

    public class Game extends Sprite
    {
        private var currentScreen:Screen;
		
		private var playerInfo:PlayerInfo;
        
        public function Game()
        {
			Constants.init();
			
			//Load up local player info, or create a new profile (not shared until a level completes)
			//TODO: versioning of player data (just hacked in for now)
			registerClassAlias("PlayerInfo", PlayerInfo);
			var shootForeverData:SharedObject =SharedObject.getLocal(Constants.LOCAL_DATA_NAME);
			if (shootForeverData.data.localPlayerInfo)
				playerInfo = shootForeverData.data.localPlayerInfo as PlayerInfo;
			
			if (playerInfo == null)
				playerInfo = new PlayerInfo();
			
            Starling.current.stage.stageWidth  = Constants.GameWidth;
            Starling.current.stage.stageHeight = Constants.GameHeight;
            Assets.contentScaleFactor = Starling.current.contentScaleFactor;
            
            //Load assets
            Assets.prepareSounds();
            Assets.loadBitmapFonts();
            
            addEventListener(Screen.CLOSING, onScreenClosing);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
      	}
		
		public function getPlayerInfo():PlayerInfo {
			return playerInfo;
		}
		
		public function showScreen(name:String):void
		{
			//Close current screen?
			if (currentScreen) {
				currentScreen.close();
				removeChild(currentScreen);
				currentScreen = null;
			}
			
			//Create the requested screen
			//TODO: later, we might want to save & reuse screens
			switch (name) {
				case "MainMenu": currentScreen = new MainMenu(this); break;
				case "MainGame": currentScreen = new MainGame(this); break;
				case "GameOver": currentScreen = new GameOverScreen(this); break;
			}
			if (currentScreen) {
				addChild(currentScreen);
				currentScreen.start();
			}
		}
		
		public function resetPlayerInfo():void {
			//Save an empty profile to disk
			playerInfo = new PlayerInfo();
			var shootForeverData:SharedObject = SharedObject.getLocal(Constants.LOCAL_DATA_NAME);
			shootForeverData.data.localPlayerInfo = playerInfo;
			shootForeverData.flush();
		}
		
		public function savePlayerInfo():void {
			var shootForeverData:SharedObject = SharedObject.getLocal(Constants.LOCAL_DATA_NAME);
			shootForeverData.data.localPlayerInfo = playerInfo;
			shootForeverData.flush();
		}
        
        private function onAddedToStage(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			
			showScreen("MainMenu");
			//showScene("MainGame"); //DEBUG: Go direct to gameplay
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onKey(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.S)
                Starling.current.showStats = !Starling.current.showStats;
			
			//Forward the keystroke to current screen
			if (currentScreen)
				currentScreen.onKey(event);
        }
		
        private function onScreenClosing(event:Event):void
        {
            currentScreen.removeFromParent(true);
			currentScreen = null;
        }
    }
}