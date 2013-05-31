package 
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.system.Capabilities;
    
    import starling.core.Starling;
    
    // If you set this class as your 'default application', it will run without a preloader.
    // To use a preloader, see 'Preloader.as'.
    
    [SWF(width="400", height="600", frameRate="60", backgroundColor="#222222")]
    public class Startup extends Sprite
    {
        private var mStarling:Starling;
        
        public function Startup()
        {
            if (stage) start();
            else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        private function start():void
        {
			//Verify domain
			//Source: http://www.ghostwire.com/blog/archives/as3-domain-locking-swfs/
			var url:String = loaderInfo.loaderURL;
			var allowedDomains:String = "quarterspiral.com";
 
			var allowedPattern:String = "^http(|s)://("+allowedDomains+")";
			var domainCheck:RegExp = new RegExp(allowedPattern, "i");
			
			//For debugging, allow running, always 
			var debugPass:Boolean = false;
			CONFIG::DEBUG {
				debugPass = true; //sorta hacky, but meh...
			}
			
			//Start main SWF content if domain check passes 
			if (debugPass || domainCheck.test(url))
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				//Starling.multitouchEnabled = true; // useful on mobile devices
				//Starling.handleLostContext = true; // required on Windows and Android, needs more memory
				
				mStarling = new Starling(Game, stage);
				//mStarling.simulateMultitouch = true;
				mStarling.enableErrorChecking = Capabilities.isDebugger;
				mStarling.start();
				
				// this event is dispatched when stage3D is set up
				mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			}
			//Otherwise, do anything?
			else
			{
				//eg: Show "wrong domain" msg
			}
        }
        
        private function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            start();
        }
        
        private function onContextCreated(event:Event):void
        {
            // set framerate to 30 in software mode
            
            if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
                Starling.current.nativeStage.frameRate = 30;
        }
    }
}