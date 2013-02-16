package world
{
	/** Data from a single game session (ie: start of game to death of player)*/
	public class GameInfo
	{
		public var basePlayerXP:int; 
		public var basePlayerLevel:int;
		public var basePlayerUpgrades:PlayerUpgrades;
		
		//Temp in-game values (try not to touch PlayerInfo from here)
		public var playerLiveTime:Number;
		public var ingameXp:int;
		public var ingameLevelups:int;
		public var ingameUpgrades:PlayerUpgrades;
		
		public var currBombs:int;
		
		public function GameInfo()
		{
		}
		
		public function init(playerInfo:PlayerInfo):void
		{
			//under new Super Hex setup, player always starts at level 0 and with 0 xp
			basePlayerXP = 0;//playerInfo.currentXP;
			basePlayerLevel = 0;	
			basePlayerUpgrades = new PlayerUpgrades();
			
			playerLiveTime = 0;
			ingameXp = 0;
			ingameLevelups = 0; 
			ingameUpgrades = new PlayerUpgrades();
		}
		
		public function getXp():int {
			return basePlayerXP + ingameXp;
		}
		
		public function getLevel():int {
			return basePlayerLevel + ingameLevelups;
		}
		
		public function getPlayerLiveTime():Number {
			return playerLiveTime;
		}
	}
}