package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.rafaelrinaldi.net.LazyLoader;
	
	public class LazyImageLoad extends MovieClip
	{
		public var loader : LazyLoader;

		public function LazyImageLoad()
		{
			stage.scaleMode = "noScale";

			loader = new LazyLoader;
			loader.onProgress = onProgress;
			loader.onLoad = onLoad;
			loader.load("http://rafaelrinaldi.github.com/button/examples/image/the_black_keys.jpg");
		}

		public function onProgress( p_progressRatio : Number ) : void
		{
			trace("Loading image...", p_progressRatio * 100);
		}
		
		public function onLoad( p_bitmap : Bitmap ) : void
		{
			addChild(p_bitmap); // Adding the Bitmap instance to stage.
			 
		   	/*
			You also can do this way:
			addChild(loader.item.getAsBitmap());
			*/
			
			trace("The BitmapData from my Bitmap is", loader.item.getAsBitmapData());
		}
	}
}