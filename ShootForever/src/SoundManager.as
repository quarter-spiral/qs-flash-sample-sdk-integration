package
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	import scenes.MainGame;
	
	import world.Player;
	
	/** Basic sound manager for ImpossiBattle (modeled on Sounds.as from hsharma's Hungry Hero demo*/
	public class SoundManager
	{
		//Singleton pattern for external access
		private static var instance:SoundManager = null;
		public function SoundManager(e : SoundManagerSingletonEnforcer) {
			init();
		}
		public static function getInstance():SoundManager{
			if(instance == null)
				instance = new SoundManager(new SoundManagerSingletonEnforcer());
			return instance;
		}
			
		/** Embeds */
		[Embed(source="../media/sounds/button-50.mp3")]
		protected static const XpGrabSound:Class;
		
		[Embed(source="../media/sounds/beep-23.mp3")]
		protected static const EnemyHitSound1:Class;
		
		[Embed(source="../media/sounds/button-3.mp3")]
		protected static const EnemyHitSound2:Class;
		
		[Embed(source="../media/sounds/button-13.mp3")]
		protected static const EnemyHitSound3:Class;
		
		[Embed(source="../media/sounds/beep-26.mp3")]
		protected static const EnemyHitSound4:Class;
		
		[Embed(source="../media/sounds/button-4.mp3")]
		protected static const PlayerDeathSound:Class;
		
		[Embed(source="../media/sounds/button-14.mp3")]
		protected static const LevelupSound:Class;
		
		[Embed(source="../media/sounds/button-8.mp3")]
		protected static const BombUseSound:Class;
		
		//TODO: PLACEHOLDER... use final music
		[Embed(source="../media/sounds/Go Cart - Loop Mix.mp3")]
		protected static const MainGameMusic:Class;
		
		/**Sound names (used by external classes to request sound play) 
		 * Note: As a simple,hacky method to differentiate SFX vs. music, use the "SOUND" prefix 
		 * for all sound effects, and the "MUSIC" prefix for all music. */
		public static const SOUND_XP_GRAB:String = "XpGrab";
		public static const SOUND_ENEMY_HIT_1:String = "EnemyHit1";
		public static const SOUND_ENEMY_HIT_2:String = "EnemyHit2";
		public static const SOUND_ENEMY_HIT_3:String = "EnemyHit3";
		public static const SOUND_ENEMY_HIT_4:String = "EnemyHit4";
		public static const SOUND_PLAYER_DEATH:String = "PlayerDeath";
		public static const SOUND_LEVEL_UP:String = "LevelUp";
		public static const SOUND_BOMB_USE:String = "BombUse";
		
		public static const MUSIC_MAIN_GAME:String = "MainGameMusic";
		
		/** Other fields */
		protected var sfxMuted:Boolean = false;
		protected var musicMuted:Boolean = false;
		
		protected var activeSfxChannels:Vector.<SoundChannel>;
		protected var activeMusicChannels:Vector.<SoundChannel>;
		
		//Mappings from string names to SFX or music sound objects
		protected var soundMap:Dictionary;
		
		public function get MusicMuted():Boolean {return musicMuted;}
		public function get SfxMuted():Boolean {return sfxMuted;}
		
		protected function init():void {
			//Init the sound map (is there a more automated way to do this?)
			soundMap = new Dictionary();
			activeSfxChannels = new Vector.<SoundChannel>();
			activeMusicChannels = new Vector.<SoundChannel>();
			
			soundMap[SOUND_XP_GRAB]  = new XpGrabSound() as Sound;
			soundMap[SOUND_ENEMY_HIT_1] = new EnemyHitSound1() as Sound;
			soundMap[SOUND_ENEMY_HIT_2] = new EnemyHitSound2() as Sound;
			soundMap[SOUND_ENEMY_HIT_3] = new EnemyHitSound3() as Sound;
			soundMap[SOUND_ENEMY_HIT_4] = new EnemyHitSound4() as Sound;
			soundMap[SOUND_PLAYER_DEATH] = new PlayerDeathSound() as Sound;
			soundMap[SOUND_LEVEL_UP] = new LevelupSound() as Sound;
			soundMap[SOUND_BOMB_USE] = new BombUseSound() as Sound;
			
			soundMap[MUSIC_MAIN_GAME] = new MainGameMusic() as Sound;
		}
		
		/** Plays specified SFX sound, if not muted */
		public function playSound(soundName : String, numLoops:int=0):void {
			var isMusic:Boolean = soundName.length > 0 && soundName.charAt(0) == "M";
			if ((isMusic && !musicMuted) || (!isMusic && !sfxMuted)) {
				var sound:Sound = soundMap[soundName];
				if (sound) {
					var channel:SoundChannel = sound.play(0,numLoops);
					//Make sure sound actually plays... will be null if we're out of channels
					if (channel) {
						if (isMusic) {
							channel.addEventListener(Event.SOUND_COMPLETE, onMusicSoundComplete);
							activeMusicChannels.push(channel);
						}
						else {
							channel.addEventListener(Event.SOUND_COMPLETE, onSfxSoundComplete);
							activeSfxChannels.push(channel);
						}
					}
				}
			}
		}
		
		/**Sets whether SFX are muted*/
		public function setSfxMuted(val:Boolean):void {
			sfxMuted = val;
			//Stop all playing SFX
			if (sfxMuted) {
				for each (var channel:SoundChannel in activeSfxChannels) {
					channel.removeEventListener(Event.SOUND_COMPLETE, onSfxSoundComplete);
					channel.stop();
				}
				activeSfxChannels.length = 0;
			}				
		}
		
		
		/**Sets whether music is muted*/
		public function setMusicMuted(val:Boolean):void {
			musicMuted = val;
			//Stop all playing music
			if (musicMuted) {
				for each (var channel:SoundChannel in activeMusicChannels) {
					channel.removeEventListener(Event.SOUND_COMPLETE, onMusicSoundComplete);
					channel.stop();
				}
				activeMusicChannels.length = 0;
			}	
		}
		
		protected function onSfxSoundComplete(event : Event) : void {
			event.currentTarget.removeEventListener(Event.SOUND_COMPLETE, onSfxSoundComplete);
			//Remove channel from active list (note: if we play a lot of sounds, this may be a bottleneck...)
			var channelIdx:int = activeSfxChannels.indexOf(SoundChannel(event.currentTarget));
			if (channelIdx >= 0)
				activeSfxChannels.splice(channelIdx, 1);
		}
		
		protected function onMusicSoundComplete(event : Event) : void {
			event.currentTarget.removeEventListener(Event.SOUND_COMPLETE, onMusicSoundComplete);
			//Remove channel from active list (note: if we play a lot of sounds, this may be a bottleneck...)
			var channelIdx:int = activeMusicChannels.indexOf(SoundChannel(event.currentTarget));
			if (channelIdx >= 0)
				activeMusicChannels.splice(channelIdx, 1);
		}
	}
}

class SoundManagerSingletonEnforcer{} //accessible only by this class for singleton enforcement