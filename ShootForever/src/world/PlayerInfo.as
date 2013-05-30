package world
{
	import flash.utils.Dictionary;

	/** Container for player data that may persist between game sessions */
	public class PlayerInfo
	{
		public var name:String;
		public var highTime2:Number;
		public var highLevel:int;
		//public var currentXP:int; //NOTE: XP no longer persistent between sessions under new Super Hexagon setup -bh, 2.15.2013
		//public var currentSpendableXP:int;
		
		//Permanent upgrades (as opposed to those we give in-game)
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
			highTime2 = 0;
			highLevel = 0;
			//currentXP = 0;
			//currentSpendableXP = 0;
			upgrades = new PlayerUpgrades();
		}
		
		public function updateFromQSData(playerData:Dictionary):void
		{
			if (playerData['highLevel'] && highLevel < playerData['highLevel']) {
				highLevel = playerData['highLevel'];
			}
			if (playerData['highTime2'] && highTime2 < playerData['highTime2']) {
				highTime2 = playerData['highTime2'];
			}
		}
	}
}