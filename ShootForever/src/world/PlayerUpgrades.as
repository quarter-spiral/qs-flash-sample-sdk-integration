package world
{
	/** Upgrade data for player ship */
	public class PlayerUpgrades
	{
		//Upgrade levels
		public var startBombsLevel:int = 0;		//increases number of bombs at game start
		public var shotRateLevel:int = 0;		//decreases firing interval
		public var shotDamageLevel:int = 0;		//increases damage per shot
		public var shotNumLevel:int = 0;		//increase number shots created at each fire interval
		public var magnetRadiusLevel:int = 0;	//radius of XP magnet
		
		public function PlayerUpgrades()
		{
		}
		
		//Returns a new upgrades object with same values as this object
		public function copy():PlayerUpgrades {
			var dup:PlayerUpgrades = new PlayerUpgrades();
			dup.startBombsLevel = this.startBombsLevel
			dup.shotDamageLevel = this.shotDamageLevel;
			dup.shotRateLevel = this.shotRateLevel;
			dup.shotNumLevel = this.shotNumLevel;
			dup.magnetRadiusLevel = this.magnetRadiusLevel;
			return dup;
		}
		
		//Adds given upgrades to this current upgrade object
		public function add(toAdd:PlayerUpgrades):void {
			this.startBombsLevel += toAdd.startBombsLevel;
			this.shotDamageLevel += toAdd.shotDamageLevel;
			this.shotRateLevel += toAdd.shotRateLevel;
			this.shotNumLevel += toAdd.shotNumLevel;
			this.magnetRadiusLevel += toAdd.magnetRadiusLevel;
		}
	}
}