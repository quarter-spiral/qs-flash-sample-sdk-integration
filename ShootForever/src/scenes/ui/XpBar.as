package scenes.ui
{	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import tuning.Constants;
	
	/** Super basic bar for showing xp progress */
	public class XpBar extends Sprite
	{
		
		private var bg:Image;
		private var fillBar:Image;
		private var fillBarCap:Image;
		
		private var playerLevel:int = 0;
		private var lvlMinXp:int = 0;
		private var lvlMaxXp:int = 0;
		private var currXp:int = 0
		
		private var xpTxt:TextField;
			
		public function XpBar(miniMode:Boolean)
		{
			super();
			
			if (miniMode) {
				xpTxt = new TextField(100, 27, "0/0", Constants.MAIN_FONT, 11, 0xF9B0FF);
				xpTxt.hAlign = HAlign.CENTER;
				xpTxt.vAlign = VAlign.CENTER;
				xpTxt.bold = true;
				xpTxt.blendMode = "add";
				xpTxt.y = 0;
				bg = new Image(Assets.getTexture("XpBarMiniBg")); 
				bg.x = xpTxt.x;// + xpTxt.width;
				fillBarCap = new Image(Assets.getTexture("XpBarMiniLeft"));
				fillBarCap.x = bg.x;
				fillBar = new Image(Assets.getTexture("XpBarMiniFill"));
				fillBar.x = bg.x + 6;
			}
			else {
				bg = new Image(Assets.getTexture("XpBarBg"));
				fillBar = new Image(Assets.getTexture("XpBarFill"));
				xpTxt = new TextField(150, 75, "0/0", Constants.MAIN_FONT, 20, 0x000000);
				xpTxt.hAlign = HAlign.CENTER;
				xpTxt.vAlign = VAlign.TOP;
				xpTxt.x = int(bg.width*0.5 - xpTxt.width*0.5);
				xpTxt.y = 0;
			}
			addChild(bg);
			addChild(fillBarCap);
			addChild(fillBar);
			addChild(xpTxt);
			
			refreshGraphics();
		}
		
		//Set current player level for this XP bar
		public function setLevel(lvl: int):void {
			this.playerLevel = lvl;
			lvlMinXp = Constants.getXpForLevel(playerLevel);
			lvlMaxXp = Constants.getXpForLevel(playerLevel+1);
			refreshGraphics();
		}
		
		public function getLevel():int {
			return playerLevel;
		}
		
		public function setCurrXp(currXp:int):void {
			this.currXp = currXp;
			refreshGraphics();
		}
		
		public function refreshGraphics():void {
			var fillPct:Number = 0;
			
			var xpThisLevel:Number = currXp - lvlMinXp;
			var xpBetweenLevels:Number = lvlMaxXp - lvlMinXp;
			
			
			if (lvlMaxXp > 0) 
				fillPct = xpThisLevel / xpBetweenLevels;
			
			fillPct = Math.min(Math.max(fillPct, 0), 1.0);
			
			if(fillPct == 0) {
				fillBarCap.visible = 0;
			}
			else {
				fillBarCap.visible = 1;
			}
			
			fillBar.width = (bg.width-6) * fillPct;
			
			xpTxt.text = xpThisLevel.toString() + "/" + xpBetweenLevels.toString();
		}
	}
}