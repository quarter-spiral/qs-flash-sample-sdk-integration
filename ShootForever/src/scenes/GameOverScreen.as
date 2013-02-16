package scenes
{
	import flash.net.SharedObject;
	
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
		//private var xpToSpendTxt:TextField;
		
		//Local data
		private var spentXp:int = 0; 
		
		public function GameOverScreen(parentGame:Game)
		{
			super(parentGame);
			
			gameOverLbl  = new TextField(400, 75, "Game Over", Constants.MAIN_FONT, 30, 0xffffff);
			gameOverLbl.hAlign = HAlign.CENTER;
			gameOverLbl.vAlign = VAlign.TOP;
			gameOverLbl.x = int(Constants.GameWidth/2 - gameOverLbl.width/2);
			gameOverLbl.y = 50;
			this.addChild(gameOverLbl);
			
			scoreLbl = new TextField(150, 75, "Time: ", Constants.MAIN_FONT, 16, 0xffffff);
			scoreLbl.hAlign = HAlign.CENTER;
			scoreLbl.vAlign = VAlign.TOP;
			scoreLbl.x = int(Constants.GameWidth*0.25 - scoreLbl.width/2);
			scoreLbl.y = 120;
			this.addChild(scoreLbl);
			
			scoreTxt = new TextField(150, 75, "0", Constants.MAIN_FONT, 16, 0xffffff);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.TOP;
			scoreTxt.x = int(Constants.GameWidth*0.75 - scoreTxt.width/2);
			scoreTxt.y = scoreLbl.y;
			this.addChild(scoreTxt);
			
			highScoreLbl = new TextField(150, 75, "Best Time!", Constants.MAIN_FONT, 16, 0xffff00);
			highScoreLbl.hAlign = HAlign.CENTER;
			highScoreLbl.vAlign = VAlign.TOP;
			highScoreLbl.x = int(Constants.GameWidth*0.5 - highScoreLbl.width/2);
			highScoreLbl.y = scoreTxt.y + 20;
			highScoreLbl.visible = false; //hide by default
			this.addChild(highScoreLbl);
			
			xpLbl = new TextField(150, 75, "+XP", Constants.MAIN_FONT, 16, 0x00a2e8);
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
			this.addChild(xpTxt);
			
			rankLbl = new TextField(150, 75, "Rank: ", Constants.MAIN_FONT, 16, 0xffffff);
			rankLbl.hAlign = HAlign.CENTER;
			rankLbl.vAlign = VAlign.TOP;
			rankLbl.x = int(Constants.GameWidth * 0.25 - rankLbl.width/2);
			rankLbl.y = xpTxt.y + 40;
			this.addChild(rankLbl);
			
			rankTxt = new TextField(300, 75, "", Constants.MAIN_FONT, 16, 0xffffff);
			rankTxt.hAlign = HAlign.CENTER;
			rankTxt.vAlign = VAlign.TOP;
			rankTxt.x = int(Constants.GameWidth*0.75 - rankTxt.width/2);
			rankTxt.y = rankLbl.y;
			this.addChild(rankTxt);
			
			xpBar = new XpBar(false);
			xpBar.x = int(Constants.GameWidth*0.5 - xpBar.width/2);
			xpBar.y = rankTxt.y + 30;
			addChild(xpBar);
			
			rankUpLbl = new TextField(150, 75, "Rank Up!", Constants.MAIN_FONT, 16, 0xffff00);
			rankUpLbl.hAlign = HAlign.CENTER;
			rankUpLbl.vAlign = VAlign.TOP;
			rankUpLbl.x = int(Constants.GameWidth*0.5 - rankUpLbl.width/2);
			rankUpLbl.y = xpBar.y + 60;
			rankUpLbl.visible = false; //hide by default
			this.addChild(rankUpLbl);
			
//			xpToSpendTxt = new TextField(150, 75, "Buy Upgrades", Constants.MAIN_FONT, 20, 0xffffff);
//			xpToSpendTxt.hAlign = HAlign.CENTER;
//			xpToSpendTxt.vAlign = VAlign.TOP;
//			xpToSpendTxt.x = int(Constants.GameWidth*0.25 - xpToSpendTxt.width/2);
//			xpToSpendTxt.y = rankUpLbl.y + 30;
//			this.addChild(xpToSpendTxt);
			
			//Start button
			playBtn = new Button(Assets.getTexture("StartImage"), "Play Again?");
			playBtn.addEventListener(Event.TRIGGERED, onPlayClick);
			playBtn.x = Constants.GameWidth/2 - playBtn.width/2;
			playBtn.y = 540;
			addChild(playBtn);
			
			refreshFromInfo(parentGame.getPlayerInfo());
		}
		
		public override function start():void {
			//Apply the xp gain, high score, upgrades, etc. from previous game
			var info:PlayerInfo = parentGame.getPlayerInfo();
			if (info.latestGameInfo.getPlayerLiveTime() > info.highTime)
				info.highTime = info.latestGameInfo.getPlayerLiveTime();
			info.playerLevel = info.latestGameInfo.getLevel();
			info.currentXP = info.latestGameInfo.getXp();
			parentGame.savePlayerInfo();
		}
		
		private function refreshFromInfo(playerInfo:PlayerInfo):void {
			scoreTxt.text = playerInfo.latestGameInfo.getPlayerLiveTime().toFixed(2);
			xpTxt.text = playerInfo.latestGameInfo.ingameXp.toString();
			rankTxt.text = Constants.getPlayerRankName(playerInfo.latestGameInfo.getLevel());
			
			xpBar.setLevel(playerInfo.latestGameInfo.getLevel());
			xpBar.setCurrXp(playerInfo.latestGameInfo.getXp());
			
			if (playerInfo.latestGameInfo.getPlayerLiveTime() > playerInfo.highTime)
				highScoreLbl.visible = true;
			else 
				highScoreLbl.visible = false;
			
			if (playerInfo.latestGameInfo.ingameLevelups > 0)
				rankUpLbl.visible = true;
			else
				rankUpLbl.visible = false;
		}
		
		public override function update(dt:Number):void
		{				
			//Update the game world in the background (for pretty background stars)
			var gameWorld:World = parentGame.getGameWorld();
			if (gameWorld) {
				gameWorld.updateLogic(dt);
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
		
		private function onPlayClick(event:Event):void {
			//Finally, apply the upgrades from previous game,
			var info:PlayerInfo = parentGame.getPlayerInfo();
			info.upgrades.add(info.latestGameInfo.ingameUpgrades);	
			
			//Clear the info from the previous game.
			parentGame.getPlayerInfo().latestGameInfo = null; 
			
			//TODO: Save it all to disk again, since we've finally completed an atomic "game" and assigned
			//all out various upgrades
			parentGame.savePlayerInfo();
			
			//Start game anew
			parentGame.showScreen("MainGame");
		}
	}
}