package tuning
{
	/** Contains data about how game treats a particular player level */ 
	public class PlayerLevelInfo
	{
		public var xpNeeded:int;		//Total xp needed to reach this level
		public var upgradeType:int;		//upgrade type for this level
		
		public function PlayerLevelInfo(xpNeeded:int, upgradeType:int)
		{
			this.xpNeeded = xpNeeded;
			this.upgradeType = upgradeType;
		}
	}
}