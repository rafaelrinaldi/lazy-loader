package com.rafaelrinaldi.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
    *
    * LazyLoader item of text type.
    *
    * @since Nov 26, 2009
    * @author Rafael Rinaldi (rafaelrinaldi.com)
    *
	*/
	public class LazyItemText extends LazyItem {

		/** <code>URLLoader</code> instance. **/
        public var loader : URLLoader;

		/**
		* Starts the loading process.
		* @param p_url File URL.
		* @param p_noCache Prevent cache?
		*/
		override public function load( p_url : String, p_noCache : Boolean ) : void
		{
		    super.load(p_url, p_noCache);

		    /** Creating the load proccess. **/
		    loader = new URLLoader;
		    loader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		    loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		    loader.load(new URLRequest(url));
		}

		/** Force conversion to <code>String</code>. **/
		override public function getAsText() : String
		{
			return String(data);
		}

		/** Force conversion to <code>XML</code>. **/
		override public function getAsXML() : XML
		{
			return XML(data);
		}

		/** Item raw data. **/
		override public function get data() : Object
		{
		    return _data;
        }

		override public function set data( value : Object ) : void
		{
		    _data = value;
        }

		/** Fired when load process is in progress. **/
        protected function loadProgressHandler( event : ProgressEvent ) : void
        {
        	/** Updating load progress info **/
		    bytesLoaded = event.bytesLoaded;
		    bytesTotal = event.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;

		    this.dispatchEvent(event);
        }

		/** Fired when load process finishes. **/
		protected function loadCompleteHandler( event : Event ) : void
		{
			data = event.target["data"];

		    this.dispatchEvent(new Event(Event.COMPLETE));
		}

		/** Fired when load process fails. **/
		protected function errorHandler( event : IOErrorEvent ) : void
		{
			this.dispatchEvent(event);
		}

		/** Clear from memory. **/
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

	}

}