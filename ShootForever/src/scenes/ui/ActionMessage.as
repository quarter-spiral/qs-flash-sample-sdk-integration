package scenes.ui
{
	
	import starling.animation.IAnimatable;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import tuning.Constants;
	
	/** A textual popup message used to indicate powerups, game start, etc. */
	public class ActionMessage extends EventDispatcher implements IAnimatable
	{
		//The graphical container for this message
		public var image:DisplayObjectContainer;
		
		//Graphical components of this msg
		protected var msgTxt:TextField;
		protected var bg:Image;
		
		//The tweens that comprise this msg
		protected var txtTweenIn:Tween;
		protected var bgTweenIn:Tween;
		protected var txtTweenOut:Tween;
		protected var bgTweenOut:Tween;
		
		//Animation timing/properties
		protected var sweepInTime:Number;		//seconds
		protected var holdTime:Number;			//seconds
		protected var sweepOutTime:Number;		//seconds
		protected var totalTime:Number;			//seconds (set based on other times)
		
		protected var currTime:Number;
		protected var phase:int;				//used to switch animations phases based on time
		
		protected var complete:Boolean;			//set to true when animation finishes
		
		public function ActionMessage()
		{
			//TODO: Put constants in Constants.as to determine this
			sweepInTime = 0.5;
			holdTime = 0.5;
			sweepOutTime = 1.0;
			totalTime = sweepInTime + holdTime + sweepOutTime;
			
			image = new Sprite();
			//Place action msgs in center of screen
			image.x = Constants.GameWidth/2;
			image.y = Constants.GameHeight/2;

			bg = new Image(Assets.getTexture("ActionMessageBgImage"));
			bg.pivotX = bg.width/2;
			bg.pivotY = bg.height/2;
			image.addChild(bg);
			
			msgTxt = new TextField(300, 75, "", Constants.MAIN_FONT, 20, 0xffffff);
			msgTxt.hAlign = HAlign.CENTER;
			msgTxt.vAlign = VAlign.CENTER;
			msgTxt.pivotX = msgTxt.width/2;
			msgTxt.pivotY = msgTxt.height/2;
			image.addChild(msgTxt);
			
			//Just create blank tween objects (init'd in "reset()")
			txtTweenIn = new Tween(null, 0.0);
			bgTweenIn = new Tween(null, 0.0);
			txtTweenOut = new Tween(null, 0.0);
			bgTweenOut = new Tween(null, 0.0);
			
			reset();
		}
		
		public function isComplete():Boolean {
			return complete;
		}
		
		//Resets animation state of thies action message
		public function reset():void {
			currTime = 0;
			complete = false;
			phase = 0;
			
			bg.x = Constants.GameWidth + bg.width/2; //start off of screen
			bg.y = 0;								//centered at action message's y pos
			bg.alpha = 0;
			
			msgTxt.x = 0 - msgTxt.width/2;
			msgTxt.y = 0;
			msgTxt.alpha = 0;
			
			//Set up the tweens for the initial "sweep in"
			txtTweenIn.reset(msgTxt, sweepInTime, Transitions.EASE_IN);
			txtTweenIn.animate("x", 0);
			txtTweenIn.fadeTo(1.0);
			
			bgTweenIn.reset(bg, sweepInTime, Transitions.EASE_IN);
			bgTweenIn.animate("x", 0);
			bgTweenIn.fadeTo(1.0);
			
			//Set up tweens for the final "sweep out"
			txtTweenOut.reset(msgTxt, sweepInTime, Transitions.EASE_IN);
			txtTweenOut.animate("y", 0);
			txtTweenOut.fadeTo(0.0);
			
			bgTweenOut.reset(bg, sweepInTime, Transitions.EASE_IN);
			bgTweenOut.animate("y", 0);
			bgTweenOut.fadeTo(0.0);
		}
		
		public function setText(text:String):void {
			msgTxt.text = text;
		}
		
		public function advanceTime(time:Number):void
		{
			currTime += time;
			
			switch (phase) {
				//Phase 1: Sweep in from sides
				case 0:
					txtTweenIn.advanceTime(time);
					bgTweenIn.advanceTime(time);
					if (currTime >= sweepInTime)
						advancePhase();
					break;
				//Phase 2: Hold position
				case 1:
					if (currTime >= sweepInTime + holdTime)
						advancePhase();
					break;
				//Phase 3: Sweep out
				case 2:
					txtTweenOut.advanceTime(time);
					bgTweenOut.advanceTime(time);
					if (currTime >= sweepInTime + holdTime + sweepOutTime)
						advancePhase();
					break;
			}
		}
		
		protected function advancePhase():void {
			phase++;
			switch (phase) {
				case 1: 
					//Make sure we're at target position
					txtTweenIn.advanceTime(Number.POSITIVE_INFINITY);
					bgTweenIn.advanceTime(Number.POSITIVE_INFINITY);
					break;
				case 2:
					//Anything to do when starting sweep-out phase?
					break
				case 3:
					//All phases completed... end this animation
					complete = true;
					dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					break;
			}
		}
	}
}