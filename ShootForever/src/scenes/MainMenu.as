package scenes
{	
	import flash.net.SharedObject;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	/** Main menu shown to player at game startup */
	public class MainMenu extends Screen
	{
		//UI elements
		private var gameTitleLbl: TextField;
		private var startBtn : Button;
		private var clearDataBtn : Button;
		private var playerNameTxt:TextField;
		private var highScoreLbl:TextField;
		private var highScoreTxt:TextField;
		private var rankLbl:TextField;
		private var rankTxt:TextField;
		
		private var bg:DisplayObject;
		
		public function MainMenu(parentGame:Game)
		{
			super(parentGame);
			
			//TEST: Set better-than-initial player stats
			//parentGame.getPlayerInfo().playerLevel = 3;
			//parentGame.getPlayerInfo().highScore = 12345;
			
			bg = new Image(Assets.getTexture("Background"));
			bg.blendMode = BlendMode.NONE;
			addChild(bg);
			
			//Game title
			gameTitleLbl = new TextField(400, 75, "ImpossiBattle", Constants.MAIN_FONT, 30, 0xffffff);
			gameTitleLbl.hAlign = HAlign.CENTER;
			gameTitleLbl.vAlign = VAlign.TOP;
			gameTitleLbl.x = int(Constants.GameWidth/2 - gameTitleLbl.width/2);
			gameTitleLbl.y = 100;
			this.addChild(gameTitleLbl);
			
			//Start button
			startBtn = new Button(Assets.getTexture("StartImage"), "START");
			startBtn.addEventListener(Event.TRIGGERED, onStartClick);
			startBtn.x = Constants.GameWidth/2 - startBtn.width/2;
			startBtn.y = 200;
			addChild(startBtn);
			
			//Player welcome
			playerNameTxt = new TextField(150, 75, "Welcome!", Constants.MAIN_FONT, 16, 0xffffff);
			playerNameTxt.hAlign = HAlign.CENTER;
			playerNameTxt.vAlign = VAlign.TOP;
			playerNameTxt.x = int(Constants.GameWidth/2 - playerNameTxt.width/2);
			playerNameTxt.y = 400;
			this.addChild(playerNameTxt);
			
			highScoreLbl = new TextField(150, 75, "High Score: ", Constants.MAIN_FONT, 16, 0xffffff);
			highScoreLbl.hAlign = HAlign.LEFT;
			highScoreLbl.vAlign = VAlign.TOP;
			highScoreLbl.x = int(Constants.GameWidth*0.25 - highScoreLbl.width/2);
			highScoreLbl.y = 450;
			this.addChild(highScoreLbl);
			
			highScoreTxt = new TextField(150, 75, "0", Constants.MAIN_FONT, 16, 0xffffff);
			highScoreTxt.hAlign = HAlign.LEFT;
			highScoreTxt.vAlign = VAlign.TOP;
			highScoreTxt.x = int(highScoreLbl.x + highScoreLbl.width + 50);
			highScoreTxt.y = 450;
			this.addChild(highScoreTxt);
			
			rankLbl = new TextField(150, 75, "Rank: ", Constants.MAIN_FONT, 16, 0xffffff);
			rankLbl.hAlign = HAlign.CENTER;
			rankLbl.vAlign = VAlign.TOP;
			rankLbl.x = int(Constants.GameWidth * 0.25 - rankLbl.width/2);
			rankLbl.y = 470;
			this.addChild(rankLbl);
			
			rankTxt = new TextField(300, 75, "", Constants.MAIN_FONT, 16, 0xffffff);
			rankTxt.hAlign = HAlign.LEFT;
			rankTxt.vAlign = VAlign.TOP;
			rankTxt.x = int(rankLbl.x + rankLbl.width + 50);
			rankTxt.y = 470;
			this.addChild(rankTxt);
			
			clearDataBtn = new Button(Assets.getTexture("StartImage"), "Clear Data");
			clearDataBtn.addEventListener(Event.TRIGGERED, onClearDataClick);
			clearDataBtn.x = Constants.GameWidth/2 - startBtn.width/2;
			clearDataBtn.y = 500;
			addChild(clearDataBtn);
			
			refreshFromPlayerInfo();
		}
		
		//Refreshed UI elements based on player data in parent game
		protected function refreshFromPlayerInfo():void {
			playerNameTxt.text = "Welcome, " + parentGame.getPlayerInfo().name;
			highScoreTxt.text = parentGame.getPlayerInfo().highScore.toString();
			rankTxt.text = Constants.getPlayerRankName(parentGame.getPlayerInfo().playerLevel);
		}
		
		protected function onStartClick(event:Event):void {
			parentGame.showScreen("MainGame");
		}
		
		protected function onClearDataClick(event:Event):void {
			parentGame.resetPlayerInfo();
			
			refreshFromPlayerInfo();
		}
	}
}