package
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import rinaldi.net.LazyLoader;
	
	public class LazySoundLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazySoundLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader({onProgress: progressHandler, onLoad: loadHandler});
			loader.load("http://www.rafaelrinaldi.com/github/lazy-loader/examples/sound/minha_menina.mp3");
		}

		public function progressHandler( ...args ) : void
		{
			const progressRatio : Number = args[0];
			trace("Loading image: " + progressRatio * 100 + "%");
		}

		public function loadHandler( ...args ) : void
		{
			const sound : Sound = loader.item.getAsSound();

			var channel : SoundChannel = new SoundChannel;
			channel = sound.play();
		}
	}
}