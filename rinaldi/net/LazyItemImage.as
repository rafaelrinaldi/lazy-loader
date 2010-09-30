package rinaldi.net
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
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

		override public function load( p_url : String ) : void
		{
		    url = p_url;

		    /** Creating the load proccess **/
		    loader = new Loader();
		    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
		    loader.load(new URLRequest(url));
		}

		override public function getAsBitmap() : Bitmap
		{
			return Bitmap(data);
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

		    /** Dispatching a clone of ProgressEvent instance **/
		    this.dispatchEvent(event.clone());
		}

		public function loadCompleteHandler( event : Event ) : void
		{
			data = event.target["content"];

		    /** Dispatching the load complete event **/
		    this.dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function dispose() : void
		{
		    if(loader != null) {

		        if(loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS)) {
		            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		        }

		        if(loader.contentLoaderInfo.hasEventListener(Event.COMPLETE)) {
		            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		        }

		        try {
		            loader.close();
		        } catch( error : Error ) {
		            // None stream opened
		        }

		        loader = null;

		    }

		    data = null;
		}

		override public function toString() : String
		{
		    return "[LazyItemImage]";
		}

	}

}