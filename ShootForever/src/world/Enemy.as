package world
{
	//A logical enemy of the player in the game world
	public class Enemy extends GameObject
	{
		public function Enemy()
		{
			super();
			
			loadImage();
		}
		
		//Loads the graphical image of this baddie. Override for specific enemy types
		public function loadImage():void {
			//TODO
		}
	}
}