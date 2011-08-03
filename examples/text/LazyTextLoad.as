package
{
	import flash.display.MovieClip;
	
	import com.rafaelrinaldi.net.LazyLoader;
	
	public class LazyTextLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazyTextLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader;
			loader.onProgress = onProgress;
			loader.onLoad = onLoad;
			loader.load("http://rafaelrinaldi.github.com/lazy-loader/examples/text/info.xml");
		}

		public function onProgress( p_progressRatio : Number ) : void
		{
			trace("Loading XML file...", p_progressRatio * 100);
		}

		public function onLoad( p_string : String ) : void
		{
			trace(loader.item.getAsXML());
		}
	}
}