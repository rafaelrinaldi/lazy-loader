package rinaldi.net
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
    *
    *   LazyLoader item of image type.
    *
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *
	 */


	public class LazyItemImage extends LazyItem {

        public var loader : Loader;

		public function LazyItemImage()
		{
		}

		override public function load( p_url : String, p_noCache : Boolean ) : void
		{
		    super.load(p_url, p_noCache);

		    /** Creating the load proccess **/
		    loader = new Loader;
		    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

		    loader.load(new URLRequest(url), context);
		}

		override public function getAsBitmap() : Bitmap
		{
			return Bitmap(data);
		}

		override public function getAsBitmapData() : BitmapData
		{
			return Bitmap(data).bitmapData;
		}

		override public function get data() : Object
		{
		    return _data;
        }

		override public function set data( value : Object ) : void
		{
		    _data = value;
        }

		public function loadProgressHandler( event : ProgressEvent ):void
		{
			/** Updating load progress info **/
		    bytesLoaded = event.bytesLoaded;
		    bytesTotal = event.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;

		    this.dispatchEvent(event);
		}

		public function loadCompleteHandler( event : Event ) : void
		{
			data = event.target["content"];

		    this.dispatchEvent(event);
		}

		public function errorHandler( event : IOErrorEvent ) : void
		{
			this.dispatchEvent(event);
		}

		override public function dispose() : void
		{
		    if(loader == null) return;

            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		    loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			// Try to close the Loader instance
		    try {
		    	loader.close();
			} catch( error : Error ) {
		    	// None stream opened
			}

		    loader = null;
		    data = null;
		}

		override public function toString() : String
		{
		    return "[LazyItemImage]";
		}

	}

}