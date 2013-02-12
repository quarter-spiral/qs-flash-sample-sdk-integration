package math
{
	public class RandomUtils
	{
		public static function randomInt(minNum:int, maxNum:int):int   
		{  
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);  
		}  
	}
}