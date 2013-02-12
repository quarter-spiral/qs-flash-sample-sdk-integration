package scenes.ui
{	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/** Super basic bar for showing xp progress */
	public class XpBar extends Sprite
	{
		
		private var bg:Image;
		private var fillBar:Image;
		
		private var playerLevel:int = 0;
		private var lvlMinXp:int = 0;
		private var lvlMaxXp:int = 0;
		private var currXp:int = 0
		
		private var xpTxt:TextField;
			
		public function XpBar(miniMode:Boolean)
		{
			super();
			
			if (miniMode) {
				xpTxt = new TextField(150, 15, "0/0", Constants.MAIN_FONT, 10, 0xFFFFFF);
				xpTxt.hAlign = HAlign.RIGHT;
				xpTxt.vAlign = VAlign.TOP;
				xpTxt.y = 3;
				bg = new Image(Assets.getTexture("XpBarMiniBg")); 
				bg.x = xpTxt.x + xpTxt.width;
				fillBar = new Image(Assets.getTexture("XpBarMiniFill"));
				fillBar.x = bg.x;
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
			
			fillBar.width = bg.width * fillPct;
			
			xpTxt.text = xpThisLevel.toString() + "/" + xpBetweenLevels.toString();
		}
	}
}