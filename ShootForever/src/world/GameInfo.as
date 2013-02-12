package world
{
	/** Data from a single game session (ie: start of game to death of player)*/
	public class GameInfo
	{
		public var basePlayerXP:int; 
		public var basePlayerLevel:int;
		public var basePlayerUpgrades:PlayerUpgrades;
		
		//Temp in-game values (try not to touch PlayerInfo from here)
		public var ingameScore:int;
		public var ingameXp:int;
		public var ingameLevelups:int;
		public var ingameUpgrades:PlayerUpgrades;
		
		public var currMultiplier:int;
		public var currBombs:int;
		
		public function GameInfo()
		{
		}
		
		public function init(playerInfo:PlayerInfo):void
		{
			basePlayerXP = playerInfo.currentXP;
			basePlayerLevel = playerInfo.playerLevel;
			basePlayerUpgrades = new PlayerUpgrades();
			
			ingameScore = 0;
			ingameXp = 0;
			ingameLevelups = 0; 
			ingameUpgrades = new PlayerUpgrades();
			
			currMultiplier = 1;
		}
		
		public function getXp():int {
			return basePlayerXP + ingameXp;
		}
		
		public function getLevel():int {
			return basePlayerLevel + ingameLevelups;
		}
		
		public function getScore():int {
			return ingameScore;
		}
	}
}