package rinaldi.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
    *
    *   LazyLoader item of text type.
    *
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *
	 */


	public class LazyItemText extends LazyItem {

        public var loader : URLLoader;

		public function LazyItemText()
		{
		}

		override public function load( p_url : String, p_noCache : Boolean ) : void
		{
		    super.load(p_url, p_noCache);

		    /** Creating the load proccess **/
		    loader = new URLLoader;
		    loader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		    loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		    loader.load(new URLRequest(url));
		}

		override public function getAsText() : String
		{
			return String(data);
		}

		override public function getAsXML() : XML
		{
			return XML(data);
		}

		override public function get data() : Object
		{
		    return _data;
        }

		override public function set data( value : Object ) : void
		{
		    _data = value;
        }

        public function loadProgressHandler( event : ProgressEvent ) : void
        {
        	/** Updating load progress info **/
		    bytesLoaded = event.bytesLoaded;
		    bytesTotal = event.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;

		    this.dispatchEvent(event);
        }

		public function loadCompleteHandler( event : Event ) : void
		{
			data = event.target["data"];

		    this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function errorHandler( event : IOErrorEvent ) : void
		{
			this.dispatchEvent(event);
		}

		override public function dispose() : void
		{
		    if(loader == null) return;

            loader.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		    loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

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
		    return "[LazyItemText]";
		}

	}

}