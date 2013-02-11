package 
{
    import flash.ui.Keyboard;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import scenes.MainGame;
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

    public class Game extends Sprite
    {
        private var currentScreen:Screen;
        
        public function Game()
        {
            Starling.current.stage.stageWidth  = Constants.GameWidth;
            Starling.current.stage.stageHeight = Constants.GameHeight;
            Assets.contentScaleFactor = Starling.current.contentScaleFactor;
            
            //Load assets
            Assets.prepareSounds();
            Assets.loadBitmapFonts();
            
            var scenesToCreate:Array = [
                ["scenes.MainGame", MainGame]
            ];
            
//            var buttonTexture:Texture = Assets.getTexture("ButtonBig");
//            var count:int = 0;
//            
//            for each (var sceneToCreate:Array in scenesToCreate)
//            {
//                var sceneTitle:String = sceneToCreate[0];
//                var sceneClass:Class  = sceneToCreate[1];
//                
//                var button:Button = new Button(buttonTexture, sceneTitle);
//                button.x = count % 2 == 0 ? 28 : 167;
//                button.y = 160 + int(count / 2) * 52;
//                button.name = getQualifiedClassName(sceneClass);
//                button.addEventListener(Event.TRIGGERED, onButtonTriggered);
//                mMainMenu.addChild(button);
//                ++count;
//            }
            
            addEventListener(Screen.CLOSING, onScreenClosing);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            
//            // show information about rendering method (hardware/software)
//            
//            var driverInfo:String = Starling.context.driverInfo;
//            var infoText:TextField = new TextField(310, 64, driverInfo, "Verdana", 10);
//            infoText.x = 5;
//            infoText.y = 475 - infoText.height;
//            infoText.vAlign = VAlign.BOTTOM;
//            infoText.touchable = false;
//            mMainMenu.addChild(infoText);
        }
        
        private function onAddedToStage(event:Event):void
        {
            //stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			
			//DEBUG: Go direct to gameplay
			showScene("scenes.MainGame");
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            //stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onKey(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.S)
                Starling.current.showStats = !Starling.current.showStats;
//            else if (event.keyCode == Keyboard.X)
//                Starling.context.dispose();
        }
        
        private function onButtonTriggered(event:Event):void
        {
            var button:Button = event.target as Button;
            showScene(button.name);
        }
        
        private function onScreenClosing(event:Event):void
        {
            currentScreen.removeFromParent(true);
			currentScreen = null;
        }
        
        private function showScene(name:String):void
        {
			//TODO: Close current screen?
            //if (currentScree/n) currentScreen.di
            
            var screenClass:Class = getDefinitionByName(name) as Class;
            currentScreen = new screenClass() as Screen;
            addChild(currentScreen);
			currentScreen.start();
        }
    }
}