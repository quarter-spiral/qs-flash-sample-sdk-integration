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
		[Embed(source="../media/sounds/_coin 01.mp3")]
		protected static const XpGrabSound01:Class;
		
		[Embed(source="../media/sounds/_coin 02.mp3")]
		protected static const XpGrabSound02:Class;
		
		[Embed(source="../media/sounds/_coin 03.mp3")]
		protected static const XpGrabSound03:Class;
		
		[Embed(source="../media/sounds/_coin 04.mp3")]
		protected static const XpGrabSound04:Class;
		
		[Embed(source="../media/sounds/_coin 05.mp3")]
		protected static const XpGrabSound05:Class;
		
		[Embed(source="../media/sounds/_explosion 01.mp3")]
		protected static const EnemyDieSound01:Class;
		
		[Embed(source="../media/sounds/_explosion 02.mp3")]
		protected static const EnemyDieSound02:Class;
		
		[Embed(source="../media/sounds/_explosion 03.mp3")]
		protected static const EnemyDieSound03:Class;
		
		[Embed(source="../media/sounds/_shoot 02.mp3")]
		protected static const LaserFireSound01:Class;
		
		[Embed(source="../media/sounds/_damage 01.mp3")]
		protected static const EnemyDamageSound01:Class;
		
		[Embed(source="../media/sounds/_damage 02.mp3")]
		protected static const EnemyDamageSound02:Class;
		
		[Embed(source="../media/sounds/_lets go.mp3")]
		protected static const GameStartSound:Class;
		
		[Embed(source="../media/sounds/_again.mp3")]
		protected static const AgainSound:Class;
		
		[Embed(source="../media/sounds/_mission fail.mp3")]
		protected static const PlayerDeathSound:Class;
		
		[Embed(source="../media/sounds/_power up 03.mp3")]
		protected static const LevelupSound:Class;
		
		[Embed(source="../media/sounds/_power up 02.mp3")]
		protected static const BombUseSound:Class;
		
		[Embed(source="../media/sounds/Digital Native.mp3")]
		protected static const MainMenuMusic:Class;
		
		[Embed(source="../media/sounds/Arpanaut Remix.mp3")]
		protected static const MainGameMusic:Class;
		
		/**Sound names (used by external classes to request sound play) 
		 * Note: As a simple,hacky method to differentiate SFX vs. music, use the "SOUND" prefix 
		 * for all sound effects, and the "MUSIC" prefix for all music. */
		public static const SOUND_XP_GRAB_01:String = "XpGrab1";
		public static const SOUND_XP_GRAB_02:String = "XpGrab2";
		public static const SOUND_XP_GRAB_03:String = "XpGrab3";
		public static const SOUND_XP_GRAB_04:String = "XpGrab4";
		public static const SOUND_XP_GRAB_05:String = "XpGrab5";
		public static const SOUND_ENEMY_DIE_01:String = "EnemyDie1";
		public static const SOUND_ENEMY_DIE_02:String = "EnemyDie2";
		public static const SOUND_ENEMY_DIE_03:String = "EnemyDie3";
		public static const SOUND_ENEMY_DAMAGE_01:String = "EnemyDamage1";
		public static const SOUND_ENEMY_DAMAGE_02:String = "EnemyDamage2";
		public static const SOUND_LASER_FIRE_01:String = "LaserFire1";
		public static const SOUND_GAME_START:String = "GameStart";
		public static const SOUND_AGAIN:String = "Again";
		
		public static const SOUND_PLAYER_DEATH:String = "PlayerDeath";
		public static const SOUND_LEVEL_UP:String = "LevelUp";
		public static const SOUND_BOMB_USE:String = "BombUse";
		
		public static const MUSIC_MAIN_GAME:String = "MainGameMusic";
		public static const MUSIC_MENU:String = "MainMenuMusic";
		
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
			
			soundMap[SOUND_XP_GRAB_01]  = new XpGrabSound01() as Sound;
			soundMap[SOUND_XP_GRAB_02]  = new XpGrabSound02() as Sound;
			soundMap[SOUND_XP_GRAB_03]  = new XpGrabSound03() as Sound;
			soundMap[SOUND_XP_GRAB_04]  = new XpGrabSound04() as Sound;
			soundMap[SOUND_XP_GRAB_05]  = new XpGrabSound05() as Sound;
			soundMap[SOUND_ENEMY_DIE_01] = new EnemyDieSound01() as Sound;
			soundMap[SOUND_ENEMY_DIE_02] = new EnemyDieSound02() as Sound;
			soundMap[SOUND_ENEMY_DIE_03] = new EnemyDieSound03() as Sound;
			soundMap[SOUND_ENEMY_DAMAGE_01] = new EnemyDamageSound01() as Sound;
			soundMap[SOUND_ENEMY_DAMAGE_02] = new EnemyDamageSound02() as Sound;
			soundMap[SOUND_LASER_FIRE_01] = new LaserFireSound01() as Sound;
			soundMap[SOUND_GAME_START] = new GameStartSound() as Sound;
			soundMap[SOUND_AGAIN] = new AgainSound() as Sound;
			
			soundMap[SOUND_PLAYER_DEATH] = new PlayerDeathSound() as Sound;
			soundMap[SOUND_LEVEL_UP] = new LevelupSound() as Sound;
			soundMap[SOUND_BOMB_USE] = new BombUseSound() as Sound;
			
			soundMap[MUSIC_MAIN_GAME] = new MainGameMusic() as Sound;
			soundMap[MUSIC_MENU] = new MainMenuMusic() as Sound;
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