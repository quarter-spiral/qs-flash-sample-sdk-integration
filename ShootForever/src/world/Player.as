package world
{
	import starling.display.Image;

	/** The player's ship in the game world */
	public class Player extends GameObject
	{
		public function Player()
		{
			super();
			
			//Placeholder static image. TODO: animated player image that depends on state
			image = new Image(Assets.getTexture("PlayerImage"));
		}
		
		public function collideWithEnemies(enemies:Vector.<Enemy>):void {
			//TODO: check for collision with bad guys, run update logic if collision occurs
			//use Constants.PLAYER_RADIUS to check
		}
	}
}