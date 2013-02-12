package world
{
	/** Properties regarding different XP tokens */
	public class XpProperties
	{
		//Amount of xp for this tken
		public var xpAmount:int = 0;
		
		//Weight which determines propability of spawning
		//(use as a direct percent probablity, if you wish)
		public var spawnWeight:Number = 0; 
		
		//Name of image class for this xp token
		public var imageName:String = ""; 
		
		public function XpProperties()
		{
		}
	}
}