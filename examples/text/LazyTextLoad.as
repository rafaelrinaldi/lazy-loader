package
{
	import flash.display.MovieClip;
	
	import rinaldi.net.LazyLoader;
	
	public class LazyTextLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazyTextLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader({onProgress: progressHandler, onLoad: loadHandler});
			loader.load("http://www.rafaelrinaldi.com/github/lazy-loader/examples/text/info.xml");
		}

		public function progressHandler( ...args ) : void
		{
			const progressRatio : Number = args[0];
			trace("Loading image: " + progressRatio * 100 + "%");
		}

		public function loadHandler( ...args ) : void
		{
			const xml : XML = loader.item.getAsXML();
			trace(xml);
		}
	}
}