package 
{
    import com.quarterspiral.sdk.PlayerInformation;
    import com.quarterspiral.sdk.Sdk;
    import com.quarterspiral.sdk.SdkFactory;
    
    import flash.net.SharedObject;
    import flash.net.registerClassAlias;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    
    import scenes.GameOverScreen;
    import scenes.MainGame;
    import scenes.MainMenu;
    import scenes.Screen;
    import scenes.ui.ActionMessage;
    
    import starling.animation.Juggler;
    import starling.core.Starling;
    import starling.display.BlendMode;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    
    import tuning.Constants;
    
    import world.PlayerInfo;
    import world.World;
    import world.pools.ActionMessagePool;

    public class Game extends Sprite
    {
        private var currentScreen:Screen;
		
		//Main game world (we run it in the bg of all screens, but used to run actual game in MainGame)
		private var gameWorld:World;
		
		private var bg:DisplayObject;		//the absolute farthest backdrop
		private var mainPlane:Sprite;		//container for most gameplay object images
		private var bgPlane:Sprite;			//container for bg gameplay object images;
		private var screenPlane:Sprite;		//container for the various main screens
		private var msgPlane:Sprite;		//container for action messages;
		
		private var activeMsgs:Vector.<ActionMessage>;
		private var  msgPool:ActionMessagePool;	
		
		private var playerInfo:PlayerInfo;
		private var qsSdk:Sdk;
        
        public function Game()
        {
			Constants.init(this);
			
			//Load up local player info, or create a new profile (not shared until a level completes)
			//TODO: versioning of player data (just hacked in for now)
			registerClassAlias("PlayerInfo", PlayerInfo);
			var shootForeverData:SharedObject =SharedObject.getLocal(Constants.LOCAL_DATA_NAME);
			if (shootForeverData.data.localPlayerInfo)
				playerInfo = shootForeverData.data.localPlayerInfo as PlayerInfo;
			
			if (playerInfo == null)
				playerInfo = new PlayerInfo();
			
			qsSdk = SdkFactory.getInstance(Starling.current.nativeStage.root.loaderInfo);
			qsSdk.onPlayerInformationReady(function(playerInformation:PlayerInformation):void {
				playerInfo.name = playerInformation.name;
				if (currentScreen is MainMenu) {
					(currentScreen as MainMenu).refreshFromPlayerInfo();
				}
			});
			
			qsSdk.onPlayerDataReady(function(playerData:Dictionary):void {
				playerInfo.updateFromQSData(playerData);
				if (currentScreen is MainMenu) {
					(currentScreen as MainMenu).refreshFromPlayerInfo();
				}
			});
			
            Starling.current.stage.stageWidth  = Constants.GameWidth;
            Starling.current.stage.stageHeight = Constants.GameHeight;
            Assets.contentScaleFactor = Starling.current.contentScaleFactor;
            
            //Load assets
            Assets.prepareSounds();
            Assets.loadBitmapFonts();
            
            addEventListener(Screen.CLOSING, onScreenClosing);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			activeMsgs = new Vector.<ActionMessage>();
			msgPool = new ActionMessagePool(createActionMsg, cleanActionMsg);
      	}
		
		public function getPlayerInfo():PlayerInfo {
			return playerInfo;
		}
		
		public function getGameWorld():World {
			return gameWorld;
		}
		
		public function showScreen(name:String):void
		{
			//Close current screen?
			if (currentScreen) {
				currentScreen.close();
				screenPlane.removeChild(currentScreen);
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
				screenPlane.addChild(currentScreen);
				currentScreen.start();
			}
		}
		
		//Creates & animates given action message on the screen, using the 
		//main Starling juggler by default unless another juggler is given
		public function addActionMessage(message:String, customJuggler:Juggler = null):void {
			var juggler:Juggler = customJuggler;
			if (juggler == null)
				juggler = Starling.juggler;
			
			var actionMsg:ActionMessage = msgPool.checkOut();
			actionMsg.setText(message);
			msgPlane.addChild(actionMsg.image);
			
			juggler.add(actionMsg);
			activeMsgs.push(actionMsg);
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			//Delegate the frame update to open screen
			if (currentScreen) {
				currentScreen.update(event.passedTime);
			}
			
			//Update global action msgs on screen
			var numActionMsgs:int = activeMsgs.length;
			for (var i:int = numActionMsgs-1; i >= 0; i--) {
				if (activeMsgs[i].isComplete()) {
					var finishedMsg:ActionMessage = activeMsgs.splice(i, 1)[0];
					msgPool.checkIn(finishedMsg);
				}
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
			var data:Dictionary = new Dictionary();
			data['highLevel'] = playerInfo.highLevel;
			data['highTime'] = playerInfo.highTime;
			qsSdk.setPlayerData(data);
		}
        
        private function onAddedToStage(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//Initialize the various display layers
			bg = new Image(Assets.getTexture("Background"));
			bg.blendMode = BlendMode.NONE;
			addChild(bg);
			
			bgPlane = new Sprite();
			bgPlane.touchable = false;
			addChild(bgPlane);
			
			mainPlane = new Sprite();
			mainPlane.touchable = false;
			addChild(mainPlane);
			
			screenPlane = new Sprite();
			screenPlane.touchable = true;
			addChild(screenPlane);
			
			msgPlane = new Sprite();
			msgPlane.touchable = false;
			addChild(msgPlane);
			
			//Create the game world (we'll reuse it across game runs)
			gameWorld = new World(mainPlane, bgPlane);
			
			showScreen("MainMenu");
			//showScene("MainGame"); //DEBUG: Go direct to gameplay
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (gameWorld) {
				gameWorld.dispose();
				gameWorld = null;
			}
        }
        
        private function onKey(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.S)
                Starling.current.showStats = !Starling.current.showStats;
			
			//DEBUG: Add debug action msg
			if (event.keyCode == Keyboard.M)
				addActionMessage("Test Message!");
			
			//Forward the keystroke to current screen
			if (currentScreen)
				currentScreen.onKey(event);
        }
		
        private function onScreenClosing(event:Event):void
        {
            currentScreen.removeFromParent(true);
			currentScreen = null;
        }
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		//Object pool creators/cleaners
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		private function createActionMsg():ActionMessage {
			var msg:ActionMessage = new ActionMessage();
			return msg;
		}
		
		private function cleanActionMsg(msg:ActionMessage):void {
			msg.reset();
			if (msg.image && msg.image.parent) 
				msg.image.parent.removeChild(msg.image);
		}
		///////////////////////////////////////////////////////////////////////////////////////////////
    }
}