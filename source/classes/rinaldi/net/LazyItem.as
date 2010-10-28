package rinaldi.net
{
	import rinaldi.util.isStandalone;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.utils.getTimer;

    /**
    *
    *   LazyLoader file item.
    *
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *
    **/

	public class LazyItem extends EventDispatcher implements ILazyItem {

        public var url : String; // File URL
        public var _data : Object; // File data

        public var context : *; // The context can be a instance of LoaderContext or SoundLoaderContext

        /** Load progress info **/
        public var bytesLoaded : Number;
        public var bytesTotal : Number;
        public var progressRatio : Number;

        public function LazyItem()
		{
		}

		/**
		 *
		 * Starts the loading process.
		 *
		 * @param					p_url					URL to be loaded.
		 * @param					p_noCache				Prevent cache?
		 *
		 */
		public function load( p_url : String, p_noCache : Boolean ) : void
		{
			if(p_noCache && !isStandalone())
		    	url = noCacheURL(p_url);
		    else
		    	url = p_url;
		}

		/**
		 *
		 * Apply the 'noCache' param with random value to the file URL.
		 *
		 * @param					p_url					File URL.
		 * @return											File URL with 'noCache' param applied.
		 *
		 */
		public function noCacheURL( p_url : String ) : String
		{
			if(p_url == null) return "";
			return p_url.concat("?noCache=" + String(Math.random() * getTimer() * 1000).split(".").join(""));
		}

		/** Force conversion to String **/
		public function getAsText() : String
		{
			return null;
		}

		/** Force conversion to XML **/
		public function getAsXML() : XML
		{
			return null;
		}

		/** Force conversion to Sound **/
		public function getAsSound() : Sound
		{
			return null;
		}

		public function getAsBitmap() : Bitmap
		{
			return null;
		}

		/** Force conversion to NetStream **/
		public function getAsNetStream() : NetStream
		{
			return null;
		}

		/** Force conversion to MovieClip **/
		public function getAsMovieClip() : MovieClip
		{
			return null;
		}

		public function get data() : Object
		{
		    return {};
        }

		public function set data( value : Object ) : void
		{
		}

		public function dispose() : void
		{
		}

		override public function toString() : String
		{
			return "";
		}

	}

}