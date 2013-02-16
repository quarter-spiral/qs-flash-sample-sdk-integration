package math
{
	public class RandomUtils
	{
		//Returns a random integer between minNum and maxNum, inclusive
		public static function randomInt(minNum:int, maxNum:int):int   
		{  
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);  
		}  
		
		//Returns one of the given objects in the array at random, with equal weight given to each entry
		//(duplicate entries to effectively change weights)
		//(For typecasting convenience, use a "choose****()" method instead
		private static function choose(vals:Array):Object {
			var numVals:int = vals.length;
			if (numVals > 0) {
				var selectedIdx:int = randomInt(0, numVals-1);
				return vals[selectedIdx];
			}
			return null;
		}
		
		//Returns one of given numbers in array at random
		//(things will be sad if given array is not all numbers...)
		public static function chooseInt(vals:Array):Number {
			return Number(choose(vals));
		}
	}
}