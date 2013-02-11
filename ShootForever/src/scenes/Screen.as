package scenes
{
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    
	/** Based game screen class for ShootForever */
    public class Screen extends Sprite
    {
        public static const CLOSING:String = "closing";
        
        private var mBackButton:Button;
        
        public function Screen()
        {
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
    }
}