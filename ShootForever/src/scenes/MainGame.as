package scenes
{
    import flash.system.System;
    
    import math.Vec2;
    
    import starling.core.Starling;
    import starling.display.BlendMode;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.utils.formatString;
    
    import world.World;

	/** Runs the primary gameplay for ShootForever */
    public class MainGame extends Screen
    {
//        private var mStartButton:Button;
//        private var mResultText:TextField;
		
		private var bg:DisplayObject;
		private var mainPlane:Sprite;		//container for most gameplay object images
        
		//Most recent mouse position
		private var mousePos:Vec2;
		
//        private var mContainer:Sprite;
//        private var mFrameCount:int;
//        private var mElapsed:Number;
//        private var mStarted:Boolean;
//        private var mFailCount:int;
//        private var mWaitFrames:int;
		
		private var gameWorld:World;
        
        public function MainGame()
        {
            super();
            
            // the container will hold all test objects
//            mContainer = new Sprite();
//            mContainer.touchable = false; // we do not need touch events on the test objects -- 
//                                          // thus, it is more efficient to disable them.
//            addChildAt(mContainer, 0);
//            
//            mStartButton = new Button(Assets.getTexture("ButtonNormal"), "Start benchmark");
//            mStartButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
//            mStartButton.x = Constants.CenterX - int(mStartButton.width / 2);
//            mStartButton.y = 20;
//            addChild(mStartButton);
            
//            mStarted = false;
//            mElapsed = 0.0;

			bg = new Image(Assets.getTexture("Background"));
			bg.blendMode = BlendMode.NONE;
			addChild(bg);
			
			mainPlane = new Sprite();
			addChild(mainPlane);			
			
			//Create the game world
			gameWorld = new World(mainPlane);
			gameWorld.init();
        }
		
		public override function start():void {
			//Start listening to the mouse
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//Start main game loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public override function close(): void {
			if (stage) stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
        
        public override function dispose():void
        {
			close();
			
			if (gameWorld) {
				gameWorld.dispose();
				gameWorld = null;
			}
            super.dispose();
        }
        
        private function onEnterFrame(event:EnterFrameEvent):void
        {
			//Basically, just update logical game world...
			gameWorld.update(event.passedTime);
			//Then update the graphical representation thereof
			gameWorld.updateGraphics();
        }
		
		private function onTouch(event:TouchEvent):void
		{
			if (gameWorld) {
				//Just extract the mouse position, which is all we want
				var touch:Touch = event.getTouch(stage);
				if (touch)
				{
					gameWorld.mousePos.x = touch.globalX;
					gameWorld.mousePos.y = touch.globalY;
					
					if (touch.phase == TouchPhase.BEGAN)
						gameWorld.mouseClicked = true;
				}
			}
		}
        
//        private function onStartButtonTriggered(event:Event):void
//        {
//            trace("Starting benchmark");
//            
//            mStartButton.visible = false;
//            mStarted = true;
//            mFailCount = 0;
//            mWaitFrames = 2;
//            mFrameCount = 0;
//            
//            if (mResultText) 
//            {
//                mResultText.removeFromParent(true);
//                mResultText = null;
//            }
//            
//            addTestObjects();
//        }
//        
//        private function addTestObjects():void
//        {
//            var padding:int = 15;
//            var numObjects:int = mFailCount > 20 ? 2 : 10;
//            
//            for (var i:int = 0; i<numObjects; ++i)
//            {
//                var egg:Image = new Image(Assets.getTexture("BenchmarkObject"));
//                egg.x = padding + Math.random() * (Constants.GameWidth - 2 * padding);
//                egg.y = padding + Math.random() * (Constants.GameHeight - 2 * padding);
//                mContainer.addChild(egg);
//            }
//        }
//        
//        private function benchmarkComplete():void
//        {
//            mStarted = false;
//            mStartButton.visible = true;
//            
//            var fps:int = Starling.current.nativeStage.frameRate;
//            
//            trace("Benchmark complete!");
//            trace("FPS: " + fps);
//            trace("Number of objects: " + mContainer.numChildren);
//            
//            var resultString:String = formatString("Result:\n{0} objects\nwith {1} fps",
//                                                   mContainer.numChildren, fps);
//            mResultText = new TextField(240, 200, resultString);
//            mResultText.fontSize = 30;
//            mResultText.x = Constants.CenterX - mResultText.width / 2;
//            mResultText.y = Constants.CenterY - mResultText.height / 2;
//            
//            addChild(mResultText);
//            
//            mContainer.removeChildren();
//            System.pauseForGCIfCollectionImminent();
//        }
    }
}