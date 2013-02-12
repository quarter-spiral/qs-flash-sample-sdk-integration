package world
{	
	import flash.geom.Rectangle;
	
	import math.Vec2;
	
	import starling.display.DisplayObject;

	/** Generic, top-level base class for all objects in game world */
	public class GameObject
	{
		//Parent game world
		public var parentWorld:World;
		
		//Position in game world
		public var pos:Vec2;
		
		//Size of collision box
		public var size:Vec2;
		
		//Current bounding box for this object (in world space)
		public var boundBox:Rectangle;
		
		//Graphical representation of this game object
		public var image:starling.display.DisplayObject;
		
		//Creates a new game object with specified parent
		public function GameObject(parentWorld:World)
		{
			this.parentWorld = parentWorld;
			pos = new Vec2();
			size = new Vec2();
			boundBox = new Rectangle();
		}
		
		//Runs any update logic for this game object for current world state,
		//advancing the game by dt seconds.
		public function update(dt:Number):void {
			//OVERRIDE FOR SPECIFIC BEHAVIOR, but do call this as well
			
			updateBoundingBox();
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

		public function updateBoundingBox():void {
			//Bounding box is centered about current position
			boundBox.setTo(pos.x-size.x*0.5, pos.y-size.y*0.5, size.x, size.y);
		}
	}
}