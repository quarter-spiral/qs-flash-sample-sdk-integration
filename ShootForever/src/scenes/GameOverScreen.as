package scenes
{	
	import scenes.ui.ToggleButton;
	import scenes.ui.XpBar;
	
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import tuning.Constants;
	
	import world.PlayerInfo;
	import world.World;

	/** Screen shown to player after finishing a game */
	public class GameOverScreen extends Screen
	{
		//UI elements
		private var gameOverLbl: TextField;
		private var scoreLbl:TextField;
		private var highScoreLbl:TextField;
		private var scoreTxt:TextField;
		private var rankLbl:TextField;
		private var rankTxt:TextField;
		private var rankUpLbl:TextField;
		private var xpLbl:TextField;
		private var xpTxt:TextField;
		private var xpBar:XpBar;
		private var playBtn:Button;
		private var musicBtn:ToggleButton;
		private var soundBtn:ToggleButton;
		//private var xpToSpendTxt:TextField;
		
		//Local data
		private var spentXp:int = 0; 
		
		public function GameOverScreen(parentGame:Game)
		{
			super(parentGame);
			
			gameOverLbl  = new TextField(400, 75, "Mission Fail!", Constants.MAIN_FONT, 30, 0xD33A35);
			gameOverLbl.hAlign = HAlign.CENTER;
			gameOverLbl.vAlign = VAlign.TOP;
			gameOverLbl.bold = true;
			gameOverLbl.alpha = .85;
			gameOverLbl.blendMode = "add";
			gameOverLbl.x = int(Constants.GameWidth/2 - gameOverLbl.width/2);
			gameOverLbl.y = 35;
			this.addChild(gameOverLbl);
			
			scoreLbl = new TextField(400, 75, "Your time", Constants.MAIN_FONT, 24, 0xF9B0FF);
			scoreLbl.hAlign = HAlign.CENTER;
			scoreLbl.vAlign = VAlign.TOP;
			scoreLbl.alpha = .85;
			scoreLbl.blendMode = "add";
			scoreLbl.x = int(Constants.GameWidth/2 - scoreLbl.width/2);
			scoreLbl.y = 155;
			this.addChild(scoreLbl);
			
			scoreTxt = new TextField(400, 75, "0", Constants.MAIN_FONT, 28, 0xF9B0FF);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.TOP;
			scoreTxt.bold = true;
			scoreTxt.alpha = .85;
			scoreTxt.blendMode = "add";
			scoreTxt.x = int(Constants.GameWidth/2 - scoreTxt.width/2);
			scoreTxt.y = 125;
			this.addChild(scoreTxt);
			
			highScoreLbl = new TextField(400, 75, "New best time!", Constants.MAIN_FONT, 24, 0xFF43FF);
			highScoreLbl.hAlign = HAlign.CENTER;
			highScoreLbl.vAlign = VAlign.TOP;
			highScoreLbl.alpha = .85;
			highScoreLbl.blendMode = "add";
			highScoreLbl.x = int(Constants.GameWidth/2 - highScoreLbl.width/2);
			highScoreLbl.y = 180;
			highScoreLbl.visible = false; //hide by default
			this.addChild(highScoreLbl);
			
			/*xpLbl = new TextField(150, 75, "+XP", Constants.MAIN_FONT, 16, 0x00a2e8);
			xpLbl.hAlign = HAlign.CENTER;
			xpLbl.vAlign = VAlign.TOP;
			xpLbl.x = int(Constants.GameWidth*0.25 - scoreLbl.width/2);
			xpLbl.y = highScoreLbl.y + 20;
			this.addChild(xpLbl);
			
			xpTxt = new TextField(150, 75, "0", Constants.MAIN_FONT, 16, 0xffffff);
			xpTxt.hAlign = HAlign.CENTER;
			xpTxt.vAlign = VAlign.TOP;
			xpTxt.x = int(Constants.GameWidth*0.75 - scoreTxt.width/2);
			xpTxt.y = xpLbl.y;
			this.addChild(xpTxt);*/
			
			rankLbl = new TextField(400, 75, "Your rank", Constants.MAIN_FONT, 24, 0xF9B0FF);
			rankLbl.hAlign = HAlign.CENTER;
			rankLbl.vAlign = VAlign.TOP;
			rankLbl.alpha = .85;
			rankLbl.blendMode = "add";
			rankLbl.x = int(Constants.GameWidth/2 - rankLbl.width/2);
			rankLbl.y = 300;
			this.addChild(rankLbl);
			
			rankTxt = new TextField(400, 75, "", Constants.MAIN_FONT, 28, 0xF9B0FF);
			rankTxt.hAlign = HAlign.CENTER;
			rankTxt.vAlign = VAlign.TOP;
			rankTxt.bold = true;
			rankTxt.alpha = .85;
			rankTxt.blendMode = "add";
			rankTxt.x = int(Constants.GameWidth/2 - rankTxt.width/2);
			rankTxt.y = 270;
			this.addChild(rankTxt);
			
			/*xpBar = new XpBar(false);
			xpBar.x = int(Constants.GameWidth*0.5 - xpBar.width/2);
			xpBar.y = rankTxt.y + 30;
			addChild(xpBar);*/
			
			rankUpLbl = new TextField(400, 75, "New best rank!", Constants.MAIN_FONT, 24, 0xFF43FF);
			rankUpLbl.hAlign = HAlign.CENTER;
			rankUpLbl.vAlign = VAlign.TOP;
			rankUpLbl.alpha = .85;
			rankUpLbl.blendMode = "add";
			rankUpLbl.x = int(Constants.GameWidth/2 - rankUpLbl.width/2);
			rankUpLbl.y = 325;
			rankUpLbl.visible = false; //hide by default
			this.addChild(rankUpLbl);
			
//			xpToSpendTxt = new TextField(150, 75, "Buy Upgrades", Constants.MAIN_FONT, 20, 0xffffff);
//			xpToSpendTxt.hAlign = HAlign.CENTER;
//			xpToSpendTxt.vAlign = VAlign.TOP;
//			xpToSpendTxt.x = int(Constants.GameWidth*0.25 - xpToSpendTxt.width/2);
//			xpToSpendTxt.y = rankUpLbl.y + 30;
//			this.addChild(xpToSpendTxt);
			
			//Start button
			playBtn = new Button(Assets.getTexture("StartAgainImage"), "");
			playBtn.addEventListener(Event.TRIGGERED, onPlayClick);
			playBtn.x = Constants.GameWidth/2 - playBtn.width/2;
			playBtn.y = 425;
			addChild(playBtn);
			
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
			
			//if music is on, switch to menu music
			if(musicBtn.ToggleState) {
				//note - no stop music function, going to need to hack it
				SoundManager.getInstance().setMusicMuted(musicBtn.ToggleState == true);
				SoundManager.getInstance().setMusicMuted(musicBtn.ToggleState == false);
				
				SoundManager.getInstance().playSound(SoundManager.MUSIC_MENU, 999);
			}
		}
		
		public override function start():void {
			refreshFromInfo(parentGame.getPlayerInfo());
			
			//Apply the xp gain, high score, upgrades, etc. from previous game
			var info:PlayerInfo = parentGame.getPlayerInfo();
			if (info.latestGameInfo.getPlayerLiveTime() > info.highTime)
				info.highTime = info.latestGameInfo.getPlayerLiveTime();
			if (info.latestGameInfo.getLevel() > info.highLevel)
				info.highLevel = info.latestGameInfo.getLevel();
			
			//NOTE: XP no longer persistent between sessions under new Super Hexagon setup -bh, 2.15.2013
			//info.currentXP = info.latestGameInfo.getXp();
			parentGame.savePlayerInfo();
		}
		
		private function refreshFromInfo(playerInfo:PlayerInfo):void {
			scoreTxt.text = playerInfo.latestGameInfo.getPlayerLiveTime().toFixed(2);
			//xpTxt.text = playerInfo.latestGameInfo.ingameXp.toString();
			rankTxt.text = Constants.getPlayerRankName(playerInfo.latestGameInfo.getLevel());
			
			//xpBar.setLevel(playerInfo.latestGameInfo.getLevel());
			//xpBar.setCurrXp(playerInfo.latestGameInfo.getXp());
			
			if (playerInfo.latestGameInfo.getPlayerLiveTime() > playerInfo.highTime)
				highScoreLbl.visible = true;
			else 
				highScoreLbl.visible = false;
			
			if (playerInfo.latestGameInfo.getLevel() > playerInfo.highLevel)
				rankUpLbl.visible = true;
			else
				rankUpLbl.visible = false;
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
		
		private function onUpgradeShotDamageClick():void {
			//TODO
			
			spentXp += Constants.UPGRADE_SHOT_DAMAGE_COST;
		}
		
		private function onUpgradeShotRateClick():void {
			//TODO
			
			spentXp += Constants.UPGRADE_SHOTS_PER_SECOND_COST;
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
		
		private function onPlayClick(event:Event):void {
			//Finally, apply the upgrades from previous game
			//(DISABLED in Super Hex change now... no permanent upgrades are in current design. -bh, 2.15.2013
			//var info:PlayerInfo = parentGame.getPlayerInfo();
			//info.upgrades.add(info.latestGameInfo.ingameUpgrades);	
			
			//Clear the info from the previous game.
			parentGame.getPlayerInfo().latestGameInfo = null; 
			
			//TODO: Save it all to disk again, since we've finally completed an atomic "game" and assigned
			//all out various upgrades
			parentGame.savePlayerInfo();
			
			//if music is on, switch to game music
			if(musicBtn.ToggleState) {
				//note - no stop music function, going to need to hack it
				SoundManager.getInstance().setMusicMuted(musicBtn.ToggleState == true);
				SoundManager.getInstance().setMusicMuted(musicBtn.ToggleState == false);
				
				SoundManager.getInstance().playSound(SoundManager.SOUND_AGAIN);
				SoundManager.getInstance().playSound(SoundManager.MUSIC_MAIN_GAME, 999);
			}
			
			//Start game anew
			parentGame.showScreen("MainGame");
		}
	}
}