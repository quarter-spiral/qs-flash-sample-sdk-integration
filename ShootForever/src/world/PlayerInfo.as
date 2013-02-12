package world
{
	/** Container for player data that may persist between game sessions */
	public class PlayerInfo
	{
		public var name:String;
		public var highScore:int;
		public var playerLevel:int;
		public var currentXP:int;
		public var currentSpendableXP:int;
		
		public var upgrades:PlayerUpgrades;
		
		//A hacky way to store info from latest game so we can update 
		//the player state based on those results
		public var latestGameInfo:GameInfo;
		
		public function PlayerInfo()
		{
			reset();
		}
		
		//Resets all player upgrades to initial values
		public function reset():void {
			name = "Player";
			highScore = 0;
			playerLevel = 0;
			currentXP = 0;
			currentSpendableXP = 0;
			upgrades = new PlayerUpgrades();
		}
	}
}