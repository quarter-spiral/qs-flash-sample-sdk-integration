package scenes.ui
{
	import starling.display.Button;
	import starling.textures.Texture;
	
	/** A basic two-state button for things such as mute buttons */
	public class ToggleButton extends Button
	{
		private var activeTexture:Texture;
		private var inactiveTexture:Texture;
		
		private var toggleState:Boolean = true;
		
		public function ToggleButton(activeTexture:Texture, inactiveTexture:Texture)
		{
			super(activeTexture);
			this.activeTexture = activeTexture;
			this.inactiveTexture = inactiveTexture;
		}
		
		public function get ToggleState():Boolean {return toggleState;}
		
		public function setToggle(val:Boolean):void {
			this.toggleState = val;
			if (toggleState)
				this.upState = activeTexture;
			else
				this.upState = inactiveTexture;
		}
		
		public function switchToggle():void {
			setToggle(!toggleState);
		}
	}
}