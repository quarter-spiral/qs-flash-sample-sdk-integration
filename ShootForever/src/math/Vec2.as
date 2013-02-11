package math
{
	/** Basic 2D floating point vector */
	public class Vec2
	{
		public var x:Number;
		public var y:Number;
		
		public function Vec2(x:Number=0, y:Number=0) {
			this.x = x;
			this.y = y;	
		}
		
		//Sets value of this vector to given components
		public function setVals(x:Number, y:Number):void {this.x = x; this.y = y;}
		
		//Sets value of this vector to given vector
		public function setValsFrom(vec:Vec2):void {this.x = vec.x; this.y = vec.y;}
		
		//Adds given vector to this vector
		public function add(vec:Vec2):void {this.x += vec.x; this.y += vec.y;}
		
		//Subtracts given vector from this vector
		public function sub(vec:Vec2):void {this.x -= vec.x; this.y -= vec.y;}
		
		//Scales this vector by given scalar
		public function scale(scale:Number):void {this.x *= scale; this.y *= scale;}
		
		//Square of the magnitude of this vector
		public function lensqrd():Number {return x*x + y*y;}
		
		//Magnitude of this vector
		public function len():Number { return Math.sqrt(x*x + y*y);}
		
		//Normalizes this vector
		public function normalize():void {
			if (x != 0 || y != 0) {
				var magnitude:Number = len();	
				x /= magnitude;
				y /= magnitude;
			}
		}
	}
}