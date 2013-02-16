package world
{
	/** Upgrade data for player ship */
	public class PlayerUpgrades
	{
		//Upgrade levels
		public var startBombsLevel:int = 0;
		public var shotDamageLevel:int = 0;
		public var shotRateLevel:int = 0;
		public var shotSpeedLevel:int = 0;
		public var shotRadiusLevel:int = 0;
		
		public function PlayerUpgrades()
		{
		}
		
		//Returns a new upgrades object with same values as this object
		public function copy():PlayerUpgrades {
			var dup:PlayerUpgrades = new PlayerUpgrades();
			dup.startBombsLevel = this.startBombsLevel
			dup.shotDamageLevel = this.shotDamageLevel;
			dup.shotRateLevel = this.shotRateLevel;
			dup.shotSpeedLevel = this.shotSpeedLevel;
			dup.shotRadiusLevel = this.shotRadiusLevel;
			return dup;
		}
		
		//Adds given upgrades to this current upgrade object
		public function add(toAdd:PlayerUpgrades):void {
			this.startBombsLevel += toAdd.startBombsLevel;
			this.shotDamageLevel += toAdd.shotDamageLevel;
			this.shotRateLevel += toAdd.shotRateLevel;
			this.shotRadiusLevel += toAdd.shotRadiusLevel;
			this.shotSpeedLevel += toAdd.shotSpeedLevel;
		}
	}
}