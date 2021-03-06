package scenes
{
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    
	/** Based game screen class for ShootForever */
    public class Screen extends Sprite
    {
        public static const CLOSING:String = "closing";
        
        //private var mBackButton:Button;
		
		protected var parentGame:Game;
        
        public function Screen(parentGame:Game)
        {
			this.parentGame = parentGame;
//            mBackButton = new Button(Assets.getTexture("ButtonBack"), "Back");
//            mBackButton.x = Constants.CenterX - mBackButton.width / 2;
//            mBackButton.y = Constants.GameHeight - mBackButton.height + 1;
//            mBackButton.addEventListener(Event.TRIGGERED, onBackButtonTriggered);
//            addChild(mBackButton);
        }
		
		//Called *after* screen is added to stage; inits input handlers, etc.
		public function start():void {}
		
		//Called *right before* screen is removed from stage
		//Removes input handlers, updaters, etc.
		public function close():void {
			dispatchEvent(new Event(CLOSING, true));
		}
		
		//Run any per-frame updates, where dt is time passed since previous update
		public function update(dt:Number):void {
			//No updates by default...
		}
		
		//React to a keyboard event (forwarded by listener on root Game class)
		public function onKey(event:KeyboardEvent):void {}
    }
}