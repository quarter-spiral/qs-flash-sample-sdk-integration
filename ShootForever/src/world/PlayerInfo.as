package world
{
	/** Container for player data that may persist between game sessions */
	public class PlayerInfo
	{
		public var name:String;
		public var highScore:int;
		public var currScore:int;
		public var playerLevel:int;
		
		public var upgrades:PlayerUpgrades;
		
		public function PlayerInfo()
		{
			reset();
		}
		
		//Resets all player upgrades to initial values
		public function reset():void {
			name = "Player";
			highScore = 0;
			currScore = 0;
			playerLevel = 0;
			upgrades = new PlayerUpgrades();
		}
	}
}