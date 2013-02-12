package 
{
    import flash.ui.Keyboard;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import scenes.MainGame;
    import scenes.MainMenu;
    import scenes.Screen;
    
    import starling.core.Starling;
    import starling.display.BlendMode;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.VAlign;
    
    import world.PlayerInfo;

    public class Game extends Sprite
    {
        private var currentScreen:Screen;
		
		private var playerInfo:PlayerInfo;
        
        public function Game()
        {
			Constants.init();
			
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
		
		public function showScene(name:String):void
		{
			//Close current screen?
			if (currentScreen) {
				currentScreen.close();
				currentScreen = null;
			}
			
			//Create the requested screen
			//TODO: later, we might want to save & reuse screens
			switch (name) {
				case "MainMenu": currentScreen = new MainMenu(this); break;
				case "MainGame": currentScreen = new MainGame(this); break;
			}
			if (currentScreen) {
				addChild(currentScreen);
				currentScreen.start();
			}
		}
        
        private function onAddedToStage(event:Event):void
        {
            //stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			
			showScene("MainMenu");
			//showScene("MainGame"); //DEBUG: Go direct to gameplay
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            //stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onKey(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.S)
                Starling.current.showStats = !Starling.current.showStats;
        }
		
        private function onScreenClosing(event:Event):void
        {
            currentScreen.removeFromParent(true);
			currentScreen = null;
        }
    }
}