package
{
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import rinaldi.net.LazyLoader;
	
	public class LazyVideoLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazyVideoLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader({onProgress: progressHandler, onLoad: loadHandler});
			loader.load("http://www.rafaelrinaldi.com/github/lazy-loader/examples/video/pqp.flv");
		}

		public function progressHandler( ...args ) : void
		{
			const progressRatio : Number = args[0];
			trace("Loading image: " + progressRatio * 100 + "%");
		}

		public function loadHandler( ...args ) : void
		{
			const stream : NetStream = args[0];
			
			var video : Video = new Video(640, 480);
			video.attachNetStream(stream);
			addChild(video);
		}
	}
}