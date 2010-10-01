package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	import rinaldi.net.LazyLoader;
	
	public class LazyImageLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazyImageLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader({onProgress: progressHandler, onLoad: loadHandler});
			loader.load("the_black_keys.jpg");
		}

		public function progressHandler( ...args ) : void
		{
			const progressRatio : Number = args[0];
			trace("Loading image: " + progressRatio * 100 + "%");
		}

		public function loadHandler( ...args ) : void
		{
			const image : Bitmap = args[0];
			addChild(image);
		}
	}
}