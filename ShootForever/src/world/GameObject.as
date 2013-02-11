package world
{	
	import math.Vec2;
	
	import starling.display.DisplayObject;

	/** Generic, top-level base class for all objects in game world */
	public class GameObject
	{
		//Parent game world
		public var parentWorld:World;
		
		//Position in game world
		public var pos:Vec2;
		
		//Graphical representation of this game object
		public var image:starling.display.DisplayObject;
		
		//Creates a new game object with specified parent
		public function GameObject(parentWorld:World)
		{
			this.parentWorld = parentWorld;
			pos = new Vec2();
		}
		
		//Runs any update logic for this game object for current world state,
		//advancing the game by dt seconds.
		public function update(dt:Number):void {
			//OVERRIDE FOR SPECIFIC BEHAVIOR
		}
		
		public function updateGraphics():void {
			//Update position of the image representing this object
			if (image) {
				image.x = pos.x;
				image.y = pos.y;
			}
		}
		
		//Cleanup this object when finished with it
		public function dispose():void {
			if (image) {
				image.dispose();
				image = null;
			}
		}
	}
}