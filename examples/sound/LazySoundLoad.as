package
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import com.rafaelrinaldi.net.LazyLoader;
	
	public class LazySoundLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazySoundLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader;
			loader.onProgress = onProgress;
			loader.onLoad = onLoad;
			loader.load("http://rafaelrinaldi.github.com/button/examples/sound/here_today_gone_tomorrow.mp3");
		}

		public function onProgress( p_progressRatio : Number ) : void
		{
			trace("Loading sound...", p_progressRatio * 100);
		}

		public function onLoad( p_sound : Sound ) : void
		{
			trace("Ramones is awesome!");
			
			var channel : SoundChannel = new SoundChannel;
			channel = p_sound.play();
		}
	}
}