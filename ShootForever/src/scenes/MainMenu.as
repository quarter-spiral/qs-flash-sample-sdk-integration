package scenes
{	
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import scenes.ui.ToggleButton;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import tuning.Constants;
	
	import world.World;

	/** Main menu shown to player at game startup */
	public class MainMenu extends Screen
	{
		//UI elements
		//private var gameTitleLbl: TextField;
		private var gameTitleLogo : Image;
		private var startBtn : Button;
		private var clearDataBtn : Button;
		private var playerNameTxt:TextField;
		private var highScoreLbl:TextField;
		private var highScoreTxt:TextField;
		private var rankLbl:TextField;
		private var rankTxt:TextField;
		private var musicBtn : ToggleButton;
		private var soundBtn : ToggleButton;
		private var logoBtn : Button;
		
		public function MainMenu(parentGame:Game)
		{
			super(parentGame);
			
			//TEST: Set better-than-initial player stats
			//parentGame.getPlayerInfo().playerLevel = 3;
			//parentGame.getPlayerInfo().highScore = 12345;
			
			//Game title
			/*gameTitleLbl = new TextField(400, 200, "IMPOSSI\nBATTLE", Constants.MAIN_FONT, 48, 0xFF43FF);
			gameTitleLbl.hAlign = HAlign.CENTER;
			gameTitleLbl.vAlign = VAlign.TOP;
			gameTitleLbl.bold = true;
			gameTitleLbl.x = int(Constants.GameWidth/2 - gameTitleLbl.width/2);
			gameTitleLbl.y = 25;
			this.addChild(gameTitleLbl);*/
			
			//logo
			gameTitleLogo = new Image(Assets.getTexture("LogoImage"));
			gameTitleLogo.x = int(Constants.GameWidth/2 - gameTitleLogo.width/2);
			gameTitleLogo.y = 35;
			this.addChild(gameTitleLogo);
			
			//Start button
			startBtn = new Button(Assets.getTexture("StartImage"), "");
			startBtn.addEventListener(Event.TRIGGERED, onStartClick);
			startBtn.x = Constants.GameWidth/2 - startBtn.width/2;
			startBtn.y = 425;
			addChild(startBtn);
			
			//Player welcome
			playerNameTxt = new TextField(400, 75, "Welcome back", Constants.MAIN_FONT, 22, 0xF9B0FF);
			playerNameTxt.hAlign = HAlign.CENTER;
			playerNameTxt.vAlign = VAlign.TOP;
			playerNameTxt.alpha = .85;
			playerNameTxt.blendMode = "add";
			//playerNameTxt.bold = true;
			playerNameTxt.x = int(Constants.GameWidth/2 - playerNameTxt.width/2);
			playerNameTxt.y = 165;
			this.addChild(playerNameTxt);
			
			//best time label
			highScoreLbl = new TextField(400, 75, "Your best time", Constants.MAIN_FONT, 24, 0xF9B0FF);
			highScoreLbl.hAlign = HAlign.CENTER;
			highScoreLbl.vAlign = VAlign.TOP;
			highScoreLbl.alpha = .85;
			highScoreLbl.blendMode = "add";
			highScoreLbl.x = int(Constants.GameWidth/2 - playerNameTxt.width/2);
			highScoreLbl.y = 255;
			this.addChild(highScoreLbl);
			
			//best time
			highScoreTxt = new TextField(400, 75, "0", Constants.MAIN_FONT, 28, 0xF9B0FF);
			highScoreTxt.hAlign = HAlign.CENTER;
			highScoreTxt.vAlign = VAlign.TOP;
			highScoreTxt.bold = true;
			highScoreTxt.alpha = .85;
			highScoreTxt.blendMode = "add";
			highScoreTxt.x = int(Constants.GameWidth/2 - playerNameTxt.width/2);
			highScoreTxt.y = 225;
			this.addChild(highScoreTxt);
			
			//best rank label
			rankLbl = new TextField(400, 75, "Your best rank", Constants.MAIN_FONT, 24, 0xF9B0FF);
			rankLbl.hAlign = HAlign.CENTER;
			rankLbl.vAlign = VAlign.TOP;
			rankLbl.alpha = .85;
			rankLbl.blendMode = "add";
			rankLbl.x = int(Constants.GameWidth/2 - rankLbl.width/2);
			rankLbl.y = 355;
			this.addChild(rankLbl);
			
			//best rank
			rankTxt = new TextField(400, 75, "", Constants.MAIN_FONT, 28, 0xF9B0FF);
			rankTxt.hAlign = HAlign.CENTER;
			rankTxt.vAlign = VAlign.TOP;
			rankTxt.bold = true;
			rankTxt.alpha = .85;
			rankTxt.blendMode = "add";
			rankTxt.x = int(Constants.GameWidth/2 - rankTxt.width/2);
			rankTxt.y = 315;
			this.addChild(rankTxt);
			
			musicBtn = new ToggleButton(Assets.getTexture("MusicOnImage"), Assets.getTexture("MusicOffImage"));
			musicBtn.x = (3*Constants.GameWidth/4) - musicBtn.width/2;
			musicBtn.y = 530 - musicBtn.height/2;
			musicBtn.addEventListener(Event.TRIGGERED, onMuteMusicClick);
			musicBtn.setToggle(!SoundManager.getInstance().MusicMuted);
			this.addChild(musicBtn);
			
			soundBtn = new ToggleButton(Assets.getTexture("SoundOnImage"), Assets.getTexture("SoundOffImage"));
			soundBtn.x = (3*Constants.GameWidth/4) + musicBtn.width/2;
			soundBtn.y = 530 - soundBtn.height/2;
			soundBtn.addEventListener(Event.TRIGGERED, onMuteSfxClick);
			soundBtn.setToggle(!SoundManager.getInstance().SfxMuted);
			this.addChild(soundBtn);
			
			//qs logo
			logoBtn = new Button(Assets.getTexture("QsLogoImage"), "");
			logoBtn.addEventListener(Event.TRIGGERED, onLogoClick);
			logoBtn.x = 10;
			logoBtn.y = 530 - logoBtn.height/2;
			addChild(logoBtn);
			
			/*clearDataBtn = new Button(Assets.getTexture("StartImage"), "Clear Data");
			clearDataBtn.addEventListener(Event.TRIGGERED, onClearDataClick);
			clearDataBtn.x = Constants.GameWidth/2 - startBtn.width/2;
			clearDataBtn.y = 500;
			addChild(clearDataBtn);*/
			
			refreshFromPlayerInfo();
		}
		
		public override function start():void {
			//TODO: Add loop-indefinitely functionality. Just play a lot of times for now
			SoundManager.getInstance().playSound(SoundManager.MUSIC_MENU, 999);
		}

		
		//Refreshed UI elements based on player data in parent game
		public function refreshFromPlayerInfo():void {
			playerNameTxt.text = "Welcome back " + parentGame.getPlayerInfo().name + "!";
			highScoreTxt.text = parentGame.getPlayerInfo().highTime.toFixed(2);
			rankTxt.text = Constants.getPlayerRankName(parentGame.getPlayerInfo().highLevel);
		}
		
		public override function update(dt:Number):void
		{				
			
			//Update the game world in the background (for pretty background stars)
			var gameWorld:World = parentGame.getGameWorld();
			if (gameWorld) {
				//Limit size of updates to prevent big update steps
				var updateDt:Number = Math.min(dt, Constants.WORLD_MAX_TIMESTEP);
				
				gameWorld.updateLogic(updateDt);
				gameWorld.updateGraphics();
			}
		}
		
		protected function onStartClick(event:Event):void {
			if(musicBtn.ToggleState) {
				//note - no stop music function, going to need to hack it
				SoundManager.getInstance().setMusicMuted(musicBtn.ToggleState == true);
				SoundManager.getInstance().setMusicMuted(musicBtn.ToggleState == false);
				
				SoundManager.getInstance().playSound(SoundManager.SOUND_GAME_START);
				SoundManager.getInstance().playSound(SoundManager.MUSIC_MAIN_GAME, 999);
			}
			
			
			//Ethan's note - existing pre music switch attemp
			parentGame.showScreen("MainGame");
		}
		
		//open qs.com in new window
		protected function onLogoClick(event:Event):void {
			navigateToURL(new URLRequest("http://goo.gl/qxbSo"), "_blank");
		}
		
		protected function onMuteMusicClick(event:Event):void {
			musicBtn.switchToggle();
			SoundManager.getInstance().setMusicMuted(musicBtn.ToggleState == false);
			
			//Restart music if necessary
			if (musicBtn.ToggleState)
				SoundManager.getInstance().playSound(SoundManager.MUSIC_MENU, 999);
				
		}
		
		protected function onMuteSfxClick(event:Event):void {
			soundBtn.switchToggle();
			SoundManager.getInstance().setSfxMuted(soundBtn.ToggleState == false);
		}
		
		protected function onClearDataClick(event:Event):void {
			parentGame.resetPlayerInfo();
			
			refreshFromPlayerInfo();
		}
	}
}