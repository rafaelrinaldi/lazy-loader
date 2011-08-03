package
{
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import com.rafaelrinaldi.net.LazyLoader;
	
	public class LazyVideoLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazyVideoLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader;
			loader.onProgress = onProgress;
			loader.onLoad = onLoad;
			loader.load("http://rafaelrinaldi.github.com/lazy-loader/examples/video/dcpm.flv");
		}

		public function onLoad( p_stream : NetStream ) : void
		{
			var video : Video = new Video(640, 480);
			video.attachNetStream(p_stream);
			stage.addChild(video);
		}
	}
}