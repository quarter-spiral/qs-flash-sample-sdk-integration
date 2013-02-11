package world
{	
	import math.Vec2;
	
	import starling.display.DisplayObjectContainer;
	
	import world.GameObject;
	
	/** Logical game world that is updated every frame */
	public class World
	{
		public var mousePos:Vec2;
		
		private var totalGameTime:Number = 0;
		
		private var imageContainer:DisplayObjectContainer;
		
		//The main player object in the world
		private var player:Player; 	
		//All active enemies in the world
		private var enemies:Vector.<Enemy>;
		//All active player-spawned bullets in the world
		private var playerBullets:Vector.<Bullet>;
		//All active enemy-spawned bullets in the world
		private var enemyBullets:Vector.<Bullet>;
		
		//List of *all* game objects in the world
		private var objects:Vector.<GameObject>;
		
		//Temp util objects to avoid a bunch of object creations on each frame
		private var playerMouseDelta:Vec2;
		
		//Creates a new game world with given container for the graphical images of game objects
		public function World(imageContainer:DisplayObjectContainer)
		{
			mousePos = new Vec2();
			this.imageContainer = imageContainer;
			
			//Init object lists
			objects = new Vector.<GameObject>();
			enemies = new Vector.<Enemy>();
			playerBullets = new Vector.<Bullet>();
			enemyBullets = new Vector.<Bullet>();
			
			playerMouseDelta = new Vec2();
		}
		
		//Prepares world for a new game instance
		public function init():void {
			clear(); //remove existing world objects
			
			//Create player at the bottom of the screen
			player = new Player();
			player.pos.x = Constants.GameWidth/2;
			player.pos.y = Constants.GameHeight - player.image.height/2;
			addObject(player);
		}
		
		//Adds given game object to this world so it may be updated & rendered
		public function addObject(object:GameObject):void {
			objects.push(object);
			
			//Add object's image to rendered scene
			if (imageContainer && object.image)
				imageContainer.addChild(object.image);
		}
		
		//Updates logical gameplay elements of world
		public function update(dt:Number):void {
			totalGameTime += dt;
			
			//INPUT: Move player toward mouse position
			playerMouseDelta.setValsFrom(mousePos);
			playerMouseDelta.sub(player.pos);
			player.pos.x += playerMouseDelta.x;
			if (player.pos.x > Constants.GameWidth - Constants.PLAYER_RADIUS) player.pos.x = Constants.GameWidth - Constants.PLAYER_RADIUS;
			if (player.pos.y < Constants.PLAYER_RADIUS) player.pos.x = Constants.PLAYER_RADIUS;
			
			var numObjects:int = objects.length;
			for (var i:int = 0; i < numObjects; i++)
				objects[i].update(dt);
		}
		
		//Updates graphical elements of objects in world
		public function updateGraphics():void {
			var numObjects:int = objects.length;
			for (var i:int = 0; i < numObjects; i++)
				objects[i].updateGraphics();
		}
		
		//Removes everything currently in the world
		public function clear():void {
			var numObjects:int = objects.length;
			for (var i:int = 0; i < numObjects; i++)
				objects[i].dispose();
			
			objects.length = 0;
		}
		
		//Disposes of the resources for this world
		public function dispose():void  {
			clear();
		}
	}
}